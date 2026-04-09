import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wave background behind everything
        Positioned.fill(
          child: WaveBackground(
            color1: const Color(0xFF0B0E1A),
            color2: const Color(0xFF131B2E),
            amplitude: 0.15,
            frequency: 1.5,
            speed: 0.4,
          ),
        ),

        // Ambient glow orbs
        Positioned.fill(
          child: GlowOrb.bouncing(
            color: const Color(0xFF6366F1),
            radius: 0.18,
            glowIntensity: 0.3,
            speed: 0.08,
          ),
        ),

        // Main content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFeaturedBanner(),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Overview',
                  trailing: Text(
                    'This week',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatsRow(),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                _buildQuickActions(),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Recent Activity',
                  trailing: Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildActivityList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar with pulse
          SizedBox(
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: PulseEffect(
                color: const Color(0xFF6366F1),
                speed: 0.5,
                intensity: 0.3,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'E',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Eryk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell with pulse for unread
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ShimmerEffect(
          color: Colors.white,
          speed: 0.6,
          width: 0.12,
          child: Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
            ),
            child: Stack(
              children: [
                // Subtle glass pattern overlay
                Positioned.fill(
                  child: GlassEffect(
                    frost: 0.15,
                    opacity: 0.08,
                    blurAmount: 0.2,
                    tint: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Shader Effects',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'GPU-accelerated UI effects\nfor Flutter apps',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Explore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _StatCard(
            label: 'Effects',
            value: '9',
            icon: Icons.auto_awesome,
            color: Color(0xFF6366F1),
          ),
          SizedBox(width: 12),
          _StatCard(
            label: 'Shaders',
            value: '9',
            icon: Icons.brush,
            color: Color(0xFF10B981),
          ),
          SizedBox(width: 12),
          _StatCard(
            label: 'FPS',
            value: '60',
            icon: Icons.speed,
            color: Color(0xFFF59E0B),
          ),
          SizedBox(width: 12),
          _StatCard(
            label: 'Size',
            value: '0kb',
            icon: Icons.storage,
            color: Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.play_arrow_rounded,
              label: 'Preview',
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.code,
              label: 'Source',
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.share,
              label: 'Share',
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ActivityTile(
            icon: Icons.add_circle_outline,
            title: 'AuroraEffect added',
            subtitle: '5-layer curtains with FBM noise',
            time: '2h ago',
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 10),
          _ActivityTile(
            icon: Icons.update,
            title: 'GlowOrb updated',
            subtitle: 'Draggable mode + bounce physics',
            time: '5h ago',
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(height: 10),
          _ActivityTile(
            icon: Icons.bug_report_outlined,
            title: 'ShimmerEffect fix',
            subtitle: 'Fixed sparkle noise on low-res',
            time: '1d ago',
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 10),
          _ActivityTile(
            icon: Icons.star_outline,
            title: 'v0.1.0 released',
            subtitle: 'Initial pub.dev release',
            time: '3d ago',
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat card — glass + glow
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick action button with ripple
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: RippleEffect(
        color: color,
        intensity: 0.8,
        duration: const Duration(milliseconds: 700),
        child: GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
// Activity tile
// ---------------------------------------------------------------------------

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
