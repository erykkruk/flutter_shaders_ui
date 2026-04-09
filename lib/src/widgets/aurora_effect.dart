import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Animated aurora borealis (northern lights) effect.
///
/// Renders flowing, translucent curtain-like bands that drift organically
/// across the widget area. Multiple layered bands blend between two colors
/// with domain-warped noise for realistic movement.
///
/// The effect renders as a transparent overlay, making it suitable for
/// layering on top of existing content such as cards, headers, or
/// backgrounds.
///
/// ```dart
/// AuroraEffect(
///   color1: Colors.green,
///   color2: Colors.purple,
///   child: MyContent(),
/// )
/// ```
class AuroraEffect extends StatelessWidget {
  /// Creates an animated aurora borealis effect.
  ///
  /// The effect renders as an overlay on top of [child].
  /// Colors are passed as RGB floats to the shader.
  const AuroraEffect({
    super.key,
    this.child,
    this.color1 = const Color(0xFF00E676),
    this.color2 = const Color(0xFFAA00FF),
    this.intensity = 0.6,
    this.speed = 1.0,
    this.enabled = true,
  });

  /// Child widget rendered behind the aurora.
  final Widget? child;

  /// Primary aurora color. Defaults to bright green.
  final Color color1;

  /// Secondary aurora color. Defaults to vivid purple.
  final Color color2;

  /// Glow intensity. Range: 0.0 (invisible) to 1.0 (full brightness).
  final double intensity;

  /// Animation speed multiplier. Default 1.0.
  final double speed;

  /// Whether the effect is active.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/aurora.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, sz, time, i) {
        // uIntensity (index 3)
        shader.setFloat(i, intensity.clamp(0.0, 1.0));
        // uSpeed (index 4)
        shader.setFloat(i + 1, speed.clamp(0.1, 5.0));
        // uColor1 (index 5-7)
        shader.setFloat(i + 2, color1.r);
        shader.setFloat(i + 3, color1.g);
        shader.setFloat(i + 4, color1.b);
        // uColor2 (index 8-10)
        shader.setFloat(i + 5, color2.r);
        shader.setFloat(i + 6, color2.g);
        shader.setFloat(i + 7, color2.b);
        return i + 8;
      },
      child: child,
    );
  }
}
