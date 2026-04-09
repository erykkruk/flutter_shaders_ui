import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0E1A), Color(0xFF111827)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildTrendingBanner(),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Categories'),
              const SizedBox(height: 12),
              _buildCategoryGrid(),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Popular Effects'),
              const SizedBox(height: 12),
              _buildPopularList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Explore',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white38, size: 22),
            const SizedBox(width: 10),
            Text(
              'Search effects...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 160,
          child: Stack(
            children: [
              // Dark base
              Positioned.fill(
                child: Container(color: const Color(0xFF1A0500)),
              ),

              // Fire effect as background
              Positioned.fill(
                child: FireEffect(
                  intensity: 0.5,
                  speed: 0.7,
                  color1: const Color(0xFFFF8A00),
                  color2: const Color(0xFFE52E71),
                ),
              ),

              // Content on top
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'TRENDING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'FireEffect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Layered FBM flames with ember sparks',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: const [
          _CategoryCard(
            title: 'Backgrounds',
            count: 3,
            icon: Icons.gradient,
            color: Color(0xFF6366F1),
          ),
          _CategoryCard(
            title: 'Overlays',
            count: 4,
            icon: Icons.layers,
            color: Color(0xFF10B981),
          ),
          _CategoryCard(
            title: 'Interactive',
            count: 2,
            icon: Icons.touch_app,
            color: Color(0xFFF59E0B),
          ),
          _CategoryCard(
            title: 'Seasonal',
            count: 2,
            icon: Icons.ac_unit,
            color: Color(0xFF06B6D4),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _EffectPreviewCard(
            title: 'Aurora',
            subtitle: 'Northern lights',
            child: Container(
              color: const Color(0xFF050505),
              child: AuroraEffect(
                color1: const Color(0xFF00E676),
                color2: const Color(0xFF7C4DFF),
                intensity: 0.6,
                speed: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _EffectPreviewCard(
            title: 'Wave',
            subtitle: 'Flowing gradient',
            child: WaveBackground(
              color1: const Color(0xFF1E3A5F),
              color2: const Color(0xFF0891B2),
              amplitude: 0.35,
              speed: 0.8,
            ),
          ),
          const SizedBox(width: 12),
          _EffectPreviewCard(
            title: 'Snow',
            subtitle: 'Parallax flakes',
            child: Container(
              color: const Color(0xFF0D1B2A),
              child: SnowEffect(density: 0.6, speed: 0.8),
            ),
          ),
          const SizedBox(width: 12),
          _EffectPreviewCard(
            title: 'Glow Orb',
            subtitle: 'Bouncing light',
            child: Container(
              color: const Color(0xFF0A0A0A),
              child: GlowOrb.bouncing(
                color: const Color(0xFF06B6D4),
                radius: 0.2,
                speed: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category card with ripple
// ---------------------------------------------------------------------------

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: RippleEffect(
        color: color,
        intensity: 0.7,
        duration: const Duration(milliseconds: 600),
        child: GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Effect preview card
// ---------------------------------------------------------------------------

class _EffectPreviewCard extends StatelessWidget {
  const _EffectPreviewCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
