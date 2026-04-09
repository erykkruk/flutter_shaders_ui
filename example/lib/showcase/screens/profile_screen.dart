import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 28),
            _buildPremiumBanner(),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Achievements'),
            const SizedBox(height: 12),
            _buildAchievementsList(),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Settings'),
            const SizedBox(height: 12),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          // Aurora background for the header
          Positioned.fill(
            child: ClipRect(
              child: Container(
                color: const Color(0xFF050508),
                child: AuroraEffect(
                  color1: const Color(0xFF6366F1),
                  color2: const Color(0xFF06B6D4),
                  intensity: 0.5,
                  speed: 0.6,
                ),
              ),
            ),
          ),

          // Gradient fade to content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF0B0E1A), Colors.transparent],
                ),
              ),
            ),
          ),

          // Profile info
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'EK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Eryk Kruk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '9',
              label: 'Packages',
              color: const Color(0xFF6366F1),
            ),
          ),
          _divider(),
          Expanded(
            child: _StatItem(
              value: '142',
              label: 'Stars',
              color: const Color(0xFFF59E0B),
            ),
          ),
          _divider(),
          Expanded(
            child: _StatItem(
              value: '2.4k',
              label: 'Downloads',
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }

  Widget _buildPremiumBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ShimmerEffect(
          color: const Color(0xFFFFD700),
          speed: 0.5,
          width: 0.1,
          child: GlassCard(
            borderColor: const Color(0xFFFFD700).withValues(alpha: 0.2),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Color(0xFFFFD700),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pro Publisher',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Verified pub.dev publisher',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _AchievementBadge(
            icon: Icons.rocket_launch,
            label: 'First Pub',
            color: const Color(0xFF6366F1),
            isUnlocked: true,
          ),
          const SizedBox(width: 12),
          _AchievementBadge(
            icon: Icons.star,
            label: '100 Stars',
            color: const Color(0xFFF59E0B),
            isUnlocked: true,
          ),
          const SizedBox(width: 12),
          _AchievementBadge(
            icon: Icons.code,
            label: '10 Packages',
            color: const Color(0xFF10B981),
            isUnlocked: false,
          ),
          const SizedBox(width: 12),
          _AchievementBadge(
            icon: Icons.bolt,
            label: '1k DL/mo',
            color: const Color(0xFFEF4444),
            isUnlocked: false,
          ),
          const SizedBox(width: 12),
          _AchievementBadge(
            icon: Icons.diversity_3,
            label: '10 Contrib',
            color: const Color(0xFF8B5CF6),
            isUnlocked: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _SettingsTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              color: const Color(0xFF6366F1),
            ),
            _settingsDivider(),
            _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              color: const Color(0xFF8B5CF6),
            ),
            _settingsDivider(),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              color: const Color(0xFFF59E0B),
            ),
            _settingsDivider(),
            _SettingsTile(
              icon: Icons.shield_outlined,
              title: 'Privacy',
              color: const Color(0xFF10B981),
            ),
            _settingsDivider(),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              color: const Color(0xFF06B6D4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsDivider() {
    return Divider(
      height: 1,
      indent: 52,
      color: Colors.white.withValues(alpha: 0.06),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat item (centered column)
// ---------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Achievement badge — locked/unlocked with glow orb bg
// ---------------------------------------------------------------------------

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.isUnlocked,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isUnlocked ? color : Colors.white24;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 56,
              height: 56,
              child: isUnlocked
                  ? PulseEffect(
                      color: color.withValues(alpha: 0.5),
                      speed: 0.3,
                      intensity: 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: color.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(icon, color: color, size: 26),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Icon(icon, color: effectiveColor, size: 26),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isUnlocked ? Colors.white70 : Colors.white24,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings tile
// ---------------------------------------------------------------------------

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
        ],
      ),
    );
  }
}
