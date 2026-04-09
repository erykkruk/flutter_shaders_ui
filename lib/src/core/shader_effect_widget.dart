import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'shader_cache.dart';

/// Callback to configure shader uniforms each frame.
///
/// - [shader]: the fragment shader instance
/// - [size]: current widget size in logical pixels
/// - [time]: elapsed time in seconds
/// - [index]: starting uniform float index (after standard uniforms)
///
/// Must return the next available uniform index.
typedef ShaderUniformSetter = int Function(
  ui.FragmentShader shader,
  Size size,
  double time,
  int index,
);

/// Base widget for rendering animated GLSL fragment shaders.
///
/// Manages shader loading (via [ShaderCache]), time animation, and
/// size management. All shaders get standard uniforms:
///
/// | Index | GLSL uniform | Description |
/// |-------|-------------|-------------|
/// | 0-1 | `vec2 uResolution` | Widget width & height |
/// | 2 | `float uTime` | Elapsed seconds |
///
/// Additional uniforms can be set via [uniformSetter] starting at index 3.
///
/// ```dart
/// ShaderEffectWidget(
///   assetPath: 'packages/flutter_shaders_ui/shaders/snow.frag',
///   child: Text('Hello'),
/// )
/// ```
class ShaderEffectWidget extends StatefulWidget {
  /// Creates a shader effect widget.
  const ShaderEffectWidget({
    super.key,
    required this.assetPath,
    this.child,
    this.uniformSetter,
    this.enabled = true,
    this.showAsOverlay = false,
  });

  /// Path to the `.frag` shader asset.
  final String assetPath;

  /// Optional child widget. Rendered behind or under the shader effect.
  final Widget? child;

  /// Callback to set custom uniforms beyond the standard ones.
  final ShaderUniformSetter? uniformSetter;

  /// Whether the shader is active. When `false`, only [child] renders.
  final bool enabled;

  /// If `true`, shader renders as overlay on top of [child].
  /// If `false` (default), shader renders as background behind [child].
  final bool showAsOverlay;

  @override
  State<ShaderEffectWidget> createState() => _ShaderEffectWidgetState();
}

class _ShaderEffectWidgetState extends State<ShaderEffectWidget>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;
  late final Ticker _ticker;
  final _time = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _loadShader();
  }

  Future<void> _loadShader() async {
    final program = await ShaderCache.load(widget.assetPath);
    if (!mounted) return;
    setState(() => _program = program);
    if (widget.enabled) _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  void didUpdateWidget(ShaderEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_ticker.isActive && _program != null) {
      _ticker.start();
    } else if (!widget.enabled && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _program == null) {
      return widget.child ?? const SizedBox.shrink();
    }

    final shaderWidget = RepaintBoundary(
      child: CustomPaint(
        willChange: true,
        painter: _ShaderEffectPainter(
          program: _program!,
          time: _time,
          uniformSetter: widget.uniformSetter,
        ),
      ),
    );

    if (widget.child == null) {
      return shaderWidget;
    }

    final children = widget.showAsOverlay
        ? [widget.child!, Positioned.fill(child: shaderWidget)]
        : [Positioned.fill(child: shaderWidget), widget.child!];

    return Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}

class _ShaderEffectPainter extends CustomPainter {
  _ShaderEffectPainter({
    required this.program,
    required this.time,
    this.uniformSetter,
  }) : super(repaint: time);

  final ui.FragmentProgram program;
  final ValueNotifier<double> time;
  final ShaderUniformSetter? uniformSetter;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    final t = time.value;

    // Standard uniforms
    var i = 0;
    shader.setFloat(i++, size.width); // uResolution.x
    shader.setFloat(i++, size.height); // uResolution.y
    shader.setFloat(i++, t); // uTime

    // Custom uniforms
    if (uniformSetter != null) {
      uniformSetter!(shader, size, t, i);
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(_ShaderEffectPainter oldDelegate) => true;
}
