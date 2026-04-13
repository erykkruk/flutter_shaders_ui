# WaveBackground

Animated wave gradient background. Flowing, organic wave patterns with customizable colors — perfect for full-screen backgrounds, card headers, or splash screens.

## Usage

```dart
WaveBackground(
  color1: const Color(0xFF1A237E),
  color2: const Color(0xFF00BCD4),
  amplitude: 0.3,
  frequency: 2.0,
  speed: 1.0,
  child: Center(
    child: Text('Hello World'),
  ),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered on top of the waves |
| `color1` | `Color` | `0xFF1A237E` (dark blue) | Primary (top) color |
| `color2` | `Color` | `0xFF00BCD4` (cyan) | Secondary (bottom) color |
| `amplitude` | `double` | `0.3` | Wave height. Range: `0.0` (flat) – `1.0` (dramatic) |
| `frequency` | `double` | `2.0` | Wave density. Range: `0.0` (smooth) – `5.0` (dense ripples) |
| `speed` | `double` | `1.0` | Animation speed multiplier |
| `enabled` | `bool` | `true` | Toggle shader on/off. When `false`, renders only `child` |

## Examples

### Full-screen background

```dart
Scaffold(
  body: WaveBackground(
    color1: const Color(0xFF0D1B2A),
    color2: const Color(0xFF1B263B),
    amplitude: 0.2,
    speed: 0.6,
    child: SafeArea(
      child: YourContent(),
    ),
  ),
)
```

### Card header

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: SizedBox(
    height: 120,
    child: WaveBackground(
      color1: const Color(0xFF6366F1),
      color2: const Color(0xFF8B5CF6),
      amplitude: 0.4,
      frequency: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Card Title'),
      ),
    ),
  ),
)
```

### Subtle, slow motion

```dart
WaveBackground(
  color1: const Color(0xFF111827),
  color2: const Color(0xFF1F2937),
  amplitude: 0.1,
  frequency: 1.0,
  speed: 0.3,
)
```

## Tips

- Use low `amplitude` (0.1–0.2) and low `speed` (0.3–0.5) for subtle, ambient backgrounds
- Use high `frequency` (3.0–5.0) for dense, water-like ripples
- Combine with `GlowOrb` for extra depth
- Wrap in `ClipRRect` when using inside cards or bounded containers
