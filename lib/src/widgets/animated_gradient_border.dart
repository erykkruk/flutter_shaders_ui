import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Asset path to the gradient border fragment shader bundled with this
/// package.
const String _gradientBorderShaderAsset =
    'packages/flutter_shaders_ui/shaders/gradient_border.frag';

/// Default gradient: violet, cyan, pink.
const List<Color> _defaultBorderColors = [
  Color(0xFF7C3AED),
  Color(0xFF06B6D4),
  Color(0xFFF472B6),
];

/// Number of colour stops the shader has uniforms for.
const int _maxBorderColors = 4;

/// Default ring thickness in logical pixels.
const double _defaultBorderWidth = 2;

/// Default outer corner radius in logical pixels.
const double _defaultBorderRadius = 12;

/// Rotating multi-colour gradient border with an optional soft glow.
///
/// Draws a rounded-rectangle ring around [child] whose sweep gradient
/// rotates continuously. Use it to mark a selected card, a focused field,
/// a premium or AI-powered action, or simply to make a primary button
/// stand out.
///
/// ```dart
/// AnimatedGradientBorder(
///   child: FilledButton(
///     onPressed: () {},
///     child: const Text('Upgrade'),
///   ),
/// )
/// ```
///
/// [child] is inset by [borderWidth] (plus [glowSpread]) so the ring sits
/// around it rather than over it; give the child a corner radius of about
/// `borderRadius - borderWidth` for a snug fit. With reduced motion the
/// gradient stops rotating but the border stays. If the shader cannot
/// load, only the (inset) child renders.
class AnimatedGradientBorder extends StatelessWidget {
  /// Creates a rotating gradient border around [child].
  ///
  /// [colors] must not be empty; only the first four are used.
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.colors = _defaultBorderColors,
    this.borderWidth = _defaultBorderWidth,
    this.borderRadius = _defaultBorderRadius,
    this.speed = 1.0,
    this.glow = 0.0,
    this.glowSpread = 0.0,
    this.enabled = true,
  })  : assert(borderWidth >= 0, 'borderWidth must not be negative.'),
        assert(borderRadius >= 0, 'borderRadius must not be negative.'),
        assert(glowSpread >= 0, 'glowSpread must not be negative.');

  /// The widget the border is drawn around.
  final Widget child;

  /// Gradient stops. The gradient wraps around, so the last colour blends
  /// back into the first.
  ///
  /// Up to four colours are used and any extra ones are ignored. A single
  /// colour draws a solid ring. Must not be empty.
  final List<Color> colors;

  /// Thickness of the ring in logical pixels. Default 2.
  final double borderWidth;

  /// Outer corner radius of the ring in logical pixels. Default 12.
  ///
  /// Clamped to half the shortest side, so a large value gives a pill.
  final double borderRadius;

  /// Rotation speed multiplier. Default 1.0 (one turn every 4 seconds).
  ///
  /// `0` keeps the gradient still and stops repainting.
  final double speed;

  /// Strength of the soft glow outside the ring. Range: 0.0 to 1.0.
  ///
  /// Only visible when [glowSpread] is greater than zero.
  final double glow;

  /// Space reserved outside the ring for the glow, in logical pixels.
  ///
  /// Grows the widget by this amount on every side, so toggling it changes
  /// layout. Keep it constant and animate [glow] instead to show and hide
  /// the glow without moving anything.
  final double glowSpread;

  /// Whether the border is drawn. When `false`, only the inset [child]
  /// renders, so the layout does not shift when toggling.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Checked here rather than in the constructor: `List.length` cannot be
    // evaluated in a const constructor's assert.
    assert(colors.isNotEmpty, 'colors must not be empty.');
    final pixel = 1 / MediaQuery.devicePixelRatioOf(context);

    return ShaderEffectWidget(
      assetPath: _gradientBorderShaderAsset,
      enabled: enabled,
      showAsOverlay: true,
      // Speed goes through timeScale so that `0` stops the ticker.
      timeScale: speed,
      uniformSetter: (shader, size, time, i) => _setUniforms(shader, i, pixel),
      child: Padding(
        padding: EdgeInsets.all(glowSpread + borderWidth),
        child: child,
      ),
    );
  }

  int _setUniforms(ui.FragmentShader shader, int index, double pixel) {
    final count = math.min(colors.length, _maxBorderColors);
    var i = index;
    for (var stop = 0; stop < _maxBorderColors; stop++) {
      // Unused uniform slots repeat the last colour; the shader only reads
      // the first `count` of them.
      final color = colors[math.min(stop, count - 1)];
      shader.setFloat(i++, color.r);
      shader.setFloat(i++, color.g);
      shader.setFloat(i++, color.b);
      shader.setFloat(i++, color.a);
    }
    shader.setFloat(i++, count.toDouble());
    shader.setFloat(i++, borderWidth);
    shader.setFloat(i++, borderRadius);
    shader.setFloat(i++, glowSpread);
    shader.setFloat(i++, glow.clamp(0.0, 1.0));
    shader.setFloat(i++, pixel);
    return i;
  }
}
