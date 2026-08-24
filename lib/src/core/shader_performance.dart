import 'package:flutter/widgets.dart';

/// Frame-rate and accessibility settings shared by every shader effect
/// below it in the tree.
///
/// Shader widgets repaint on every frame by default, which on a 120 Hz
/// display is twice the work a 60 Hz one does for visuals that rarely need
/// it. Wrap a subtree to cap that once, instead of threading the same
/// argument through every effect:
///
/// ```dart
/// ShaderPerformance(
///   settings: const ShaderPerformanceSettings(maxFramesPerSecond: 30),
///   child: MyPage(),
/// )
/// ```
///
/// An individual widget still wins: an explicit `maxFramesPerSecond` on a
/// [ShaderEffectWidget] overrides whatever the ancestor says.
class ShaderPerformance extends InheritedWidget {
  /// Applies [settings] to every shader effect in [child].
  const ShaderPerformance({
    super.key,
    required this.settings,
    required super.child,
  });

  /// Settings inherited by the subtree.
  final ShaderPerformanceSettings settings;

  /// Returns the settings from the nearest ancestor, or the defaults.
  ///
  /// Never returns null, so callers do not have to special-case a tree
  /// without a [ShaderPerformance] in it.
  static ShaderPerformanceSettings of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<ShaderPerformance>();
    return widget?.settings ?? const ShaderPerformanceSettings();
  }

  @override
  bool updateShouldNotify(ShaderPerformance oldWidget) =>
      settings != oldWidget.settings;
}

/// How hard shader effects are allowed to work.
@immutable
class ShaderPerformanceSettings {
  /// Creates settings for a subtree of shader effects.
  const ShaderPerformanceSettings({
    this.maxFramesPerSecond,
    this.respectReducedMotion = true,
  }) : assert(
          maxFramesPerSecond == null || maxFramesPerSecond > 0,
          'maxFramesPerSecond must be positive; use enabled: false to stop.',
        );

  /// Upper bound on shader repaints per second.
  ///
  /// Null runs at the display refresh rate, which is the behaviour shader
  /// effects had before this existed. A cap only ever skips repaints: the
  /// animation clock still advances in real time, so lowering it slows the
  /// frame rate without slowing the motion.
  final int? maxFramesPerSecond;

  /// Whether to freeze animation when the platform asks for reduced motion.
  ///
  /// With this on (the default), a user who has turned on "reduce motion"
  /// sees the shader's first frame as a still image rather than a moving
  /// one. The effect still renders; only its clock stops.
  final bool respectReducedMotion;

  /// Returns a copy with the given fields replaced.
  ShaderPerformanceSettings copyWith({
    int? maxFramesPerSecond,
    bool? respectReducedMotion,
  }) {
    return ShaderPerformanceSettings(
      maxFramesPerSecond: maxFramesPerSecond ?? this.maxFramesPerSecond,
      respectReducedMotion: respectReducedMotion ?? this.respectReducedMotion,
    );
  }

  /// Minimum time between repaints, or null when uncapped.
  Duration? get minimumFrameInterval => maxFramesPerSecond == null
      ? null
      : Duration(microseconds: (1000000 / maxFramesPerSecond!).round());

  @override
  bool operator ==(Object other) =>
      other is ShaderPerformanceSettings &&
      other.maxFramesPerSecond == maxFramesPerSecond &&
      other.respectReducedMotion == respectReducedMotion;

  @override
  int get hashCode => Object.hash(maxFramesPerSecond, respectReducedMotion);

  @override
  String toString() => 'ShaderPerformanceSettings('
      'maxFramesPerSecond: $maxFramesPerSecond, '
      'respectReducedMotion: $respectReducedMotion)';
}
