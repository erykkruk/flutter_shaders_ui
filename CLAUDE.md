# flutter_shaders_ui

## Overview

Flutter package z kolekcją gotowych UI widgetów opartych na GLSL fragment shaderach. Efekty: blur, glow, noise, gradienty i więcej — łatwe w użyciu, zero natywnego kodu.

## Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Framework | Flutter | >= 3.10.0 |
| Language | Dart | >= 3.0.0 |
| Shaders | GLSL (Fragment Shaders) | ES 1.0 / 3.0 |
| Linting | flutter_lints | ^4.0.0 |
| Testing | flutter_test | SDK |

## Development Commands

```bash
flutter pub get          # Dependencies
flutter analyze          # Static analysis
dart format .            # Format
flutter test             # Tests
```

## Directory Structure

```
flutter_shaders_ui/
├── lib/
│   ├── flutter_shaders_ui.dart    # Barrel export (public API)
│   └── src/                       # Prywatna implementacja
│       ├── widgets/               # Shader-based widgets
│       ├── shaders/               # .frag shader files
│       └── utils/                 # Helpers (shader loading, uniforms)
├── shaders/                       # GLSL .frag files (registered in pubspec)
├── test/
├── example/
├── .github/workflows/
│   ├── ci.yml
│   ├── auto-tag.yml
│   └── publish.yml
└── pubspec.yaml
```

## Architecture Pattern

**Widget + Shader Architecture:**

1. **Shader files** (`.frag`) — pure GLSL fragment shaders
2. **Shader widgets** — Flutter widgets wrapping `FragmentProgram` + `CustomPainter`
3. **Barrel export** — `lib/flutter_shaders_ui.dart` eksportuje tylko publiczne API

### Szablon nowego efektu

```
1. Napisz shader .frag w shaders/
2. Zarejestruj w pubspec.yaml → flutter.shaders
3. Stwórz widget w lib/src/widgets/
4. Dodaj export w barrel file
5. Napisz test
6. Dodaj example
```

## Module Structure — Shader Widget

```dart
// lib/src/widgets/shader_blur.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Widget applying a gaussian blur shader effect.
///
/// ```dart
/// ShaderBlur(
///   intensity: 0.5,
///   child: Image.asset('photo.png'),
/// )
/// ```
class ShaderBlur extends StatefulWidget {
  const ShaderBlur({
    super.key,
    required this.child,
    this.intensity = 1.0,
  });

  final Widget child;
  final double intensity;

  @override
  State<ShaderBlur> createState() => _ShaderBlurState();
}
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Shader files | snake_case.frag | `gaussian_blur.frag` |
| Widget classes | Shader + PascalCase | `ShaderBlur`, `ShaderGlow` |
| Shader params | camelCase | `blurIntensity` |
| Constants | SCREAMING_SNAKE | `DEFAULT_BLUR_RADIUS` |

## Error Handling

```dart
/// Thrown when a shader fails to compile or load.
class ShaderCompilationException implements Exception {
  const ShaderCompilationException(this.shaderName, this.message);
  final String shaderName;
  final String message;

  @override
  String toString() => 'ShaderCompilationException($shaderName): $message';
}
```

## Anti-Patterns

### NIGDY

1. Hardcoded uniform values — używaj parametrów widgetu
2. Synchroniczne ładowanie shaderów — zawsze async z `FragmentProgram.fromAsset`
3. Shader recompilation per frame — cache `FragmentProgram` instancje
4. `print()` w library code
5. `dynamic` typy — explicit types everywhere
6. Brak `dispose()` — zawsze czyść shader resources

### ZAWSZE

1. Cache `FragmentProgram` — ładuj raz, reużywaj
2. `///` doc comments na każdym publicznym widgecie
3. Fallback widget gdy shader nie załaduje się (graceful degradation)
4. Parametryzowalne efekty — intensity, color, radius jako widget params
5. `const` constructors gdzie możliwe
6. Testy — minimum smoke test per widget

## Best Practices

1. **Jeden shader = jeden efekt** — nie mieszaj wielu efektów w jednym .frag
2. **Uniforms** — przekazuj przez `FragmentShader.setFloat()` z jasnymi nazwami
3. **Performance** — `RepaintBoundary` wokół shader widgets
4. **Responsywność** — shadery muszą działać na różnych rozmiarach ekranu
5. **Dokumentacja** — screenshot/gif efektu w doc comments i README

## New Feature Checklist

1. [ ] Napisz shader `.frag` w `shaders/`
2. [ ] Zarejestruj shader w `pubspec.yaml` → `flutter.shaders`
3. [ ] Stwórz widget w `lib/src/widgets/`
4. [ ] Dodaj export w `lib/flutter_shaders_ui.dart`
5. [ ] Napisz testy w `test/`
6. [ ] Dodaj example w `example/`
7. [ ] Zaktualizuj README z opisem efektu
8. [ ] Zaktualizuj CHANGELOG
9. [ ] `flutter analyze` — zero warnings
10. [ ] `flutter test` — all green

## Claude Code Integration

| Type | Name | Purpose |
|------|------|---------|
| Command | `/commit` | Conventional commit |
| Command | `/pr` | Pull request |
| Command | `/review` | Code review routing |
| Command | `/quality-check` | analyze + format + test |
