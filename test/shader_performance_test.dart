import 'package:flutter/widgets.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShaderPerformanceSettings', () {
    test('defaults to an uncapped frame rate that honours reduced motion', () {
      const settings = ShaderPerformanceSettings();

      expect(settings.maxFramesPerSecond, isNull);
      expect(settings.minimumFrameInterval, isNull);
      expect(settings.respectReducedMotion, isTrue);
    });

    test('converts a frame cap into a minimum interval', () {
      expect(
        const ShaderPerformanceSettings(maxFramesPerSecond: 30)
            .minimumFrameInterval,
        const Duration(microseconds: 33333),
      );
      expect(
        const ShaderPerformanceSettings(maxFramesPerSecond: 60)
            .minimumFrameInterval,
        const Duration(microseconds: 16667),
      );
    });

    test('a lower cap means a longer interval', () {
      final slow = const ShaderPerformanceSettings(maxFramesPerSecond: 15)
          .minimumFrameInterval!;
      final fast = const ShaderPerformanceSettings(maxFramesPerSecond: 120)
          .minimumFrameInterval!;

      expect(slow, greaterThan(fast));
    });

    test('rejects a non-positive frame cap', () {
      // Zero would mean "never repaint", which is what enabled: false is
      // for; letting it through would silently freeze the effect.
      expect(
        () => ShaderPerformanceSettings(maxFramesPerSecond: 0),
        throwsAssertionError,
      );
      expect(
        () => ShaderPerformanceSettings(maxFramesPerSecond: -30),
        throwsAssertionError,
      );
    });

    test('copyWith replaces only what it is given', () {
      const original = ShaderPerformanceSettings(
        maxFramesPerSecond: 30,
        respectReducedMotion: false,
      );

      final capped = original.copyWith(maxFramesPerSecond: 60);

      expect(capped.maxFramesPerSecond, 60);
      expect(capped.respectReducedMotion, isFalse);
    });

    test('value equality compares both fields', () {
      expect(
        const ShaderPerformanceSettings(maxFramesPerSecond: 30),
        equals(const ShaderPerformanceSettings(maxFramesPerSecond: 30)),
      );
      expect(
        const ShaderPerformanceSettings(maxFramesPerSecond: 30),
        isNot(equals(const ShaderPerformanceSettings(maxFramesPerSecond: 60))),
      );
      expect(
        const ShaderPerformanceSettings(),
        isNot(
          equals(
            const ShaderPerformanceSettings(respectReducedMotion: false),
          ),
        ),
      );
    });

    test('toString names both settings', () {
      const settings = ShaderPerformanceSettings(maxFramesPerSecond: 24);

      expect(settings.toString(), contains('24'));
      expect(settings.toString(), contains('respectReducedMotion'));
    });
  });

  group('ShaderPerformance', () {
    testWidgets('reads settings from the nearest ancestor', (tester) async {
      late ShaderPerformanceSettings seen;

      await tester.pumpWidget(
        ShaderPerformance(
          settings: const ShaderPerformanceSettings(maxFramesPerSecond: 24),
          child: Builder(
            builder: (context) {
              seen = ShaderPerformance.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(seen.maxFramesPerSecond, 24);
    });

    testWidgets('returns defaults with no ancestor in the tree',
        (tester) async {
      late ShaderPerformanceSettings seen;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            seen = ShaderPerformance.of(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(seen.maxFramesPerSecond, isNull);
      expect(seen.respectReducedMotion, isTrue);
    });

    testWidgets('the nearest ancestor wins over an outer one', (tester) async {
      late ShaderPerformanceSettings seen;

      await tester.pumpWidget(
        ShaderPerformance(
          settings: const ShaderPerformanceSettings(maxFramesPerSecond: 10),
          child: ShaderPerformance(
            settings: const ShaderPerformanceSettings(maxFramesPerSecond: 60),
            child: Builder(
              builder: (context) {
                seen = ShaderPerformance.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(seen.maxFramesPerSecond, 60);
    });

    testWidgets('notifies dependents when the settings change', (tester) async {
      final seen = <int?>[];

      Widget build(int fps) {
        return ShaderPerformance(
          settings: ShaderPerformanceSettings(maxFramesPerSecond: fps),
          child: Builder(
            builder: (context) {
              seen.add(ShaderPerformance.of(context).maxFramesPerSecond);
              return const SizedBox.shrink();
            },
          ),
        );
      }

      await tester.pumpWidget(build(30));
      await tester.pumpWidget(build(60));

      expect(seen, [30, 60]);
    });

    test('updateShouldNotify only fires when the settings differ', () {
      const settings = ShaderPerformanceSettings(maxFramesPerSecond: 30);
      const child = SizedBox.shrink();

      const same = ShaderPerformance(settings: settings, child: child);
      const other = ShaderPerformance(
        settings: ShaderPerformanceSettings(maxFramesPerSecond: 60),
        child: child,
      );

      expect(
        const ShaderPerformance(settings: settings, child: child)
            .updateShouldNotify(same),
        isFalse,
      );
      expect(
        const ShaderPerformance(settings: settings, child: child)
            .updateShouldNotify(other),
        isTrue,
      );
    });
  });

  group('ShaderEffectWidget - performance arguments', () {
    testWidgets('renders only the child when the shader cannot load',
        (tester) async {
      // Assets are not available to the test bundle, so this exercises the
      // graceful-degradation path: content stays, decoration disappears.
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: ShaderEffectWidget(
            assetPath: 'packages/flutter_shaders_ui/shaders/snow.frag',
            child: Text('content'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('content'), findsOneWidget);
      expect(tester.takeException(), isNotNull);
    });

    testWidgets('renders only the child while disabled', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: ShaderEffectWidget(
            assetPath: 'packages/flutter_shaders_ui/shaders/snow.frag',
            enabled: false,
            maxFramesPerSecond: 30,
            child: Text('content'),
          ),
        ),
      );

      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('accepts per-widget overrides', (tester) async {
      const widget = ShaderEffectWidget(
        assetPath: 'packages/flutter_shaders_ui/shaders/snow.frag',
        maxFramesPerSecond: 24,
        respectReducedMotion: false,
      );

      expect(widget.maxFramesPerSecond, 24);
      expect(widget.respectReducedMotion, isFalse);
    });

    testWidgets('leaves both overrides null by default', (tester) async {
      const widget = ShaderEffectWidget(
        assetPath: 'packages/flutter_shaders_ui/shaders/snow.frag',
      );

      // Null means "defer to the ancestor", which is what keeps existing
      // call sites behaving exactly as before.
      expect(widget.maxFramesPerSecond, isNull);
      expect(widget.respectReducedMotion, isNull);
    });
  });
}
