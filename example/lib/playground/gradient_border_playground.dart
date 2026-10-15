import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

/// How often the demo moves the selection to the next plan.
const Duration _selectionInterval = Duration(milliseconds: 2000);

class GradientBorderPlayground extends StatefulWidget {
  const GradientBorderPlayground({super.key});

  @override
  State<GradientBorderPlayground> createState() =>
      _GradientBorderPlaygroundState();
}

class _GradientBorderPlaygroundState extends State<GradientBorderPlayground> {
  double _speed = 1.0;
  double _borderWidth = 2.0;
  double _glow = 0.6;
  int _selected = 1;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      _selectionInterval,
      (_) => setState(() => _selected = (_selected + 1) % _plans.length),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundShell(
      title: 'Animated Gradient Border',
      effect: Container(
        color: const Color(0xFF0B0F17),
        padding: const EdgeInsets.fromLTRB(20, 112, 20, 20),
        child: Column(
          children: [
            for (var i = 0; i < _plans.length; i++) ...[
              GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedGradientBorder(
                  enabled: i == _selected,
                  speed: _speed,
                  borderWidth: _borderWidth,
                  borderRadius: 18,
                  glow: _glow,
                  glowSpread: 10,
                  child: _PlanCard(plan: _plans[i], selected: i == _selected),
                ),
              ),
              const SizedBox(height: 4),
            ],
            const Spacer(),
            AnimatedGradientBorder(
              speed: _speed,
              borderWidth: _borderWidth,
              borderRadius: 28,
              glow: _glow,
              glowSpread: 12,
              colors: const [
                Color(0xFFF59E0B),
                Color(0xFFF472B6),
                Color(0xFF7C3AED),
                Color(0xFF06B6D4),
              ],
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF161B26),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Ask AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'speed',
          value: _speed,
          max: 3.0,
          onChanged: (v) => setState(() => _speed = v),
        ),
        ParamSlider(
          label: 'width',
          value: _borderWidth,
          min: 1.0,
          max: 6.0,
          onChanged: (v) => setState(() => _borderWidth = v),
        ),
        ParamSlider(
          label: 'glow',
          value: _glow,
          onChanged: (v) => setState(() => _glow = v),
        ),
      ],
    );
  }
}

class _Plan {
  const _Plan(this.name, this.price, this.detail);

  final String name;
  final String price;
  final String detail;
}

const _plans = [
  _Plan('Starter', 'Free', '1 project, community support'),
  _Plan('Pro', '\$12 / mo', 'Unlimited projects, priority support'),
  _Plan('Team', '\$29 / mo', 'Shared workspaces, SSO, audit log'),
];

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.selected});

  final _Plan plan;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? Colors.white : Colors.white38,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.detail,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            plan.price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
