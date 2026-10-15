# flutter_shaders_ui

[![pub package](https://img.shields.io/pub/v/flutter_shaders_ui.svg)](https://pub.dev/packages/flutter_shaders_ui)
[![CI](https://github.com/erykkruk/flutter_shaders_ui/actions/workflows/ci.yml/badge.svg)](https://github.com/erykkruk/flutter_shaders_ui/actions/workflows/ci.yml)

Collection of beautiful, ready-to-use Flutter widgets powered by GLSL fragment shaders. GPU-accelerated effects for Flutter UI — aurora, fire, glass, glow, ripple, shimmer, snow, water, waves and more.

**Zero external dependencies** — uses only the Flutter SDK.

## Documentation

Full documentation is hosted at Codigee:

- [Overview](https://codigee.com/open-source/flutter-shaders-ui) — what the package is and how to get started
- [Effects reference](https://codigee.com/open-source/flutter-shaders-ui/effects) — every widget, its parameters and live examples
- [Custom shaders](https://codigee.com/open-source/flutter-shaders-ui/custom) — build your own shader widgets on the base infrastructure

## Demo

### Everyday UI

<table>
  <tr>
    <td align="center"><b><code>ShaderSkeleton</code></b></td>
    <td align="center"><b><code>FrostedSurface</code></b></td>
    <td align="center"><b><code>AnimatedGradientBorder</code></b></td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/screenshots/shader_skeleton.gif" width="220" alt="Skeleton list rows with a shimmer sweep, cross-fading to the loaded content" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/screenshots/frosted_surface.gif" width="220" alt="Frosted app bar, card and bottom bar blurring moving colour blobs" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/screenshots/animated_gradient_border.gif" width="220" alt="Rotating gradient border with glow marking the selected plan and an Ask AI button" />
    </td>
  </tr>
</table>

### Effects

<table>
  <tr>
    <td align="center"><b><code>SnowEffect</code></b></td>
    <td align="center"><b><code>AuroraEffect</code></b></td>
    <td align="center"><b><code>FireEffect</code></b></td>
    <td align="center"><b><code>WaterEffect</code></b></td>
    <td align="center"><b><code>WaveBackground</code></b></td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/snow.gif" width="150" alt="Falling snow particles" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/aurora.gif" width="150" alt="Aurora curtain bands" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/fire.gif" width="150" alt="Rising flame" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/water.gif" width="150" alt="Underwater caustics" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/wave.gif" width="150" alt="Flowing wave gradient" />
    </td>
  </tr>
  <tr>
    <td align="center"><b><code>GlassEffect</code></b></td>
    <td align="center"><b><code>ShimmerEffect</code></b></td>
    <td align="center"><b><code>PulseEffect</code></b></td>
    <td align="center"><b><code>GlowOrb</code></b></td>
    <td align="center"><b><code>RippleEffect</code></b></td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/glass.gif" width="150" alt="Simulated frosted glass card" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/shimmer.gif" width="150" alt="Shimmer sweeping over placeholder bars" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/pulse.gif" width="150" alt="Breathing pulse rings around a heart icon" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/glow_orb.gif" width="150" alt="Glowing cyan orb" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/effects/ripple.gif" width="150" alt="Ripples expanding from taps" />
    </td>
  </tr>
</table>

### Example app

<table>
  <tr>
    <td align="center"><b>Home dashboard</b></td>
    <td align="center"><b>Explore &amp; gallery</b></td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/app_1.gif" width="180" alt="Example app home dashboard and overview" />
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/erykkruk/flutter_shaders_ui/main/doc/media/app_2.gif" width="180" alt="Example app explore screen and effect gallery" />
    </td>
  </tr>
</table>

> All clips are real-time recordings. The full example app lives in [`example/`](example): run `flutter run` inside it to try every effect with live controls. Add `--dart-define=TOUR=true` to cycle through every playground automatically, which is how these clips were recorded.

## Installation

```yaml
dependencies:
  flutter_shaders_ui: ^1.3.0
```

## Quick Start

```dart
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

// Wave background
Scaffold(
  body: WaveBackground(
    color1: const Color(0xFF0D1B2A),
    color2: const Color(0xFF1B263B),
    child: Center(child: Text('Hello Shaders')),
  ),
)

// Glass card
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

## Everyday UI

Practical widgets for real app screens. All of them work with one line,
follow the ambient light/dark theme where it matters, respect reduced motion
and `ShaderPerformance`, and degrade gracefully if their shader cannot load.

| Widget | Use it for |
|--------|------------|
| `ShaderSkeleton` + `SkeletonBone` | Loading placeholders that follow your layout, with a shimmer sweep |
| `FrostedSurface` | Frosted glass app bars, cards, bottom sheets and dialogs (real backdrop blur) |
| `AnimatedGradientBorder` | Selected cards, focused fields, premium or AI actions, primary buttons |

### Skeleton loading

```dart
ShaderSkeleton(
  isLoading: user == null,
  placeholder: const Row(
    children: [
      SkeletonBone.circle(size: 40),
      SizedBox(width: 12),
      Expanded(child: SkeletonBone()),
    ],
  ),
  child: UserTile(user: user),
)
```

The shimmer is drawn only where the placeholder paints, so gaps stay
transparent. Without a `placeholder`, the child itself is used as the shape.
While loading, taps are blocked and screen readers hear `semanticsLabel`
(default "Loading") instead of the placeholder. Once loaded, it cross-fades
to the content (instantly under reduced motion).

### Frosted surface

```dart
FrostedSurface(
  padding: const EdgeInsets.all(16),
  child: const Text('Frosted card'),
)
```

Blurs what is behind it with `BackdropFilter`, tints it, adds a hairline
border and a fine static frost grain. The grain is rendered once, so after
the first frame it costs no more than a plain blurred container; pass
`animateFrost: true` for a drifting texture. Unlike `GlassEffect`, which only
simulates frost on top of its child, this surface really blurs the content
behind it and works on both Skia and Impeller.

### Animated gradient border

```dart
AnimatedGradientBorder(
  glow: 0.6,
  glowSpread: 10,
  child: FilledButton(onPressed: () {}, child: const Text('Upgrade')),
)
```

`colors` takes up to four colours (default violet, cyan, pink). The child is
inset by `borderWidth + glowSpread`; with `enabled: false` the inset stays,
so toggling selection never shifts the layout. `speed: 0` keeps the gradient
still and stops repainting.

## Available Effects

### Backgrounds

| Widget | Description |
|--------|-------------|
| `WaveBackground` | Animated flowing wave gradient — splash screens, card headers |
| `AuroraEffect` | Northern lights curtain bands — hero sections, cosmic UI |
| `FireEffect` | Rising flames with ember sparks — game UI, dramatic accents |
| `WaterEffect` | Underwater caustics with foam — aquatic themes, depth effects |

### Overlays

| Widget | Description |
|--------|-------------|
| `GlassEffect` | Frosted glass / glassmorphism — cards, modals, premium UI |
| `ShimmerEffect` | Sweeping shine highlight — loading skeletons, badges |
| `SnowEffect` | Falling parallax snowflakes — seasonal UI, ambient decoration |
| `PulseEffect` | Breathing radial glow rings — notifications, live indicators |

### Interactive

| Widget | Description |
|--------|-------------|
| `RippleEffect` | Tap-triggered concentric waves — buttons, tappable cards |
| `GlowOrb` | Positionable glowing sphere (static, bouncing, draggable) |

### Combining Effects

```dart
Stack(
  children: [
    Positioned.fill(
      child: WaveBackground(
        color1: const Color(0xFF0B0E1A),
        color2: const Color(0xFF131B2E),
      ),
    ),
    Positioned.fill(
      child: GlowOrb.bouncing(
        color: const Color(0xFF6366F1),
        radius: 0.18,
        glowIntensity: 0.3,
      ),
    ),
    SafeArea(child: YourContent()),
  ],
)
```

## Performance

- **GPU-accelerated** — all effects run as GLSL fragment shaders on the GPU
- **Compiled once and cached** — `ShaderCache` prevents recompilation
- **Zero cost when disabled** — `enabled: false` renders only `child`, no GPU work
- **Ticker-based animation** — respects Flutter's frame scheduling
- **RepaintBoundary** — isolates shader repaints from the widget tree
- **One shader per widget** — uniforms are rewritten between draws, not a new `FragmentShader` per frame
- **Frame-rate cap** — `maxFramesPerSecond` trades refresh rate for battery without slowing the motion
- **Reduced motion** — animation freezes when the platform asks for it, the effect still renders
- **Still frames are free** - `timeScale: 0` renders the first frame once instead of on every vsync

### Capping the frame rate

Shader effects repaint every frame, which on a 120 Hz display is twice the
work a 60 Hz one does for visuals that rarely need it. Cap a whole subtree
at once:

```dart
ShaderPerformance(
  settings: const ShaderPerformanceSettings(maxFramesPerSecond: 30),
  child: MyPage(),
)
```

Or a single effect:

```dart
ShaderEffectWidget(
  assetPath: 'packages/flutter_shaders_ui/shaders/aurora.frag',
  maxFramesPerSecond: 24,
  child: const Text('Calm aurora'),
)
```

A cap only skips repaints: the clock still advances in real time, so the
animation keeps its speed and just updates less often. A per-widget value
wins over the inherited one.

### Reduced motion

When the platform asks for reduced motion, shader animation freezes on its
first frame and the effect renders as a still image. Opt out for a specific
effect with `respectReducedMotion: false`, or for a subtree through
`ShaderPerformanceSettings(respectReducedMotion: false)`.

## Core API

For building custom shader widgets:

| Class | Purpose |
|-------|---------|
| `ShaderEffectWidget` | Base widget: shader loading, time animation, uniform setup |
| `ShaderCache` | Global cache for compiled `FragmentProgram` instances |
| `ShaderPainter` | Reusable `CustomPainter` for rendering shaders to canvas |
| `ShaderPerformance` / `ShaderPerformanceSettings` | Frame-rate cap and reduced-motion policy for a subtree |

Set `maskToChild: true` on `ShaderEffectWidget` to paint the shader only
where the child has pixels (`BlendMode.srcATop`), which is how
`ShaderSkeleton` recolours its bones.

### Controlling the animation clock

`ShaderEffectWidget.timeScale` multiplies the elapsed time fed into the
`uTime` uniform, giving you control over the global animation clock that the
per-widget `speed` uniforms cannot: `1.0` runs at real time, `0.5` at half
speed, `0.0` holds the first frame (drawn once, not on every vsync), and
negative values run in reverse.

```dart
ShaderEffectWidget(
  assetPath: 'packages/flutter_shaders_ui/shaders/aurora.frag',
  timeScale: 0.5, // half-speed animation
  child: const Text('Slow aurora'),
)
```

See the [Effects reference](https://codigee.com/open-source/flutter-shaders-ui/effects) for detailed widget docs and common patterns — also available as [markdown source](doc/README.md).

## Requirements

- Flutter >= 3.10.0
- Dart >= 3.0.0

## License

MIT — see [LICENSE](LICENSE) for details.
