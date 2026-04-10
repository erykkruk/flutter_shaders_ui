import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Animated water surface background with caustic light patterns.
///
/// Renders a realistic top-down water effect with dancing caustic lights,
/// wave distortion, optional foam, and depth-based color gradients.
/// Perfect for ocean/pool themed backgrounds, cards, and splash screens.
///
/// The effect combines multiple techniques:
/// - **Caustics** — dancing light patterns refracted through the water surface
/// - **Wave distortion** — subtle organic surface ripple movement
/// - **Foam** — white frothy patches for an ocean look
/// - **Depth gradient** — lighter shallow areas, darker deep areas
/// - **Surface highlights** — specular reflections on wave crests
///
/// ```dart
/// WaterEffect(
///   color1: Color(0xFF00BCD4), // shallow turquoise
///   color2: Color(0xFF0D47A1), // deep navy
///   causticIntensity: 0.7,
///   child: Center(child: Text('Dive In', style: TextStyle(color: Colors.white))),
/// )
/// ```
class WaterEffect extends StatelessWidget {
  /// Creates an animated water surface effect.
  ///
  /// - [color1] is the shallow water color (lighter).
  /// - [color2] is the deep water color (darker).
  /// - [speed] controls animation speed (`1.0` = normal).
  /// - [depth] controls how deep the water looks (`0.0` = shallow, `1.0` = deep).
  /// - [waveIntensity] controls wave distortion (`0.0` = calm, `1.0` = stormy).
  /// - [causticIntensity] controls caustic brightness (`0.0` = none, `1.0` = bright).
  /// - [foamAmount] controls foam/froth amount (`0.0` = none, `1.0` = heavy foam).
  /// - [enabled] toggles the shader on/off (renders only [child] when off).
  const WaterEffect({
    super.key,
    this.child,
    this.color1 = const Color(0xFF26C6DA),
    this.color2 = const Color(0xFF0D47A1),
    this.speed = 1.0,
    this.depth = 0.5,
    this.waveIntensity = 0.5,
    this.causticIntensity = 0.6,
    this.foamAmount = 0.0,
    this.enabled = true,
  });

  /// Optional child widget rendered on top of the water effect.
  final Widget? child;

  /// Shallow water color (bright, near-surface areas).
  ///
  /// Defaults to a light cyan/turquoise.
  final Color color1;

  /// Deep water color (dark, deep areas).
  ///
  /// Defaults to a deep navy blue.
  final Color color2;

  /// Animation speed multiplier. `1.0` is normal, `0.5` is half speed.
  ///
  /// Defaults to `1.0`.
  final double speed;

  /// Water depth factor. Range: `0.0` (shallow pool) to `1.0` (deep ocean).
  ///
  /// Controls how much the color darkens and how the caustics distribute.
  /// Defaults to `0.5`.
  final double depth;

  /// Wave distortion intensity. Range: `0.0` (calm) to `1.0` (stormy).
  ///
  /// Controls how much the surface ripples and distorts.
  /// Defaults to `0.5`.
  final double waveIntensity;

  /// Caustic light pattern intensity. Range: `0.0` (none) to `1.0` (bright).
  ///
  /// Controls the brightness of the dancing light patterns refracted
  /// through the water surface. This is the main visual feature.
  /// Defaults to `0.6`.
  final double causticIntensity;

  /// Foam/froth amount. Range: `0.0` (no foam) to `1.0` (heavy foam).
  ///
  /// Adds white frothy patches for an ocean/surf look.
  /// Defaults to `0.0` (off).
  final double foamAmount;

  /// Whether the shader effect is active.
  ///
  /// When `false`, only [child] is rendered (no GPU cost).
  final bool enabled;

  static const _assetPath = 'packages/flutter_shaders_ui/shaders/water.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      uniformSetter: (shader, size, time, i) {
        shader.setFloat(i, speed);
        shader.setFloat(i + 1, depth.clamp(0.0, 1.0));
        shader.setFloat(i + 2, waveIntensity.clamp(0.0, 1.0));
        shader.setFloat(i + 3, causticIntensity.clamp(0.0, 1.0));
        shader.setFloat(i + 4, foamAmount.clamp(0.0, 1.0));
        shader.setFloat(i + 5, color1.r);
        shader.setFloat(i + 6, color1.g);
        shader.setFloat(i + 7, color1.b);
        shader.setFloat(i + 8, color2.r);
        shader.setFloat(i + 9, color2.g);
        shader.setFloat(i + 10, color2.b);
        return i + 11;
      },
      child: child,
    );
  }
}
