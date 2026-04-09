import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Sweeping shimmer / shine effect.
///
/// Renders a diagonal shimmering highlight band that sweeps across the
/// widget surface in a continuous loop. The band includes subtle sparkle
/// noise and a soft halo for a polished, premium look.
///
/// Ideal for loading placeholders, premium card accents, skeleton screens,
/// or attention-drawing highlights.
///
/// ```dart
/// ShimmerEffect(
///   color: Colors.white,
///   child: Container(color: Colors.grey[300], width: 200, height: 50),
/// )
/// ```
class ShimmerEffect extends StatelessWidget {
  /// Creates a sweeping shimmer effect.
  ///
  /// The effect renders as a transparent overlay on top of [child].
  const ShimmerEffect({
    super.key,
    this.child,
    this.color = const Color(0x40FFFFFF),
    this.angle = 0.5,
    this.speed = 1.0,
    this.width = 0.3,
    this.enabled = true,
  });

  /// Child widget rendered behind the shimmer.
  final Widget? child;

  /// Shimmer highlight color. Defaults to semi-transparent white.
  ///
  /// The alpha channel of this color is not used directly; the shader
  /// computes alpha from the band shape. Use a bright, opaque color
  /// for best results.
  final Color color;

  /// Sweep angle in radians. Default 0.5 (~28 degrees).
  ///
  /// - `0.0`: horizontal sweep (left to right)
  /// - `pi/4` (~0.785): diagonal sweep
  /// - `pi/2` (~1.571): vertical sweep (top to bottom)
  final double angle;

  /// Animation speed multiplier. Default 1.0.
  final double speed;

  /// Shimmer band width as a fraction of the surface. Range: 0.05 to 1.0.
  ///
  /// Smaller values produce a thin, sharp highlight. Larger values
  /// create a wide, diffused glow.
  final double width;

  /// Whether the effect is active.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/shimmer.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, sz, time, i) {
        // uAngle (index 3)
        shader.setFloat(i, angle);
        // uSpeed (index 4)
        shader.setFloat(i + 1, speed.clamp(0.1, 5.0));
        // uColor (index 5-7)
        shader.setFloat(i + 2, color.r);
        shader.setFloat(i + 3, color.g);
        shader.setFloat(i + 4, color.b);
        // uWidth (index 8)
        shader.setFloat(i + 5, width.clamp(0.05, 1.0));
        return i + 6;
      },
      child: child,
    );
  }
}
