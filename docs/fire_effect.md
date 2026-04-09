# FireEffect

Animated fire/flames effect rising from the bottom. Layered noise functions (FBM, turbulence) create organic, flickering flames with ember sparks. Renders as a transparent overlay.

## Usage

```dart
FireEffect(
  intensity: 0.6,
  speed: 1.0,
  color1: const Color(0xFFFFEB3B),
  color2: const Color(0xFFFF5722),
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the flames |
| `intensity` | `double` | `0.6` | Flame height and intensity. `0.0` = embers only, `1.0` = inferno |
| `speed` | `double` | `1.0` | Animation speed. `< 1.0` = slow smolder, `> 1.0` = rapid flicker |
| `color1` | `Color` | `0xFFFFEB3B` (bright yellow) | Inner flame color |
| `color2` | `Color` | `0xFFFF5722` (deep orange) | Outer flame color |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Trending/hot banner

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: SizedBox(
    height: 160,
    child: Stack(
      children: [
        Container(color: const Color(0xFF1A0500)),
        FireEffect(
          intensity: 0.5,
          speed: 0.7,
          color1: const Color(0xFFFF8A00),
          color2: const Color(0xFFE52E71),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text('Trending Now'),
        ),
      ],
    ),
  ),
)
```

### Game-style button

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: SizedBox(
    height: 56,
    child: FireEffect(
      intensity: 0.4,
      speed: 0.8,
      child: Container(
        color: const Color(0xFF2D0A00),
        child: Center(child: Text('POWER UP')),
      ),
    ),
  ),
)
```

### Subtle warm glow

```dart
FireEffect(
  intensity: 0.2,
  speed: 0.5,
  color1: const Color(0xFFFFA726),
  color2: const Color(0xFFFF7043),
  child: CampfireScene(),
)
```

## Tips

- Use a dark warm background (`Color(0xFF1A0500)`) for best visibility
- Low `intensity` (0.2–0.3) creates a cozy warm glow, high (0.7–1.0) creates an inferno
- Custom `color1`/`color2` can create blue fire, green fire, etc.
- Wrap in `ClipRRect` to contain flames within cards/buttons
- Flames rise from the bottom — position content accordingly
