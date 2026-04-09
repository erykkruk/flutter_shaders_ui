# ShimmerEffect

Sweeping shimmer / shine effect. A diagonal shimmering highlight band sweeps across the surface with subtle sparkle noise and soft halo. Continuous loop.

## Usage

```dart
ShimmerEffect(
  color: Colors.white,
  angle: 0.5,
  speed: 1.0,
  width: 0.3,
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the shimmer |
| `color` | `Color` | `0x40FFFFFF` (semi-transparent white) | Shimmer highlight color |
| `angle` | `double` | `0.5` (~28 degrees) | Sweep angle in radians. `0.0` = horizontal, `π/4` = diagonal, `π/2` = vertical |
| `speed` | `double` | `1.0` | Animation speed multiplier |
| `width` | `double` | `0.3` | Shimmer band width. Range: `0.05` (thin) – `1.0` (wide diffused) |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Premium badge with golden shimmer

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: ShimmerEffect(
    color: const Color(0xFFFFD700),
    speed: 0.5,
    width: 0.1,
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Color(0xFFFFD700).withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium, color: Color(0xFFFFD700)),
          Text('Pro Publisher'),
        ],
      ),
    ),
  ),
)
```

### Loading placeholder / skeleton

```dart
ShimmerEffect(
  color: Colors.white,
  speed: 1.0,
  width: 0.15,
  child: Column(
    children: [
      Container(
        width: 200, height: 24,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      SizedBox(height: 12),
      Container(
        width: 150, height: 24,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ],
  ),
)
```

### Title text shimmer

```dart
ShimmerEffect(
  color: Colors.white,
  speed: 0.7,
  width: 0.15,
  child: Text(
    'flutter_shaders_ui',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
)
```

### Featured banner

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: ShimmerEffect(
    color: Colors.white,
    speed: 0.6,
    width: 0.12,
    child: Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Featured Content'),
      ),
    ),
  ),
)
```

## Tips

- Use `color: Colors.white` with narrow `width` (0.1–0.15) for a subtle highlight sweep
- Use `color: Color(0xFFFFD700)` for a golden/premium shimmer effect
- Use slow `speed` (0.5–0.7) for premium/luxury feel, fast (1.5+) for loading indicators
- Wrap text directly to create shimmering titles
- Combine with gradient containers for featured banners and cards
- Great for: loading placeholders, premium badges, titles, featured content
