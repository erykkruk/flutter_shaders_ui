# flutter_shaders_ui — Widget Documentation

GPU-accelerated shader-based UI widgets for Flutter. Zero dependencies, zero native code.

## Widget Catalog

### Backgrounds

| Widget | Description | Doc |
|--------|-------------|-----|
| [WaveBackground](wave_background.md) | Animated flowing wave gradient | Full-screen backgrounds, card headers, splash screens |
| [AuroraEffect](aurora_effect.md) | Northern lights curtain bands | Hero sections, profile headers, cosmic UI |
| [FireEffect](fire_effect.md) | Rising flames with ember sparks | Game UI, trending banners, dramatic accents |

### Overlays

| Widget | Description | Doc |
|--------|-------------|-----|
| [GlassEffect](glass_effect.md) | Frosted glass / glassmorphism | Cards, modals, bottom sheets, premium UI |
| [ShimmerEffect](shimmer_effect.md) | Sweeping shine highlight | Loading skeletons, premium badges, titles |
| [SnowEffect](snow_effect.md) | Falling parallax snowflakes | Seasonal UI, ambient decoration, festive screens |
| [PulseEffect](pulse_effect.md) | Breathing radial glow rings | Notification badges, CTA buttons, live indicators |

### Interactive

| Widget | Description | Doc |
|--------|-------------|-----|
| [RippleEffect](ripple_effect.md) | Tap-triggered concentric waves | Buttons, cards, tappable elements |
| [GlowOrb](glow_orb.md) | Positionable glowing sphere | Ambient light, screensaver, interactive demos |

## Quick Start

```dart
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';
```

### Simplest example — wave background

```dart
Scaffold(
  body: WaveBackground(
    color1: const Color(0xFF0D1B2A),
    color2: const Color(0xFF1B263B),
    child: Center(child: Text('Hello Shaders')),
  ),
)
```

### Combining effects

```dart
Stack(
  children: [
    // Layer 1: Wave background
    Positioned.fill(
      child: WaveBackground(
        color1: const Color(0xFF0B0E1A),
        color2: const Color(0xFF131B2E),
        amplitude: 0.15,
        speed: 0.4,
      ),
    ),
    // Layer 2: Ambient glow
    Positioned.fill(
      child: GlowOrb.bouncing(
        color: const Color(0xFF6366F1),
        radius: 0.18,
        glowIntensity: 0.3,
        speed: 0.08,
      ),
    ),
    // Layer 3: Content
    SafeArea(child: YourContent()),
  ],
)
```

## Common Patterns

### Glass card

```dart
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

### Tappable card with ripple

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: RippleEffect(
    color: accentColor,
    onTap: () => doSomething(),
    child: CardWidget(),
  ),
)
```

### Shimmer loading skeleton

```dart
ShimmerEffect(
  speed: 1.0,
  width: 0.15,
  child: Column(
    children: List.generate(3, (_) => SkeletonLine()),
  ),
)
```

### Unread notification indicator

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: PulseEffect(
    color: Colors.red.withValues(alpha: 0.3),
    speed: 0.4,
    intensity: 0.15,
    child: NotificationCard(),
  ),
)
```

## Performance

- All effects are **GPU-accelerated** via GLSL fragment shaders
- Shaders are **compiled once and cached** via `ShaderCache`
- Animation uses Flutter's `Ticker` — respects `enabled` flag to pause
- When `enabled: false`, widgets render only `child` (zero GPU cost)
- Use `enabled` flag to disable effects for reduced-motion accessibility

## Core API

For custom shader widgets, you can use the base infrastructure:

| Class | Purpose |
|-------|---------|
| `ShaderEffectWidget` | Base widget managing shader loading, time animation, uniform setup |
| `ShaderCache` | Global cache for compiled `FragmentProgram` instances |
| `ShaderPainter` | Reusable `CustomPainter` for rendering shaders to canvas |

See the [source code](../lib/src/core/) for details.
