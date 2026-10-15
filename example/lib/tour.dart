import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'playground/aurora_playground.dart';
import 'playground/fire_playground.dart';
import 'playground/frosted_playground.dart';
import 'playground/glass_playground.dart';
import 'playground/glow_orb_playground.dart';
import 'playground/gradient_border_playground.dart';
import 'playground/pulse_playground.dart';
import 'playground/ripple_playground.dart';
import 'playground/shimmer_playground.dart';
import 'playground/skeleton_playground.dart';
import 'playground/snow_playground.dart';
import 'playground/water_playground.dart';
import 'playground/wave_playground.dart';

/// How long each playground stays on screen during the tour.
const Duration tourSceneDuration = Duration(seconds: 7);

/// Gap between synthetic taps on the ripple playground.
const Duration _rippleTapInterval = Duration(milliseconds: 1100);

/// Order of the playgrounds in the tour, used to record README media.
///
/// Run with `--dart-define=TOUR=true`; the app then cycles through these
/// without transitions, so a single screen recording can be cut into one
/// clip per effect.
const List<String> tourSceneNames = [
  'skeleton',
  'frosted',
  'gradient_border',
  'snow',
  'aurora',
  'fire',
  'glass',
  'water',
  'wave',
  'shimmer',
  'pulse',
  'glow_orb',
  'ripple',
];

Widget _sceneFor(String name) {
  switch (name) {
    case 'skeleton':
      return const SkeletonPlayground();
    case 'frosted':
      return const FrostedPlayground();
    case 'gradient_border':
      return const GradientBorderPlayground();
    case 'snow':
      return const SnowPlayground();
    case 'aurora':
      return const AuroraPlayground();
    case 'fire':
      return const FirePlayground();
    case 'glass':
      return const GlassPlayground();
    case 'water':
      return const WaterPlayground();
    case 'wave':
      return const WavePlayground();
    case 'shimmer':
      return const ShimmerPlayground();
    case 'pulse':
      return const PulsePlayground();
    case 'glow_orb':
      return const GlowOrbPlayground();
    case 'ripple':
      return const RipplePlayground();
  }
  throw ArgumentError.value(name, 'name', 'Unknown tour scene');
}

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  int _index = 0;
  int _pointer = 1000;
  final _random = math.Random(7);
  late final Timer _sceneTimer;
  Timer? _tapTimer;

  @override
  void initState() {
    super.initState();
    _sceneTimer = Timer.periodic(tourSceneDuration, (_) => _next());
    _syncTaps();
  }

  void _next() {
    if (_index >= tourSceneNames.length - 1) {
      _sceneTimer.cancel();
      _tapTimer?.cancel();
      return;
    }
    setState(() => _index++);
    _syncTaps();
  }

  void _syncTaps() {
    _tapTimer?.cancel();
    if (tourSceneNames[_index] != 'ripple') return;
    _tapTimer = Timer.periodic(_rippleTapInterval, (_) => _tap());
  }

  void _tap() {
    final size = MediaQuery.sizeOf(context);
    final position = Offset(
      size.width * (0.25 + _random.nextDouble() * 0.5),
      size.height * (0.2 + _random.nextDouble() * 0.4),
    );
    final pointer = _pointer++;
    GestureBinding.instance
      ..handlePointerEvent(
        PointerDownEvent(pointer: pointer, position: position),
      )
      ..handlePointerEvent(
        PointerUpEvent(pointer: pointer, position: position),
      );
  }

  @override
  void dispose() {
    _sceneTimer.cancel();
    _tapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = tourSceneNames[_index];
    return KeyedSubtree(key: ValueKey(name), child: _sceneFor(name));
  }
}
