import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/shader_effect_widget.dart';

/// Asset path to the skeleton fragment shader bundled with this package.
const String _skeletonShaderAsset =
    'packages/flutter_shaders_ui/shaders/skeleton.frag';

/// Bone colour on a light theme.
const Color _lightBaseColor = Color(0xFFE3E5E8);

/// Sweep colour on a light theme.
const Color _lightHighlightColor = Color(0xFFF6F7F9);

/// Bone colour on a dark theme.
const Color _darkBaseColor = Color(0xFF2B2F36);

/// Sweep colour on a dark theme.
const Color _darkHighlightColor = Color(0xFF474E5A);

/// Default duration of the cross-fade from placeholder to content.
const Duration _defaultFadeDuration = Duration(milliseconds: 250);

/// Default sweep angle: a gentle diagonal, top-left to bottom-right.
const double _defaultSweepAngle = 0.35;

/// Default band width as a fraction of the surface.
const double _defaultBandWidth = 0.35;

/// Smallest and largest band widths the shader handles well.
const double _minBandWidth = 0.05;
const double _maxBandWidth = 1.0;

/// Default corner radius of a [SkeletonBone].
const double _defaultBoneRadius = 6;

/// Default height of a [SkeletonBone], roughly one line of body text.
const double _defaultBoneHeight = 14;

/// Shimmering skeleton placeholder shown while content loads.
///
/// While [isLoading] is `true`, renders [placeholder] (or [child] itself
/// when no placeholder is given) as a skeleton: every pixel it paints is
/// recoloured to [baseColor] and a [highlightColor] band sweeps across it.
/// Gaps between the shapes stay transparent, so the skeleton follows the
/// real layout. When [isLoading] turns `false`, it cross-fades to [child].
///
/// ```dart
/// ShaderSkeleton(
///   isLoading: user == null,
///   placeholder: const Row(
///     children: [
///       SkeletonBone.circle(size: 40),
///       SizedBox(width: 12),
///       Expanded(child: SkeletonBone()),
///     ],
///   ),
///   child: UserTile(user: user),
/// )
/// ```
///
/// Colours default to light or dark variants based on the ambient [Theme].
/// While loading, the skeleton ignores pointer input and is announced to
/// assistive technologies as [semanticsLabel] instead of its contents.
/// With reduced motion the sweep stops and the bones stay static. If the
/// shader cannot load, the placeholder renders as-is.
class ShaderSkeleton extends StatelessWidget {
  /// Creates a skeleton placeholder that swaps to [child] once loaded.
  const ShaderSkeleton({
    super.key,
    required this.isLoading,
    required this.child,
    this.placeholder,
    this.baseColor,
    this.highlightColor,
    this.speed = 1.0,
    this.bandWidth = _defaultBandWidth,
    this.angle = _defaultSweepAngle,
    this.fadeDuration = _defaultFadeDuration,
    this.semanticsLabel = 'Loading',
  });

  /// Whether to show the skeleton instead of [child].
  final bool isLoading;

  /// The real content, shown once [isLoading] is `false`.
  ///
  /// Also used as the skeleton shape when [placeholder] is null, which
  /// works best for content whose shapes already sit on a transparent
  /// background (text, icons, avatars).
  final Widget child;

  /// Layout to render as the skeleton while loading.
  ///
  /// Build it from [SkeletonBone]s or any widgets: only the shape of what
  /// they paint matters, not their colour.
  final Widget? placeholder;

  /// Colour of the bones. Defaults to a theme-aware neutral grey.
  final Color? baseColor;

  /// Colour of the sweeping band. Defaults to a theme-aware lighter grey.
  final Color? highlightColor;

  /// Sweep speed multiplier. Default 1.0 (about 0.6 sweeps per second).
  final double speed;

  /// Width of the band as a fraction of the surface. Range: 0.05 to 1.0.
  final double bandWidth;

  /// Sweep angle in radians. `0` sweeps left to right.
  final double angle;

  /// Duration of the cross-fade between placeholder and content.
  ///
  /// Skipped when the platform asks for reduced motion.
  final Duration fadeDuration;

  /// Label announced by screen readers while loading.
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final base = baseColor ?? (isDark ? _darkBaseColor : _lightBaseColor);
    final highlight =
        highlightColor ?? (isDark ? _darkHighlightColor : _lightHighlightColor);
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final Widget current = isLoading
        ? Semantics(
            key: const ValueKey<bool>(true),
            label: semanticsLabel,
            liveRegion: true,
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: _SkeletonScope(
                  baseColor: base,
                  child: ShaderEffectWidget(
                    assetPath: _skeletonShaderAsset,
                    maskToChild: true,
                    uniformSetter: (shader, size, time, i) => _setUniforms(
                      shader,
                      i,
                      base,
                      highlight,
                    ),
                    child: placeholder ?? child,
                  ),
                ),
              ),
            ),
          )
        : KeyedSubtree(key: const ValueKey<bool>(false), child: child);

    return AnimatedSwitcher(
      duration: reduceMotion ? Duration.zero : fadeDuration,
      child: current,
    );
  }

  int _setUniforms(
    ui.FragmentShader shader,
    int index,
    Color base,
    Color highlight,
  ) {
    var i = index;
    i = _setColor(shader, i, base);
    i = _setColor(shader, i, highlight);
    shader.setFloat(i++, speed);
    shader.setFloat(i++, bandWidth.clamp(_minBandWidth, _maxBandWidth));
    shader.setFloat(i++, angle);
    return i;
  }

  static int _setColor(ui.FragmentShader shader, int index, Color color) {
    shader.setFloat(index, color.r);
    shader.setFloat(index + 1, color.g);
    shader.setFloat(index + 2, color.b);
    shader.setFloat(index + 3, color.a);
    return index + 4;
  }
}

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

/// Hands the bone colour down to [SkeletonBone]s, so they still look right
/// when the shader is unavailable and the placeholder renders unmasked.
class _SkeletonScope extends InheritedWidget {
  const _SkeletonScope({required this.baseColor, required super.child});

  final Color baseColor;

  static Color? maybeColorOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SkeletonScope>()?.baseColor;

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) =>
      baseColor != oldWidget.baseColor;
}

/// A rounded block used to sketch a [ShaderSkeleton] placeholder.
///
/// Inside a skeleton it is painted in the skeleton's bone colour, and the
/// shader sweep is drawn over it; outside one it uses the theme-aware
/// default bone colour.
///
/// ```dart
/// const Column(
///   crossAxisAlignment: CrossAxisAlignment.start,
///   children: [
///     SkeletonBone(width: 160, height: 18),
///     SizedBox(height: 8),
///     SkeletonBone(),
///     SizedBox(height: 8),
///     SkeletonBone(width: 220),
///   ],
/// )
/// ```
class SkeletonBone extends StatelessWidget {
  /// Creates a rectangular bone. A null [width] fills the available width.
  const SkeletonBone({
    super.key,
    this.width,
    this.height = _defaultBoneHeight,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(_defaultBoneRadius)),
  }) : _isCircle = false;

  /// Creates a circular bone, for avatars and icons.
  const SkeletonBone.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = BorderRadius.zero,
        _isCircle = true;

  /// Width of the bone, or null to fill the available width.
  final double? width;

  /// Height of the bone.
  final double height;

  /// Corner radius. Ignored for [SkeletonBone.circle].
  final BorderRadius borderRadius;

  final bool _isCircle;

  @override
  Widget build(BuildContext context) {
    final color = _SkeletonScope.maybeColorOf(context) ??
        (_isDark(context) ? _darkBaseColor : _lightBaseColor);
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: _isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: _isCircle ? null : borderRadius,
        ),
      ),
    );
  }
}
