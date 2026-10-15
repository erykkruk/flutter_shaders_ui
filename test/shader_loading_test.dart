import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

// The package under test is the root package, so its shaders resolve under
// their bare `shaders/...` key here (consumers use `packages/...`).
const String _validAsset = 'shaders/snow.frag';
const String _missingAsset = 'shaders/does_not_exist.frag';

Widget _host(String assetPath) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShaderEffectWidget(
      assetPath: assetPath,
      child: const Text('content'),
    ),
  );
}

Finder _shaderPaint() => find.descendant(
      of: find.byType(ShaderEffectWidget),
      matching: find.byType(CustomPaint),
    );

void main() {
  setUp(ShaderCache.clearAll);

  group('ShaderCache.load', () {
    test('returns the cached program on repeated loads', () async {
      // Arrange
      final first = await ShaderCache.load(_validAsset);

      // Act
      final second = await ShaderCache.load(_validAsset);

      // Assert
      expect(second, same(first));
    });

    test('deduplicates concurrent loads of the same asset', () {
      // Arrange & Act
      final first = ShaderCache.load(_validAsset);
      final second = ShaderCache.load(_validAsset);

      // Assert
      expect(second, same(first));
    });

    test('does not cache a failed load, so the asset can be retried', () async {
      // Arrange
      final failed = ShaderCache.load(_missingAsset);
      await expectLater(failed, throwsA(anything));

      // Act
      final retry = ShaderCache.load(_missingAsset);

      // Assert
      expect(retry, isNot(same(failed)));
      await expectLater(retry, throwsA(anything));
    });
  });

  // The test engine resolves shader loads within a single pump, so these
  // cover the reload paths rather than reproducing a slow-load race.
  group('ShaderEffectWidget loading', () {
    testWidgets('renders the shader once a valid asset loads', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(_host(_validAsset));
      await tester.pump();

      // Assert
      expect(_shaderPaint(), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('drops the previous shader when assetPath becomes invalid',
        (tester) async {
      // Arrange
      await tester.pumpWidget(_host(_validAsset));
      await tester.pump();

      // Act
      await tester.pumpWidget(_host(_missingAsset));
      await tester.pump();

      // Assert
      expect(_shaderPaint(), findsNothing);
      expect(find.text('content'), findsOneWidget);
      expect(tester.takeException(), isNotNull);
    });

    testWidgets('recovers when assetPath changes from invalid to valid',
        (tester) async {
      // Arrange
      await tester.pumpWidget(_host(_missingAsset));
      await tester.pump();
      expect(tester.takeException(), isNotNull);

      // Act
      await tester.pumpWidget(_host(_validAsset));
      await tester.pump();

      // Assert
      expect(_shaderPaint(), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
    });
  });
}
