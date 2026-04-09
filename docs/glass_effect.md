# GlassEffect

Frosted glass / glassmorphism effect overlay. Noise-based frost patterns with crystalline voronoi textures, internal light refractions, and specular highlights. Creates a tinted semi-transparent overlay simulating frosted glass.

## Usage

```dart
GlassEffect(
  blurAmount: 0.5,
  frost: 0.4,
  opacity: 0.3,
  tint: Colors.white,
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the glass |
| `blurAmount` | `double` | `0.5` | Simulated blur intensity. `0.0` = clear, `1.0` = heavy diffusion |
| `frost` | `double` | `0.4` | Frost noise amount. `0.0` = clear glass, `1.0` = heavy frost |
| `opacity` | `double` | `0.3` | Overall glass overlay opacity. Range: `0.0` – `1.0` |
| `tint` | `Color` | `Colors.white` | Tint color applied to the glass surface |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Glassmorphism card

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: GlassEffect(
    frost: 0.5,
    opacity: 0.35,
    tint: Colors.white,
    child: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Frosted Glass Card'),
          Text('Content behind glass'),
        ],
      ),
    ),
  ),
)
```

### Subtle overlay on banner

```dart
Stack(
  children: [
    // Background image or gradient
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
    ),
    // Glass overlay for texture
    GlassEffect(
      frost: 0.15,
      opacity: 0.08,
      blurAmount: 0.2,
      tint: Colors.white,
    ),
    // Content
    Padding(
      padding: EdgeInsets.all(20),
      child: Text('Banner Title'),
    ),
  ],
)
```

### Modal/dialog backdrop

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: GlassEffect(
    frost: 0.6,
    opacity: 0.4,
    blurAmount: 0.7,
    tint: const Color(0xFF1A1A2E),
    child: Padding(
      padding: EdgeInsets.all(24),
      child: DialogContent(),
    ),
  ),
)
```

## Tips

- Always wrap in `ClipRRect` to clip the effect to your desired shape
- This is a **procedural frost simulation**, not a real blur — it doesn't blur the content behind it
- For real backdrop blur, combine with Flutter's `BackdropFilter`
- Use low `frost` (0.1–0.2) and low `opacity` (0.05–0.1) as a subtle texture overlay on gradients
- Use high `frost` (0.5+) and `opacity` (0.3+) for visible glassmorphism cards
- Works great on dark backgrounds with colorful content underneath
