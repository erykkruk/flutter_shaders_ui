import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

// The packaged widgets load their shaders under `packages/...`, which the
// root package cannot resolve in tests, so they exercise the fallback path.
// `ShaderEffectWidget` tests use the bare root-package key, which loads.
const String _loadableSkeletonAsset = 'shaders/skeleton.frag';
const String _loadableSnowAsset = 'shaders/snow.frag';

const Color _customBone = Color(0xFF123456);
const Color _darkDefaultBone = Color(0xFF2B2F36);
const Color _lightDefaultBone = Color(0xFFE3E5E8);

Future<void> _pumpApp(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  bool disableAnimations = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

/// Consumes the expected "shader not found" report from the fallback path.
void _expectShaderFallback(WidgetTester tester) {
  expect(tester.takeException(), isNotNull);
}

Color? _boxColor(WidgetTester tester, Finder finder) {
  final box = tester.widget<DecoratedBox>(finder);
  return (box.decoration as BoxDecoration).color;
}

void main() {
  setUp(ShaderCache.clearAll);

  group('ShaderEffectWidget.maskToChild', () {
    testWidgets('paints through a ShaderMask over the child', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderEffectWidget(
          assetPath: _loadableSkeletonAsset,
          maskToChild: true,
          child: SizedBox(width: 100, height: 20),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('defaults to a painted layer, not a mask', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderEffectWidget(
          assetPath: _loadableSnowAsset,
          child: SizedBox(width: 100, height: 20),
        ),
      );
      await tester.pump();

      // Assert
      const widget = ShaderEffectWidget(assetPath: 'a');
      expect(widget.maskToChild, isFalse);
      expect(find.byType(ShaderMask), findsNothing);
    });
  });

  group('ShaderEffectWidget.timeScale', () {
    testWidgets('keeps the ticker running for a moving effect', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderEffectWidget(
          assetPath: _loadableSnowAsset,
          child: SizedBox(width: 100, height: 20),
        ),
      );
      await tester.pump();

      // Assert
      expect(tester.binding.transientCallbackCount, greaterThan(0));
    });

    testWidgets('stops the ticker when the effect is frozen', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderEffectWidget(
          assetPath: _loadableSnowAsset,
          timeScale: 0,
          child: SizedBox(width: 100, height: 20),
        ),
      );
      await tester.pump();

      // Assert: still rendered, but no per-frame repaint scheduled.
      expect(
        find.descendant(
          of: find.byType(ShaderEffectWidget),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      expect(tester.binding.transientCallbackCount, 0);
    });
  });

  group('ShaderSkeleton', () {
    testWidgets('shows the placeholder and hides content while loading',
        (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: true,
          placeholder: SkeletonBone(width: 120),
          child: Text('Ada Lovelace'),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(find.byType(SkeletonBone), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsNothing);
    });

    testWidgets('shows the content once loaded', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: false,
          placeholder: SkeletonBone(width: 120),
          child: Text('Ada Lovelace'),
        ),
      );

      // Assert
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.byType(SkeletonBone), findsNothing);
    });

    testWidgets('announces loading instead of its contents', (tester) async {
      // Arrange
      final semantics = tester.ensureSemantics();

      // Act
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: true,
          semanticsLabel: 'Loading profile',
          child: Text('Ada Lovelace'),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(find.bySemanticsLabel('Loading profile'), findsOneWidget);
      expect(find.bySemanticsLabel('Ada Lovelace'), findsNothing);
      semantics.dispose();
    });

    testWidgets('blocks taps on the placeholder while loading', (tester) async {
      // Arrange
      var taps = 0;
      await _pumpApp(
        tester,
        ShaderSkeleton(
          isLoading: true,
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('Open'),
          ),
        ),
      );
      _expectShaderFallback(tester);

      // Act
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);

      // Assert
      expect(taps, 0);
    });

    testWidgets('paints bones in the skeleton colour without the shader',
        (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: true,
          baseColor: _customBone,
          placeholder: SkeletonBone(width: 120),
          child: SizedBox(),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(
        _boxColor(
          tester,
          find.descendant(
            of: find.byType(SkeletonBone),
            matching: find.byType(DecoratedBox),
          ),
        ),
        _customBone,
      );
    });

    testWidgets('swaps instantly when animations are disabled', (tester) async {
      // Arrange
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: true,
          placeholder: SkeletonBone(width: 120),
          child: Text('Ada Lovelace'),
        ),
        disableAnimations: true,
      );
      _expectShaderFallback(tester);

      // Act
      await _pumpApp(
        tester,
        const ShaderSkeleton(
          isLoading: false,
          placeholder: SkeletonBone(width: 120),
          child: Text('Ada Lovelace'),
        ),
        disableAnimations: true,
      );
      await tester.pump();

      // Assert: no lingering cross-fade.
      expect(find.byType(SkeletonBone), findsNothing);
      expect(find.text('Ada Lovelace'), findsOneWidget);
    });
  });

  group('SkeletonBone', () {
    testWidgets('uses the theme-aware default colour on its own',
        (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const SkeletonBone(width: 80),
        brightness: Brightness.dark,
      );

      // Assert
      expect(
        _boxColor(tester, find.byType(DecoratedBox).last),
        _darkDefaultBone,
      );
    });

    testWidgets('lays out at the requested size', (tester) async {
      // Arrange & Act
      await _pumpApp(tester, const SkeletonBone(width: 80, height: 20));

      // Assert
      expect(tester.getSize(find.byType(SkeletonBone)), const Size(80, 20));
    });

    testWidgets('circle variant is square and circular', (tester) async {
      // Arrange & Act
      await _pumpApp(tester, const SkeletonBone.circle(size: 40));

      // Assert
      expect(tester.getSize(find.byType(SkeletonBone)), const Size(40, 40));
      final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).last);
      expect((box.decoration as BoxDecoration).shape, BoxShape.circle);
      expect((box.decoration as BoxDecoration).color, _lightDefaultBone);
    });
  });

  group('AnimatedGradientBorder', () {
    testWidgets('insets the child by border width plus glow spread',
        (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const AnimatedGradientBorder(
          borderWidth: 3,
          glowSpread: 5,
          child: SizedBox(width: 100, height: 40),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(
        tester.getSize(find.byType(AnimatedGradientBorder)),
        const Size(116, 56),
      );
    });

    testWidgets('keeps the same layout when disabled', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const AnimatedGradientBorder(
          enabled: false,
          child: SizedBox(width: 100, height: 40),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(
        tester.getSize(find.byType(AnimatedGradientBorder)),
        const Size(104, 44),
      );
    });

    testWidgets('accepts more than four colours', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const AnimatedGradientBorder(
          colors: [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.white,
            Colors.black,
          ],
          child: SizedBox(width: 10, height: 10),
        ),
      );
      _expectShaderFallback(tester);

      // Assert
      expect(find.byType(AnimatedGradientBorder), findsOneWidget);
    });

    testWidgets('rejects an empty colour list', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const AnimatedGradientBorder(colors: [], child: SizedBox()),
      );

      // Assert
      expect(tester.takeException(), isAssertionError);
    });

    test('applies documented defaults', () {
      const widget = AnimatedGradientBorder(child: SizedBox());

      expect(widget.colors, hasLength(3));
      expect(widget.borderWidth, 2.0);
      expect(widget.borderRadius, 12.0);
      expect(widget.speed, 1.0);
      expect(widget.glow, 0.0);
      expect(widget.glowSpread, 0.0);
      expect(widget.enabled, isTrue);
    });
  });

  group('FrostedSurface', () {
    testWidgets('blurs the backdrop and clips to its radius', (tester) async {
      // Arrange & Act
      await _pumpApp(tester, const FrostedSurface(child: Text('Card')));
      _expectShaderFallback(tester);

      // Assert
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.text('Card'), findsOneWidget);
    });

    testWidgets('skips the blur at zero sigma and the shader at zero frost',
        (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const FrostedSurface(blurSigma: 0, frost: 0, child: Text('Card')),
      );

      // Assert
      expect(find.byType(BackdropFilter), findsNothing);
      expect(find.byType(ShaderEffectWidget), findsNothing);
    });

    testWidgets('renders a static frost grain by default', (tester) async {
      // Arrange & Act
      await _pumpApp(tester, const FrostedSurface(child: Text('Card')));
      _expectShaderFallback(tester);

      // Assert
      final shader = tester.widget<ShaderEffectWidget>(
        find.byType(ShaderEffectWidget),
      );
      expect(shader.timeScale, 0.0);
    });

    testWidgets('picks a dark tint on dark themes', (tester) async {
      // Arrange
      await _pumpApp(tester, const FrostedSurface(frost: 0, child: Text('A')));
      final lightTint = _boxColor(tester, find.byType(DecoratedBox).last);

      // Act
      await _pumpApp(
        tester,
        const FrostedSurface(frost: 0, child: Text('A')),
        brightness: Brightness.dark,
      );
      // MaterialApp animates theme changes.
      await tester.pumpAndSettle();
      final darkTint = _boxColor(tester, find.byType(DecoratedBox).last);

      // Assert
      expect(lightTint, isNot(darkTint));
      expect(darkTint!.computeLuminance(), lessThan(0.1));
    });

    testWidgets('renders only padded content when disabled', (tester) async {
      // Arrange & Act
      await _pumpApp(
        tester,
        const FrostedSurface(
          enabled: false,
          padding: EdgeInsets.all(8),
          child: SizedBox(width: 50, height: 50),
        ),
      );

      // Assert
      expect(find.byType(BackdropFilter), findsNothing);
      expect(tester.getSize(find.byType(FrostedSurface)), const Size(66, 66));
    });
  });
}
