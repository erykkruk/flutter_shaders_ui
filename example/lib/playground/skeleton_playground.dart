import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import 'widgets.dart';

/// How long each loading / loaded phase lasts in the demo loop.
const Duration _phaseDuration = Duration(milliseconds: 2600);

class SkeletonPlayground extends StatefulWidget {
  const SkeletonPlayground({super.key});

  @override
  State<SkeletonPlayground> createState() => _SkeletonPlaygroundState();
}

class _SkeletonPlaygroundState extends State<SkeletonPlayground> {
  double _speed = 1.0;
  double _bandWidth = 0.35;
  double _angle = 0.35;
  bool _isLoading = true;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    // Fake a request that keeps reloading, so the cross-fade is visible.
    _timer = Timer.periodic(
      _phaseDuration,
      (_) => setState(() => _isLoading = !_isLoading),
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
      title: 'Shader Skeleton',
      effect: Container(
        color: const Color(0xFF15181D),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 112, 16, 16),
          itemCount: _people.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => ShaderSkeleton(
            isLoading: _isLoading,
            speed: _speed,
            bandWidth: _bandWidth,
            angle: _angle,
            placeholder: const _TilePlaceholder(),
            child: _PersonTile(person: _people[index]),
          ),
        ),
      ),
      sliders: [
        ParamSlider(
          label: 'speed',
          value: _speed,
          min: 0.2,
          max: 3.0,
          onChanged: (v) => setState(() => _speed = v),
        ),
        ParamSlider(
          label: 'band',
          value: _bandWidth,
          min: 0.05,
          max: 1.0,
          onChanged: (v) => setState(() => _bandWidth = v),
        ),
        ParamSlider(
          label: 'angle',
          value: _angle,
          max: 1.57,
          onChanged: (v) => setState(() => _angle = v),
        ),
      ],
    );
  }
}

class _Person {
  const _Person(this.name, this.role, this.color);

  final String name;
  final String role;
  final Color color;
}

const _people = [
  _Person('Ada Lovelace', 'Analytical Engine', Color(0xFF7C3AED)),
  _Person('Alan Turing', 'Computability', Color(0xFF06B6D4)),
  _Person('Grace Hopper', 'Compilers', Color(0xFFF472B6)),
  _Person('Edsger Dijkstra', 'Shortest paths', Color(0xFFF59E0B)),
  _Person('Barbara Liskov', 'Abstraction', Color(0xFF10B981)),
];

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.person});

  final _Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F242B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: person.color,
            child: Text(
              person.name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  person.role,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white30),
        ],
      ),
    );
  }
}

class _TilePlaceholder extends StatelessWidget {
  const _TilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: Row(
        children: [
          SkeletonBone.circle(size: 44),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBone(width: 150, height: 16),
                SizedBox(height: 8),
                SkeletonBone(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
