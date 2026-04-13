# flutter_shaders_ui

[![pub package](https://img.shields.io/pub/v/flutter_shaders_ui.svg)](https://pub.dev/packages/flutter_shaders_ui)
[![CI](https://github.com/erykkruk/flutter_shaders_ui/actions/workflows/ci.yml/badge.svg)](https://github.com/erykkruk/flutter_shaders_ui/actions/workflows/ci.yml)

Collection of beautiful, ready-to-use Flutter widgets powered by GLSL fragment shaders. GPU-accelerated effects for Flutter UI — aurora, fire, glass, glow, ripple, shimmer, snow, water, waves and more.

**Zero external dependencies** — uses only the Flutter SDK.

## Installation

```yaml
dependencies:
  flutter_shaders_ui: ^0.1.0
```

## Quick Start

```dart
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

// Wave background
Scaffold(
  body: WaveBackground(
    color1: const Color(0xFF0D1B2A),
    color2: const Color(0xFF1B263B),
    child: Center(child: Text('Hello Shaders')),
  ),
)

// Glass card
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: GlassEffect(
    frost: 0.4,
    opacity: 0.3,
    child: Padding(
      padding: EdgeInsets.all(16),
      child: CardContent(),
    ),
  ),
)
```

## Available Effects

### Backgrounds

| Widget | Description |
|--------|-------------|
| `WaveBackground` | Animated flowing wave gradient — splash screens, card headers |
| `AuroraEffect` | Northern lights curtain bands — hero sections, cosmic UI |
| `FireEffect` | Rising flames with ember sparks — game UI, dramatic accents |
| `WaterEffect` | Underwater caustics with foam — aquatic themes, depth effects |

### Overlays

| Widget | Description |
|--------|-------------|
| `GlassEffect` | Frosted glass / glassmorphism — cards, modals, premium UI |
| `ShimmerEffect` | Sweeping shine highlight — loading skeletons, badges |
| `SnowEffect` | Falling parallax snowflakes — seasonal UI, ambient decoration |
| `PulseEffect` | Breathing radial glow rings — notifications, live indicators |

### Interactive

| Widget | Description |
|--------|-------------|
| `RippleEffect` | Tap-triggered concentric waves — buttons, tappable cards |
| `GlowOrb` | Positionable glowing sphere (static, bouncing, draggable) |

### Combining Effects

```dart
Stack(
  children: [
    Positioned.fill(
      child: WaveBackground(
        color1: const Color(0xFF0B0E1A),
        color2: const Color(0xFF131B2E),
      ),
    ),
    Positioned.fill(
      child: GlowOrb.bouncing(
        color: const Color(0xFF6366F1),
        radius: 0.18,
        glowIntensity: 0.3,
      ),
    ),
    SafeArea(child: YourContent()),
  ],
)
```

## Performance

- **GPU-accelerated** — all effects run as GLSL fragment shaders on the GPU
- **Compiled once and cached** — `ShaderCache` prevents recompilation
- **Zero cost when disabled** — `enabled: false` renders only `child`, no GPU work
- **Ticker-based animation** — respects Flutter's frame scheduling
- **RepaintBoundary** — isolates shader repaints from the widget tree

## Core API

For building custom shader widgets:

| Class | Purpose |
|-------|---------|
| `ShaderEffectWidget` | Base widget: shader loading, time animation, uniform setup |
| `ShaderCache` | Global cache for compiled `FragmentProgram` instances |
| `ShaderPainter` | Reusable `CustomPainter` for rendering shaders to canvas |

See the [full documentation](doc/README.md) for detailed widget docs and common patterns.

## Requirements

- Flutter >= 3.10.0
- Dart >= 3.0.0

## License

MIT — see [LICENSE](LICENSE) for details.
