# RippleEffect

Tap-triggered ripple wave effect. Expands concentric rings from the tap point with smooth animation. Includes optional `onTap` callback.

## Usage

```dart
RippleEffect(
  color: Colors.white,
  duration: const Duration(milliseconds: 800),
  intensity: 1.0,
  onTap: () => print('Tapped!'),
  child: YourWidget(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget` | **required** | Widget to wrap with ripple (required) |
| `color` | `Color` | `Colors.white` | Ripple wave color |
| `duration` | `Duration` | `800ms` | Ripple animation duration |
| `intensity` | `double` | `1.0` | Ripple strength. Higher = more visible rings |
| `onTap` | `VoidCallback?` | `null` | Callback invoked on tap (alongside ripple) |

## Examples

### Interactive card

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: RippleEffect(
    color: const Color(0xFF6366F1),
    intensity: 0.7,
    duration: const Duration(milliseconds: 600),
    onTap: () => navigateToDetail(),
    child: GlassCard(
      child: Row(
        children: [
          Icon(Icons.explore),
          Text('Backgrounds'),
        ],
      ),
    ),
  ),
)
```

### Action button with ripple

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: RippleEffect(
    color: const Color(0xFF10B981),
    intensity: 0.8,
    duration: const Duration(milliseconds: 700),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.play_arrow, color: Color(0xFF10B981)),
          Text('Preview'),
        ],
      ),
    ),
  ),
)
```

### Full-screen tap area

```dart
RippleEffect(
  color: const Color(0xFF80CBC4),
  intensity: 1.0,
  duration: const Duration(milliseconds: 900),
  child: Container(
    color: const Color(0xFF263238),
    child: Center(child: Text('Tap anywhere')),
  ),
)
```

## Tips

- Always wrap in `ClipRRect` when using inside cards/buttons to clip the ripple to shape
- Use bright colors on dark backgrounds, darker on light backgrounds
- Rapid successive taps are handled — animation resets on each tap
- The `onTap` callback fires immediately alongside the visual ripple
- Use shorter `duration` (400–600ms) for snappy buttons, longer (800–1000ms) for full-screen areas
- Works as an enhanced replacement for `InkWell` with a shader-powered visual effect
