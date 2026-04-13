# GlowOrb

Positionable glowing orb with volumetric glow, halo, and breathing/pulsing animation. Three modes: static, bouncing (screensaver), and draggable (user-controlled).

## Usage

### Static orb

```dart
GlowOrb(
  position: const Offset(0.5, 0.5),
  color: const Color(0xFF00E5FF),
  radius: 0.15,
  glowIntensity: 1.0,
  pulseSpeed: 2.0,
  child: YourContent(),
)
```

### Bouncing orb (screensaver mode)

```dart
GlowOrb.bouncing(
  color: const Color(0xFF8B5CF6),
  radius: 0.15,
  glowIntensity: 1.0,
  speed: 0.3,
  child: YourContent(),
)
```

### Draggable orb

```dart
GlowOrb.draggable(
  color: const Color(0xFFFF6B00),
  radius: 0.12,
  glowIntensity: 1.2,
  child: YourContent(),
)
```

## Parameters

### Common parameters (all modes)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content behind the orb |
| `color` | `Color` | varies by mode | Orb glow color |
| `radius` | `double` | `0.15` | Orb size as fraction of widget. Typical: `0.05` – `0.3` |
| `glowIntensity` | `double` | `1.0` | Brightness multiplier |
| `pulseSpeed` | `double` | `2.0` | Breathing animation speed (rad/s) |
| `enabled` | `bool` | `true` | Toggle shader on/off |

### Static-only

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `position` | `Offset` | `Offset(0.5, 0.5)` | Normalized position (0–1 on both axes) |

### Bouncing-only

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `speed` | `double` | `0.3` | Bounce movement speed (fraction/second) |

### Draggable-only

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `position` | `Offset` | `Offset(0.5, 0.5)` | Initial position (user can drag after) |

## Examples

### Ambient background decoration

```dart
Stack(
  children: [
    DarkBackground(),
    GlowOrb.bouncing(
      color: const Color(0xFF6366F1),
      radius: 0.18,
      glowIntensity: 0.3,
      speed: 0.08,
    ),
    YourContent(),
  ],
)
```

### Multiple static orbs as light sources

```dart
Stack(
  children: [
    Container(color: const Color(0xFF0A0A0A)),
    GlowOrb(
      position: const Offset(0.2, 0.3),
      color: const Color(0xFF6366F1),
      radius: 0.2,
      glowIntensity: 0.6,
    ),
    GlowOrb(
      position: const Offset(0.8, 0.7),
      color: const Color(0xFF06B6D4),
      radius: 0.15,
      glowIntensity: 0.4,
    ),
  ],
)
```

### Interactive demo

```dart
Container(
  color: const Color(0xFF0D1117),
  child: GlowOrb.draggable(
    color: const Color(0xFF00E5FF),
    radius: 0.12,
    glowIntensity: 1.2,
    pulseSpeed: 1.0,
    child: Center(child: Text('Drag the orb!')),
  ),
)
```

## Tips

- Use `.bouncing()` with low `speed` (0.05–0.1) and low `glowIntensity` (0.2–0.4) for subtle ambient light
- Use `.draggable()` for interactive demos, onboarding, or playful UI elements
- Multiple static orbs with different colors create beautiful light compositions
- Combine with `WaveBackground` for extra depth in dark UIs
- The orb is transparent — it composites nicely on any dark background
