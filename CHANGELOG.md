# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0]

### Added

- 10 GPU-accelerated shader effect widgets:
  - `WaveBackground` — animated flowing wave gradient
  - `AuroraEffect` — northern lights curtain bands
  - `FireEffect` — rising flames with ember sparks
  - `WaterEffect` — underwater caustics with foam
  - `GlassEffect` — frosted glass / glassmorphism overlay
  - `ShimmerEffect` — sweeping shine highlight
  - `SnowEffect` — falling parallax snowflakes
  - `PulseEffect` — breathing radial glow rings
  - `RippleEffect` — tap-triggered concentric waves
  - `GlowOrb` — positionable glowing sphere (static, bouncing, draggable)
- Core infrastructure:
  - `ShaderEffectWidget` — base widget with ticker animation and uniform management
  - `ShaderCache` — global cache for compiled `FragmentProgram` instances
  - `ShaderPainter` — reusable `CustomPainter` for shader rendering
- 10 GLSL fragment shaders (aurora, fire, glass, glow_orb, pulse, ripple, shimmer, snow, water, wave)
- Example app with individual playgrounds and full showcase
- Zero external dependencies (Flutter SDK only)
