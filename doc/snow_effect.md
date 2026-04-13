# SnowEffect

Animated snow particles falling with parallax depth effect. Multiple layers for natural depth perception with organic wind turbulence on each flake.

## Usage

```dart
SnowEffect(
  density: 0.5,
  speed: 1.0,
  size: 0.5,
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the snow |
| `density` | `double` | `0.5` | Snow particle density. `0.0` = sparse, `1.0` = blizzard |
| `speed` | `double` | `1.0` | Fall speed multiplier. Range: `0.1` – `2.0` |
| `size` | `double` | `0.5` | Snowflake size multiplier. Range: `0.0` – `1.0` |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Seasonal full-screen background

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0D47A1), Color(0xFF1A237E)],
    ),
  ),
  child: SnowEffect(
    density: 0.7,
    speed: 1.0,
    child: SafeArea(child: WinterContent()),
  ),
)
```

### Subtle ambient overlay

```dart
Stack(
  children: [
    DarkBackground(),
    SnowEffect(
      density: 0.15,
      speed: 0.3,
      size: 0.3,
    ),
    MainContent(),
  ],
)
```

### Blizzard effect

```dart
SnowEffect(
  density: 1.0,
  speed: 2.0,
  size: 0.8,
  child: Container(
    color: Color(0xFF0D1B2A),
    child: StormScene(),
  ),
)
```

### Card with snow accent

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: SizedBox(
    height: 120,
    child: Stack(
      children: [
        Container(color: Color(0xFF1E3A5F)),
        SnowEffect(density: 0.4, speed: 0.6),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('Winter Sale'),
        ),
      ],
    ),
  ),
)
```

## Tips

- Use very low `density` (0.1–0.2) and `speed` (0.2–0.4) for a subtle ambient effect that doesn't distract
- Use high `density` (0.7+) for seasonal/festive screens
- Works best on dark blue, dark purple, or black backgrounds
- Combine with `WaveBackground` for a winter ocean scene
- Place as a `Positioned.fill` in a `Stack` for fullscreen overlay without affecting layout
- Great for: seasonal UI, splash screens, winter-themed features, ambient decoration
