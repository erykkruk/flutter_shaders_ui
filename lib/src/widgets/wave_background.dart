import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Animated wave gradient background.
///
/// Renders flowing, organic wave patterns with customizable colors.
/// Perfect for backgrounds, cards, headers, and splash screens.
///
/// Multiple overlapping sine waves with varying frequencies create a
/// fluid, ocean-like motion. The effect blends [color1] into [color2]
/// along a vertical gradient that undulates with the waves.
///
/// ```dart
/// WaveBackground(
///   color1: Color(0xFF1A237E),
///   color2: Color(0xFF00BCD4),
///   child: Center(child: Text('Hello', style: TextStyle(color: Colors.white))),
/// )
/// ```
class WaveBackground extends StatelessWidget {
  /// Creates an animated wave gradient background.
  ///
  /// - [color1] is the primary (top) color.
  /// - [color2] is the secondary (bottom) color.
  /// - [amplitude] controls wave height (`0.0` = flat, `1.0` = dramatic).
  /// - [frequency] controls wave density (`0.0` = smooth, `5.0` = dense).
  /// - [speed] controls animation speed (`1.0` = normal).
  /// - [enabled] toggles the shader on/off (renders only [child] when off).
  const WaveBackground({
    super.key,
    this.child,
    this.color1 = const Color(0xFF1A237E),
    this.color2 = const Color(0xFF00BCD4),
    this.amplitude = 0.3,
    this.frequency = 2.0,
    this.speed = 1.0,
    this.enabled = true,
  });

  /// Optional child widget rendered on top of the wave background.
  final Widget? child;

  /// Primary color of the gradient (top / wave peaks).
  final Color color1;

  /// Secondary color of the gradient (bottom / wave troughs).
  final Color color2;

  /// Wave height factor. Range: `0.0` (flat) to `1.0` (dramatic).
  ///
  /// Defaults to `0.3` for a subtle, elegant motion.
  final double amplitude;

  /// Wave density factor. Range: `0.0` (smooth) to `5.0` (dense ripples).
  ///
  /// Defaults to `2.0` for balanced, natural-looking waves.
  final double frequency;

  /// Animation speed multiplier. `1.0` is normal, `0.5` is half speed.
  ///
  /// Defaults to `1.0`.
  final double speed;

  /// Whether the shader effect is active.
  ///
  /// When `false`, only [child] is rendered (no GPU cost).
  final bool enabled;

  static const _assetPath = 'packages/flutter_shaders_ui/shaders/wave.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      uniformSetter: (shader, size, time, i) {
        shader.setFloat(i, amplitude);
        shader.setFloat(i + 1, frequency);
        shader.setFloat(i + 2, speed);
        shader.setFloat(i + 3, color1.r);
        shader.setFloat(i + 4, color1.g);
        shader.setFloat(i + 5, color1.b);
        shader.setFloat(i + 6, color2.r);
        shader.setFloat(i + 7, color2.g);
        shader.setFloat(i + 8, color2.b);
        return i + 9;
      },
      child: child,
    );
  }
}
