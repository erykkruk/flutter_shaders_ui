import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Default ripple animation duration.
const Duration _defaultRippleDuration = Duration(milliseconds: 800);

/// Default ripple effect intensity.
const double _defaultRippleIntensity = 1.0;

/// Asset path to the ripple fragment shader bundled with this package.
const String _rippleShaderAsset =
    'packages/flutter_shaders_ui/shaders/ripple.frag';

/// Tap-triggered ripple wave effect overlay.
///
/// Wraps a child widget and shows an expanding wave from the tap point.
/// Great for buttons, cards, and interactive elements.
///
/// The effect is rendered as a transparent overlay on top of the child,
/// so it does not obscure the underlying content beyond the ripple itself.
///
/// ```dart
/// RippleEffect(
///   color: Colors.blue,
///   duration: Duration(milliseconds: 800),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: Text('Tap me'),
///   ),
/// )
/// ```
class RippleEffect extends StatefulWidget {
  /// Creates a ripple effect that triggers on tap.
  ///
  /// The [child] widget is rendered normally and the ripple animates
  /// on top of it as a transparent overlay.
  const RippleEffect({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.duration = _defaultRippleDuration,
    this.intensity = _defaultRippleIntensity,
    this.onTap,
  });

  /// The widget to wrap with the ripple effect.
  final Widget child;

  /// The color of the ripple wave.
  ///
  /// Defaults to [Colors.white]. Use semi-bright colors for best visibility
  /// on dark backgrounds, or darker tones for light backgrounds.
  final Color color;

  /// How long the ripple animation lasts from start to finish.
  ///
  /// Defaults to 800 milliseconds.
  final Duration duration;

  /// Strength of the ripple effect.
  ///
  /// A value of `1.0` is the default. Higher values produce more visible
  /// rings; lower values make the effect subtler.
  final double intensity;

  /// Optional callback invoked on tap, in addition to triggering the ripple.
  ///
  /// This allows the widget to act as both a visual effect and a tap handler
  /// without requiring an additional [GestureDetector] wrapper.
  final VoidCallback? onTap;

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  /// Normalized touch position (0-1 range relative to widget bounds).
  double _touchX = 0.5;
  double _touchY = 0.5;

  /// Whether the shader should be active (only during animation).
  bool _shaderEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(RippleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      setState(() => _shaderEnabled = false);
    }
  }

  void _onTapDown(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = details.localPosition;
    final size = box.size;

    setState(() {
      _touchX = (localPosition.dx / size.width).clamp(0.0, 1.0);
      _touchY = (localPosition.dy / size.height).clamp(0.0, 1.0);
      _shaderEnabled = true;
    });

    // Reset and play forward — handles rapid successive taps.
    _controller
      ..reset()
      ..forward();

    widget.onTap?.call();
  }

  int _setUniforms(
    ui.FragmentShader shader,
    Size size,
    double time,
    int index,
  ) {
    var i = index;

    // uTouchPoint (vec2, normalized 0-1)
    shader.setFloat(i++, _touchX);
    shader.setFloat(i++, _touchY);

    // uProgress (float, 0.0 - 1.0)
    shader.setFloat(i++, _controller.value);

    // uIntensity (float)
    shader.setFloat(i++, widget.intensity);

    // uColor (vec3, RGB 0-1)
    shader.setFloat(i++, widget.color.r);
    shader.setFloat(i++, widget.color.g);
    shader.setFloat(i++, widget.color.b);

    return i;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderEffectWidget(
            assetPath: _rippleShaderAsset,
            enabled: _shaderEnabled,
            showAsOverlay: true,
            uniformSetter: _setUniforms,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
