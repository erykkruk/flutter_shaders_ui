import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/shader_effect_widget.dart';

const double _defaultRadius = 0.15;
const double _defaultGlowIntensity = 1.0;
const double _defaultPulseSpeed = 2.0;
const double _defaultBounceSpeed = 0.3;

/// A positionable glowing orb with optional bouncing animation.
///
/// Renders a volumetric glowing sphere that can be positioned freely
/// or set to bounce off the container edges automatically.
///
/// The shader creates a bright center core with soft exponential falloff,
/// a halo glow, subtle internal light variation (noise caustics), and a
/// breathing pulse animation. The background is transparent for compositing.
///
/// Static positioned orb:
/// ```dart
/// GlowOrb(
///   position: Offset(0.5, 0.5), // center
///   color: Colors.cyan,
///   radius: 0.15,
/// )
/// ```
///
/// Bouncing orb (screensaver style):
/// ```dart
/// GlowOrb.bouncing(
///   color: Colors.purple,
///   radius: 0.1,
///   speed: 0.3,
/// )
/// ```
class GlowOrb extends StatelessWidget {
  /// Creates a statically positioned glowing orb.
  ///
  /// [position] is a normalized offset where (0,0) is top-left and (1,1) is
  /// bottom-right. Defaults to the center of the widget.
  ///
  /// [radius] controls the orb size as a fraction of the widget dimension
  /// (0.0-1.0). Defaults to 0.15.
  ///
  /// [glowIntensity] multiplies the overall brightness. Values above 1.0
  /// create a more blown-out, intense glow.
  ///
  /// [pulseSpeed] controls how fast the breathing animation runs in radians
  /// per second.
  const GlowOrb({
    super.key,
    this.position = const Offset(0.5, 0.5),
    this.color = Colors.cyan,
    this.radius = _defaultRadius,
    this.glowIntensity = _defaultGlowIntensity,
    this.pulseSpeed = _defaultPulseSpeed,
    this.enabled = true,
    this.child,
  })  : _mode = _GlowOrbMode.static,
        _bounceSpeed = _defaultBounceSpeed;

  /// Creates a glowing orb that bounces off the container edges.
  ///
  /// The orb starts at a random position and moves with constant velocity,
  /// reflecting off the widget boundaries.
  ///
  /// [speed] controls how fast the orb moves as a fraction of the widget
  /// dimension per second.
  const GlowOrb.bouncing({
    super.key,
    this.color = Colors.purple,
    this.radius = _defaultRadius,
    this.glowIntensity = _defaultGlowIntensity,
    this.pulseSpeed = _defaultPulseSpeed,
    this.enabled = true,
    this.child,
    double speed = _defaultBounceSpeed,
  })  : _mode = _GlowOrbMode.bouncing,
        _bounceSpeed = speed,
        position = const Offset(0.5, 0.5);

  /// Creates a glowing orb that can be dragged around by the user.
  ///
  /// The orb starts at [position] and follows the user's finger/pointer.
  /// Great for interactive UIs where the user controls the light source.
  ///
  /// ```dart
  /// GlowOrb.draggable(
  ///   color: Colors.orange,
  ///   radius: 0.12,
  ///   child: MyContent(),
  /// )
  /// ```
  const GlowOrb.draggable({
    super.key,
    this.position = const Offset(0.5, 0.5),
    this.color = Colors.orange,
    this.radius = _defaultRadius,
    this.glowIntensity = _defaultGlowIntensity,
    this.pulseSpeed = _defaultPulseSpeed,
    this.enabled = true,
    this.child,
  })  : _mode = _GlowOrbMode.draggable,
        _bounceSpeed = _defaultBounceSpeed;

  /// Normalized position of the orb center (0-1 on both axes).
  ///
  /// Only used when the orb is not bouncing.
  final Offset position;

  /// Color of the orb glow. The shader blends toward white at the core.
  final Color color;

  /// Radius of the orb as a fraction of the widget dimension.
  ///
  /// Typical values: 0.05 (small) to 0.3 (large).
  final double radius;

  /// Brightness multiplier. 1.0 is the default intensity.
  final double glowIntensity;

  /// Speed of the breathing/pulsing animation in radians per second.
  final double pulseSpeed;

  /// Whether the shader effect is active. When `false`, only [child] renders.
  final bool enabled;

  /// Optional child widget rendered behind the shader effect.
  final Widget? child;

  final _GlowOrbMode _mode;
  final double _bounceSpeed;

  @override
  Widget build(BuildContext context) {
    switch (_mode) {
      case _GlowOrbMode.bouncing:
        return _BouncingGlowOrb(
          color: color,
          radius: radius,
          glowIntensity: glowIntensity,
          pulseSpeed: pulseSpeed,
          enabled: enabled,
          bounceSpeed: _bounceSpeed,
          child: child,
        );
      case _GlowOrbMode.draggable:
        return _DraggableGlowOrb(
          initialPosition: position,
          color: color,
          radius: radius,
          glowIntensity: glowIntensity,
          pulseSpeed: pulseSpeed,
          enabled: enabled,
          child: child,
        );
      case _GlowOrbMode.static:
        return _StaticGlowOrb(
          position: position,
          color: color,
          radius: radius,
          glowIntensity: glowIntensity,
          pulseSpeed: pulseSpeed,
          enabled: enabled,
          child: child,
        );
    }
  }
}

enum _GlowOrbMode { static, bouncing, draggable }

// ---------------------------------------------------------------------------
// Static orb -- position controlled externally
// ---------------------------------------------------------------------------

class _StaticGlowOrb extends StatelessWidget {
  const _StaticGlowOrb({
    required this.position,
    required this.color,
    required this.radius,
    required this.glowIntensity,
    required this.pulseSpeed,
    required this.enabled,
    this.child,
  });

  static const _assetPath = 'packages/flutter_shaders_ui/shaders/glow_orb.frag';

  final Offset position;
  final Color color;
  final double radius;
  final double glowIntensity;
  final double pulseSpeed;
  final bool enabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderEffectWidget(
      assetPath: _assetPath,
      enabled: enabled,
      showAsOverlay: true,
      uniformSetter: (
        ui.FragmentShader shader,
        Size size,
        double time,
        int index,
      ) {
        var i = index;
        shader.setFloat(i++, position.dx); // uPosition.x
        shader.setFloat(i++, position.dy); // uPosition.y
        shader.setFloat(i++, radius); // uRadius
        shader.setFloat(i++, glowIntensity); // uGlowIntensity
        shader.setFloat(i++, color.r); // uColor.r
        shader.setFloat(i++, color.g); // uColor.g
        shader.setFloat(i++, color.b); // uColor.b
        shader.setFloat(i++, pulseSpeed); // uPulseSpeed
        return i;
      },
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Bouncing orb -- position managed internally via Ticker
// ---------------------------------------------------------------------------

class _BouncingGlowOrb extends StatefulWidget {
  const _BouncingGlowOrb({
    required this.color,
    required this.radius,
    required this.glowIntensity,
    required this.pulseSpeed,
    required this.enabled,
    required this.bounceSpeed,
    this.child,
  });

  final Color color;
  final double radius;
  final double glowIntensity;
  final double pulseSpeed;
  final bool enabled;
  final double bounceSpeed;
  final Widget? child;

  @override
  State<_BouncingGlowOrb> createState() => _BouncingGlowOrbState();
}

class _BouncingGlowOrbState extends State<_BouncingGlowOrb>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  double _px = 0.0;
  double _py = 0.0;
  double _vx = 0.0;
  double _vy = 0.0;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    if (widget.enabled) _ticker.start();
  }

  void _initPhysics() {
    final rng = Random();
    _px = 0.2 + rng.nextDouble() * 0.6;
    _py = 0.2 + rng.nextDouble() * 0.6;

    final angle = rng.nextDouble() * 2.0 * pi;
    _vx = cos(angle) * widget.bounceSpeed;
    _vy = sin(angle) * widget.bounceSpeed;
    _initialized = true;
  }

  void _onTick(Duration elapsed) {
    if (!_initialized) _initPhysics();

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;

    final clampedDt = dt.clamp(0.0, 0.05);

    _px += _vx * clampedDt;
    _py += _vy * clampedDt;

    const margin = 0.02;
    if (_px < margin) {
      _px = margin;
      _vx = _vx.abs();
    } else if (_px > 1.0 - margin) {
      _px = 1.0 - margin;
      _vx = -_vx.abs();
    }

    if (_py < margin) {
      _py = margin;
      _vy = _vy.abs();
    } else if (_py > 1.0 - margin) {
      _py = 1.0 - margin;
      _vy = -_vy.abs();
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(_BouncingGlowOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_ticker.isActive) {
      _ticker.start();
    } else if (!widget.enabled && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StaticGlowOrb(
      position: Offset(_px, _py),
      color: widget.color,
      radius: widget.radius,
      glowIntensity: widget.glowIntensity,
      pulseSpeed: widget.pulseSpeed,
      enabled: widget.enabled,
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// Draggable orb -- position controlled by user gesture
// ---------------------------------------------------------------------------

class _DraggableGlowOrb extends StatefulWidget {
  const _DraggableGlowOrb({
    required this.initialPosition,
    required this.color,
    required this.radius,
    required this.glowIntensity,
    required this.pulseSpeed,
    required this.enabled,
    this.child,
  });

  final Offset initialPosition;
  final Color color;
  final double radius;
  final double glowIntensity;
  final double pulseSpeed;
  final bool enabled;
  final Widget? child;

  @override
  State<_DraggableGlowOrb> createState() => _DraggableGlowOrbState();
}

class _DraggableGlowOrbState extends State<_DraggableGlowOrb> {
  late double _px;
  late double _py;

  @override
  void initState() {
    super.initState();
    _px = widget.initialPosition.dx;
    _py = widget.initialPosition.dy;
  }

  void _onPanStart(DragStartDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _updatePosition(Offset localPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    setState(() {
      _px = (localPosition.dx / size.width).clamp(0.0, 1.0);
      _py = (localPosition.dy / size.height).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onTapDown: (details) => _updatePosition(details.localPosition),
      behavior: HitTestBehavior.opaque,
      child: _StaticGlowOrb(
        position: Offset(_px, _py),
        color: widget.color,
        radius: widget.radius,
        glowIntensity: widget.glowIntensity,
        pulseSpeed: widget.pulseSpeed,
        enabled: widget.enabled,
        child: widget.child,
      ),
    );
  }
}
