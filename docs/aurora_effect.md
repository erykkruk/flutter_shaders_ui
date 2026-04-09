# AuroraEffect

Animated aurora borealis (northern lights) effect. Flowing, translucent curtain-like bands drifting organically with domain-warped noise. Renders as a transparent overlay.

## Usage

```dart
AuroraEffect(
  color1: const Color(0xFF00E676),
  color2: const Color(0xFFAA00FF),
  intensity: 0.6,
  speed: 1.0,
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the aurora |
| `color1` | `Color` | `0xFF00E676` (bright green) | Primary aurora color |
| `color2` | `Color` | `0xFFAA00FF` (vivid purple) | Secondary aurora color |
| `intensity` | `double` | `0.6` | Glow intensity. Range: `0.0` – `1.0` |
| `speed` | `double` | `1.0` | Animation speed multiplier |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Profile header background

```dart
SizedBox(
  height: 280,
  child: Stack(
    children: [
      Container(color: const Color(0xFF050508)),
      AuroraEffect(
        color1: const Color(0xFF6366F1),
        color2: const Color(0xFF06B6D4),
        intensity: 0.5,
        speed: 0.6,
      ),
      // Profile content on top
      Center(child: ProfileAvatar()),
    ],
  ),
)
```

### Dark cosmic background

```dart
Container(
  color: const Color(0xFF0A0A0A),
  child: AuroraEffect(
    color1: const Color(0xFF00E676),
    color2: const Color(0xFF7C4DFF),
    intensity: 0.8,
    child: YourContent(),
  ),
)
```

### Subtle ambient overlay

```dart
AuroraEffect(
  color1: const Color(0xFF3B82F6),
  color2: const Color(0xFF8B5CF6),
  intensity: 0.3,
  speed: 0.4,
  child: DarkScreenContent(),
)
```

## Tips

- Always place on a dark background (`Color(0xFF0A0A0A)` or similar) — aurora is most visible on dark surfaces
- Use `intensity: 0.3–0.5` for subtle ambient overlays, `0.7–1.0` for dramatic effect
- Works great as a header/hero section background with gradient fade at the bottom
- Combine with a `LinearGradient` fade at the bottom to blend into your content area
