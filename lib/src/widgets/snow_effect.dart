import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Animated snow particles falling over a child widget.
///
/// Renders semi-transparent snowflakes with parallax depth effect.
/// Multiple layers create a natural sense of depth, and each flake
/// drifts with organic wind turbulence.
///
/// Perfect for seasonal UI, splash screens, or festive backgrounds.
///
/// ```dart
/// SnowEffect(
///   density: 0.6,
///   speed: 1.0,
///   child: MyContent(),
/// )
/// ```
class SnowEffect extends StatelessWidget {
  /// Creates an animated snow effect.
  ///
  /// The effect renders as an overlay on top of [child].
  /// All parameters are clamped to their valid ranges internally.
  const SnowEffect({
    super.key,
    this.child,
    this.density = 0.5,
    this.speed = 1.0,
    this.size = 0.5,
    this.enabled = true,
  });

  /// Child widget rendered behind the snow.
  final Widget? child;

  /// Snow particle density. Range: 0.0 (sparse) to 1.0 (blizzard).
  final double density;

  /// Fall speed multiplier. Default 1.0. Range: 0.1 to 2.0.
  final double speed;

  /// Snowflake size multiplier. Range: 0.0 to 1.0.
  final double size;

  /// Whether the effect is active.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/snow.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, sz, time, i) {
        shader.setFloat(i, density.clamp(0.0, 1.0));
        shader.setFloat(i + 1, speed.clamp(0.1, 2.0));
        shader.setFloat(i + 2, size.clamp(0.0, 1.0));
        return i + 3;
      },
      child: child,
    );
  }
}
