import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Asset path to the glass fragment shader bundled with this package.
const String _glassShaderAsset =
    'packages/flutter_shaders_ui/shaders/glass.frag';

/// Default backdrop blur sigma in logical pixels.
const double _defaultBlurSigma = 16;

/// Default corner radius in logical pixels.
const double _defaultSurfaceRadius = 16;

/// Default frost grain amount.
const double _defaultFrost = 0.25;

/// Light-scattering amount fed to the glass shader. Kept low: the real
/// blur comes from the backdrop filter, the shader only adds texture.
const double _shaderScatter = 0.3;

/// Light-theme tint: white at 55% opacity.
const Color _lightTint = Color(0x8CFFFFFF);

/// Dark-theme tint: near-black at 45% opacity.
const Color _darkTint = Color(0x73101418);

/// Light-theme hairline border: white at 60% opacity.
const Color _lightBorder = Color(0x99FFFFFF);

/// Dark-theme hairline border: white at 14% opacity.
const Color _darkBorder = Color(0x24FFFFFF);

/// Default hairline border width in logical pixels.
const double _defaultBorderWidth = 1;

/// Frosted-glass surface for cards, app bars, bottom sheets and dialogs.
///
/// Blurs whatever is behind it with a real backdrop filter, tints it,
/// adds a hairline border, and lays a fine frost grain from the glass
/// shader underneath [child]. Unlike [GlassEffect], which only simulates
/// frost on top of its child, this surface actually blurs the content
/// behind it, so it is the one to reach for in everyday UI.
///
/// ```dart
/// FrostedSurface(
///   padding: const EdgeInsets.all(16),
///   child: const Text('Frosted card'),
/// )
/// ```
///
/// The grain is static by default, so after the first frame the surface
/// costs no more than a plain blurred container; set [animateFrost] for a
/// slowly drifting texture. The tint and border default to light or dark
/// variants based on the ambient [Theme]. If the shader cannot load, the
/// surface keeps its blur, tint and border and only loses the grain.
///
/// Backdrop blur is the expensive part on low-end devices: avoid stacking
/// many blurred surfaces on screen at once, or set [blurSigma] to `0`.
class FrostedSurface extends StatelessWidget {
  /// Creates a frosted-glass surface around [child].
  const FrostedSurface({
    super.key,
    this.child,
    this.blurSigma = _defaultBlurSigma,
    this.tint,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(_defaultSurfaceRadius)),
    this.borderColor,
    this.borderWidth = _defaultBorderWidth,
    this.frost = _defaultFrost,
    this.animateFrost = false,
    this.padding,
    this.enabled = true,
  })  : assert(blurSigma >= 0, 'blurSigma must not be negative.'),
        assert(borderWidth >= 0, 'borderWidth must not be negative.');

  /// Content shown on the surface.
  final Widget? child;

  /// Standard deviation of the backdrop blur. `0` disables the blur.
  final double blurSigma;

  /// Colour laid over the blurred backdrop. Use a translucent colour.
  ///
  /// Defaults to translucent white on light themes and translucent
  /// near-black on dark themes.
  final Color? tint;

  /// Corner radius of the surface. The blur is clipped to it.
  final BorderRadius borderRadius;

  /// Colour of the hairline border. Defaults to a theme-aware translucent
  /// white. Set [borderWidth] to `0` to remove the border.
  final Color? borderColor;

  /// Width of the hairline border in logical pixels. Default 1.
  final double borderWidth;

  /// Amount of frost grain from the glass shader. Range: 0.0 to 1.0.
  ///
  /// `0` skips the shader entirely.
  final double frost;

  /// Whether the frost grain drifts over time. Default `false`.
  ///
  /// A static grain is rendered once and costs nothing per frame; an
  /// animated one repaints every frame (subject to [ShaderPerformance]).
  final bool animateFrost;

  /// Padding between the surface edge and [child].
  final EdgeInsetsGeometry? padding;

  /// Whether the frosted styling is applied. When `false`, only [child]
  /// (with [padding]) renders.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final content =
        padding == null ? child : Padding(padding: padding!, child: child);

    if (!enabled) {
      return content ?? const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final frostAmount = frost.clamp(0.0, 1.0);

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: tint ?? (isDark ? _darkTint : _lightTint),
        borderRadius: borderRadius,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? (isDark ? _darkBorder : _lightBorder),
                width: borderWidth,
              )
            : null,
      ),
      child: frostAmount > 0
          ? ShaderEffectWidget(
              assetPath: _glassShaderAsset,
              timeScale: animateFrost ? 1.0 : 0.0,
              uniformSetter: (shader, size, time, i) =>
                  _setUniforms(shader, i, frostAmount),
              child: content,
            )
          : content,
    );

    if (blurSigma > 0) {
      surface = BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: surface,
      );
    }

    return ClipRRect(borderRadius: borderRadius, child: surface);
  }

  static int _setUniforms(ui.FragmentShader shader, int index, double frost) {
    // The tint and opacity come from the DecoratedBox; the shader adds
    // only white grain and highlights, so its own opacity stays at zero.
    shader.setFloat(index, _shaderScatter);
    shader.setFloat(index + 1, frost);
    shader.setFloat(index + 2, 0.0);
    shader.setFloat(index + 3, 1.0);
    shader.setFloat(index + 4, 1.0);
    shader.setFloat(index + 5, 1.0);
    return index + 6;
  }
}
