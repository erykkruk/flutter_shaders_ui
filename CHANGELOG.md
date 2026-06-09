# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-06-09

### Fixed
- Completed `.pubignore` so it also excludes build/tooling artifacts
  (`build/`, `.dart_tool/`, …). A `.pubignore` makes pub ignore `.gitignore`
  entirely, so 1.0.3 accidentally shipped a 43 MB build cache; the archive is
  now ~73 KB.

## [1.0.3] - 2026-06-09

### Changed
- Excluded the demo GIFs (`doc/media/`) from the published package via
  `.pubignore`. They are still shown in the README through raw GitHub URLs.

## [1.0.2] - 2026-06-09

### Changed
- Split the demo previews into five shorter, lighter real-time GIFs grouped
  into "Effects & live controls" (3 clips) and "Example app" (2 clips), each
  well under the size of the previous single long recording.

## [1.0.1] - 2026-06-09

### Changed
- Replaced the demo preview GIFs with real-time (non-accelerated) recordings
  at full duration, served under new filenames to bust CDN/proxy caches.

## [1.0.0] - 2026-06-09

### Added
- Demo section in the README with two side-by-side preview GIFs
  (`doc/media/demo_effects.gif`, `doc/media/demo_app.gif`) showing the
  effects with live controls and the example gallery app.

### Changed
- Promoted the package to its first stable release. The public API
  (10 shader widgets + `ShaderEffectWidget`, `ShaderCache`, `ShaderPainter`)
  is now considered stable under Semantic Versioning.

## [0.1.2] - 2026-06-07

### Changed
- Expanded the library-level documentation with a catalogue of all available
  shader widgets for easier discovery on the package page.

## [0.1.1] - 2026-05-13

### Changed
- Replaced the deprecated `library flutter_shaders_ui;` directive with
  the modern unnamed `library;` declaration in the barrel file.

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
