import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Animated fire/flames effect rising from the bottom.
///
/// Uses layered noise functions (FBM, turbulence) for organic,
/// flickering flame movement with ember sparks. The flame shape
/// tapers naturally from a wide base to narrow tips.
///
/// Great for game UIs, dramatic backgrounds, or themed elements.
///
/// ```dart
/// FireEffect(
///   intensity: 0.7,
///   color1: Color(0xFFFFEB3B), // inner flame (yellow)
///   color2: Color(0xFFFF5722), // outer flame (deep orange)
///   child: Center(
///     child: Text('FIRE', style: TextStyle(color: Colors.white)),
///   ),
/// )
/// ```
class FireEffect extends StatelessWidget {
  /// Creates an animated fire effect.
  ///
  /// The effect renders as an overlay on top of [child].
  /// Flames rise from the bottom edge with organic flickering.
  const FireEffect({
    super.key,
    this.child,
    this.intensity = 0.6,
    this.speed = 1.0,
    this.color1 = const Color(0xFFFFEB3B),
    this.color2 = const Color(0xFFFF5722),
    this.enabled = true,
  });

  /// Child widget rendered behind the flames.
  final Widget? child;

  /// Flame height and intensity. Range: 0.0 (embers) to 1.0 (inferno).
  ///
  /// Controls how high the flames reach and their overall brightness.
  final double intensity;

  /// Animation speed multiplier. Default 1.0.
  ///
  /// Values above 1.0 make the flames flicker faster;
  /// values below 1.0 produce a slow, smoldering effect.
  final double speed;

  /// Inner flame color (the hottest part near the base).
  ///
  /// Defaults to bright yellow [Color(0xFFFFEB3B)].
  final Color color1;

  /// Outer flame color (tips and edges).
  ///
  /// Defaults to deep orange [Color(0xFFFF5722)].
  /// Use darker reds or purples for a mystical fire look.
  final Color color2;

  /// Whether the effect is active. When `false`, only [child] renders.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/fire.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, size, time, i) {
        shader.setFloat(i, intensity.clamp(0.0, 1.0));
        shader.setFloat(i + 1, speed);
        shader.setFloat(i + 2, color1.r);
        shader.setFloat(i + 3, color1.g);
        shader.setFloat(i + 4, color1.b);
        shader.setFloat(i + 5, color2.r);
        shader.setFloat(i + 6, color2.g);
        shader.setFloat(i + 7, color2.b);
        return i + 8;
      },
      child: child,
    );
  }
}
