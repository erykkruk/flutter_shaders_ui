# PulseEffect

Pulsing glow effect — breathing, radial glow expanding and contracting from center with expanding pulse rings. Renders as a transparent overlay.

## Usage

```dart
PulseEffect(
  color: const Color(0xFF2196F3),
  speed: 1.0,
  intensity: 0.5,
  child: YourContent(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Content rendered behind the pulse |
| `color` | `Color` | `0xFF2196F3` (Material Blue) | Glow color |
| `speed` | `double` | `1.0` | Pulse speed multiplier. Higher = faster |
| `intensity` | `double` | `0.5` | Glow intensity. Range: `0.0` – `1.0` |
| `enabled` | `bool` | `true` | Toggle shader on/off |

## Examples

### Attention-grabbing button

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: PulseEffect(
    color: const Color(0xFF6366F1),
    speed: 0.8,
    intensity: 0.4,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('Get Started'),
    ),
  ),
)
```

### Notification badge / unread indicator

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: PulseEffect(
    color: Colors.red.withValues(alpha: 0.4),
    speed: 0.4,
    intensity: 0.15,
    child: NotificationCard(isUnread: true),
  ),
)
```

### Avatar with activity indicator

```dart
SizedBox(
  width: 48,
  height: 48,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: PulseEffect(
      color: const Color(0xFF10B981),
      speed: 0.5,
      intensity: 0.3,
      child: CircleAvatar(child: Text('E')),
    ),
  ),
)
```

### Achievement badge

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: SizedBox(
    width: 56,
    height: 56,
    child: PulseEffect(
      color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
      speed: 0.3,
      intensity: 0.2,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF59E0B).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.star, color: Color(0xFFF59E0B)),
      ),
    ),
  ),
)
```

## Tips

- Always wrap in `ClipRRect` to contain the glow within bounds
- Use low `intensity` (0.1–0.2) and low `speed` (0.3–0.5) for subtle "breathing" indicators
- Use high `intensity` (0.6–1.0) for dramatic attention-grabbing effects
- Great for: unread notifications, CTA buttons, achievement badges, live indicators
- Combine with colored containers — the pulse adds a radial glow on top
