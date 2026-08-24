import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'shader_cache.dart';
import 'shader_performance.dart';

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
    this.timeScale = 1.0,
    this.maxFramesPerSecond,
    this.respectReducedMotion,
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

  /// Multiplier applied to the elapsed time fed into the `uTime` uniform.
  ///
  /// Controls the speed of the global animation clock for every shader,
  /// which the per-widget `speed` uniforms cannot do:
  ///
  /// - `1.0` (default) runs at real time.
  /// - `0.5` runs at half speed; `2.0` at double speed.
  /// - `0.0` freezes the animation on its current frame.
  /// - Negative values run the animation in reverse.
  final double timeScale;

  /// Upper bound on repaints per second for this effect.
  ///
  /// Null defers to the nearest [ShaderPerformance] ancestor, and then to
  /// the display refresh rate. A cap only skips repaints: the clock still
  /// advances in real time, so the motion keeps its speed.
  final int? maxFramesPerSecond;

  /// Whether to freeze the animation when the platform asks for reduced
  /// motion.
  ///
  /// Null defers to the nearest [ShaderPerformance] ancestor, which
  /// defaults to honouring the request.
  final bool? respectReducedMotion;

  @override
  State<ShaderEffectWidget> createState() => _ShaderEffectWidgetState();
}

class _ShaderEffectWidgetState extends State<ShaderEffectWidget>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;

  /// One shader instance for the widget's lifetime.
  ///
  /// Creating one per paint allocated a native object on every frame and
  /// never released it; uniforms are meant to be rewritten between draws.
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  final _time = ValueNotifier<double>(0);

  /// Elapsed time of the last repaint, used to honour the frame cap.
  Duration _lastFrame = Duration.zero;

  ShaderPerformanceSettings _settings = const ShaderPerformanceSettings();
  bool _reducedMotion = false;

  /// Set when the shader could not be loaded, so the widget renders its
  /// child instead of retrying every build.
  bool _loadFailed = false;

  /// Whether the shader failed to load and the effect degraded to its child.
  ///
  /// Exposed for tests and debug overlays.
  bool get loadFailed => _loadFailed;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final program = await ShaderCache.load(widget.assetPath);
      if (!mounted) return;
      setState(() {
        _program = program;
        _shader = program.fragmentShader();
      });
      _syncTicker();
    } catch (error, stackTrace) {
      // A missing or uncompilable shader must degrade to the child rather
      // than take the whole subtree down: the effect is decoration, the
      // child is content.
      if (mounted) {
        setState(() => _loadFailed = true);
      }
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'flutter_shaders_ui',
          context: ErrorDescription(
            'while loading the shader "${widget.assetPath}"',
          ),
        ),
      );
    }
  }

  /// Whether the animation clock should advance at all.
  bool get _shouldAnimate {
    if (!widget.enabled || _program == null) return false;
    final respectReduced =
        widget.respectReducedMotion ?? _settings.respectReducedMotion;
    // Reduced motion freezes the clock but keeps the effect rendered, so
    // the design survives as a still image.
    return !(respectReduced && _reducedMotion);
  }

  void _syncTicker() {
    if (_shouldAnimate && !_ticker.isActive) {
      _ticker.start();
    } else if (!_shouldAnimate && _ticker.isActive) {
      _ticker.stop();
    }
  }

  /// Minimum gap between repaints, widget setting first.
  Duration? get _frameInterval {
    final perWidget = widget.maxFramesPerSecond;
    if (perWidget != null) {
      return Duration(microseconds: (1000000 / perWidget).round());
    }
    return _settings.minimumFrameInterval;
  }

  void _onTick(Duration elapsed) {
    final interval = _frameInterval;
    if (interval != null && elapsed - _lastFrame < interval) {
      // Skip the repaint, but leave the clock alone: capping the frame rate
      // must not slow the motion down.
      return;
    }
    _lastFrame = elapsed;
    _time.value = elapsed.inMicroseconds / 1e6 * widget.timeScale;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ShaderPerformance.of(context);
    _reducedMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _syncTicker();
  }

  @override
  void didUpdateWidget(ShaderEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.assetPath != oldWidget.assetPath) {
      _shader?.dispose();
      _shader = null;
      _program = null;
      _loadFailed = false;
      _lastFrame = Duration.zero;
      _loadShader();
      return;
    }
    _syncTicker();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (!widget.enabled || shader == null) {
      return widget.child ?? const SizedBox.shrink();
    }

    final shaderWidget = RepaintBoundary(
      child: SizedBox.expand(
        child: CustomPaint(
          willChange: _shouldAnimate,
          painter: _ShaderEffectPainter(
            shader: shader,
            time: _time,
            uniformSetter: widget.uniformSetter,
          ),
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
    required this.shader,
    required this.time,
    this.uniformSetter,
  }) : super(repaint: time);

  /// Owned by the widget state, not by this painter: painters are rebuilt
  /// on every build, so allocating a shader here would leak one per build.
  final ui.FragmentShader shader;
  final ValueNotifier<double> time;
  final ShaderUniformSetter? uniformSetter;

  @override
  void paint(Canvas canvas, Size size) {
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
  bool shouldRepaint(_ShaderEffectPainter oldDelegate) =>
      oldDelegate.shader != shader ||
      oldDelegate.uniformSetter != uniformSetter;
}
