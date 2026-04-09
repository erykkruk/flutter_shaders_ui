import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

class GlowOrbPlayground extends StatefulWidget {
  const GlowOrbPlayground({super.key});

  @override
  State<GlowOrbPlayground> createState() => _GlowOrbPlaygroundState();
}

class _GlowOrbPlaygroundState extends State<GlowOrbPlayground> {
  double _radius = 0.15;
  double _glowIntensity = 1.0;
  double _pulseSpeed = 2.0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Glow Orb — Drag it!',
      effect: Container(
        color: const Color(0xFF0D1117),
        child: GlowOrb.draggable(
          color: const Color(0xFF00E5FF),
          radius: _radius,
          glowIntensity: _glowIntensity,
          pulseSpeed: _pulseSpeed,
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'radius',
          value: _radius,
          min: 0.03,
          max: 0.4,
          onChanged: (v) => setState(() => _radius = v),
        ),
        ParamSlider(
          label: 'glow',
          value: _glowIntensity,
          max: 2.0,
          onChanged: (v) => setState(() => _glowIntensity = v),
        ),
        ParamSlider(
          label: 'pulse',
          value: _pulseSpeed,
          max: 5.0,
          onChanged: (v) => setState(() => _pulseSpeed = v),
        ),
      ],
    );
  }
}
