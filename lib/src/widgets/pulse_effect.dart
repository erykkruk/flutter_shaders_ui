import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Pulsing glow effect -- perfect for drawing attention to buttons or icons.
///
/// Renders a breathing, radial glow that expands and contracts from the
/// center. Includes expanding pulse rings and organic noise texturing for
/// a natural, alive appearance.
///
/// The effect renders as a transparent overlay, preserving the child
/// widget underneath.
///
/// ```dart
/// PulseEffect(
///   color: Colors.red,
///   speed: 1.5,
///   child: Icon(Icons.favorite, size: 48),
/// )
/// ```
class PulseEffect extends StatelessWidget {
  /// Creates a pulsing glow effect.
  ///
  /// The effect renders as an overlay on top of [child].
  const PulseEffect({
    super.key,
    this.child,
    this.color = const Color(0xFF2196F3),
    this.speed = 1.0,
    this.intensity = 0.5,
    this.enabled = true,
  });

  /// Child widget rendered behind the pulse glow.
  final Widget? child;

  /// Glow color. Defaults to Material Blue.
  final Color color;

  /// Pulse speed multiplier. Default 1.0. Higher values pulse faster.
  final double speed;

  /// Glow intensity. Range: 0.0 (invisible) to 1.0 (full brightness).
  final double intensity;

  /// Whether the effect is active.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/pulse.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, sz, time, i) {
        // uSpeed (index 3)
        shader.setFloat(i, speed.clamp(0.1, 5.0));
        // uIntensity (index 4)
        shader.setFloat(i + 1, intensity.clamp(0.0, 1.0));
        // uColor (index 5-7)
        shader.setFloat(i + 2, color.r);
        shader.setFloat(i + 3, color.g);
        shader.setFloat(i + 4, color.b);
        return i + 5;
      },
      child: child,
    );
  }
}
