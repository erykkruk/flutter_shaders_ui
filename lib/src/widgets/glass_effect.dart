import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Frosted glass / glassmorphism effect overlay.
///
/// Simulates frosted glass with noise-based frost patterns, crystalline
/// voronoi textures, internal light refractions, and a tinted
/// semi-transparent overlay. Ideal for cards, modals, and bottom sheets.
///
/// Since Flutter fragment shaders cannot sample child pixels, the effect
/// creates the frosted glass illusion via procedural noise, specular
/// highlights, and light-scattering simulation.
///
/// ```dart
/// GlassEffect(
///   frost: 0.5,
///   opacity: 0.3,
///   tint: Colors.white,
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Glass card'),
///   ),
/// )
/// ```
class GlassEffect extends StatelessWidget {
  /// Creates a frosted glass effect.
  ///
  /// The effect renders as an overlay on top of [child].
  /// All parameters are clamped to their valid ranges internally.
  const GlassEffect({
    super.key,
    this.child,
    this.blurAmount = 0.5,
    this.frost = 0.4,
    this.opacity = 0.3,
    this.tint = const Color(0xFFFFFFFF),
    this.enabled = true,
  });

  /// Child widget rendered behind the glass effect.
  final Widget? child;

  /// Simulated blur intensity. Range: 0.0 (clear) to 1.0 (heavy diffusion).
  ///
  /// Controls the light-scattering noise that simulates a blurred surface.
  final double blurAmount;

  /// Frost noise amount. Range: 0.0 (clear glass) to 1.0 (heavy frost).
  ///
  /// Higher values produce more visible crystalline frost patterns.
  final double frost;

  /// Overall opacity of the glass overlay. Range: 0.0 to 1.0.
  final double opacity;

  /// Tint color applied to the glass surface.
  ///
  /// Use white for a neutral frosted glass, or colored values
  /// for tinted glass effects (e.g., blue, pink).
  final Color tint;

  /// Whether the effect is active. When `false`, only [child] renders.
  final bool enabled;

  /// Asset path for the shader. Uses package path for pub.dev compatibility.
  static const _assetPath = 'packages/flutter_shaders_ui/shaders/glass.frag';

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (shader, size, time, i) {
        shader.setFloat(i, blurAmount.clamp(0.0, 1.0));
        shader.setFloat(i + 1, frost.clamp(0.0, 1.0));
        shader.setFloat(i + 2, opacity.clamp(0.0, 1.0));
        shader.setFloat(i + 3, tint.r);
        shader.setFloat(i + 4, tint.g);
        shader.setFloat(i + 5, tint.b);
        return i + 6;
      },
      child: child,
    );
  }
}
