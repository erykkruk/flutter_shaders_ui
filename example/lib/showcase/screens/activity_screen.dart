import 'package:flutter/material.dart';
import 'package:flutter_shaders_ui/flutter_shaders_ui.dart';

import '../widgets/glass_card.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Subtle dark background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0B0E1A), Color(0xFF111827)],
              ),
            ),
          ),
        ),

        // Very subtle snow for ambience
        Positioned.fill(
          child: SnowEffect(
            density: 0.15,
            speed: 0.3,
            size: 0.3,
          ),
        ),

        // Main content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(child: _buildNotificationsList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '3 new',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _FilterChip(label: 'All', isActive: true),
          const SizedBox(width: 8),
          _FilterChip(label: 'Updates', isActive: false),
          const SizedBox(width: 8),
          _FilterChip(label: 'Mentions', isActive: false),
          const SizedBox(width: 8),
          _FilterChip(label: 'Releases', isActive: false),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Unread — with pulse
        _NotificationCard(
          icon: Icons.star,
          iconColor: const Color(0xFFF59E0B),
          title: 'New star on flutter_shaders_ui',
          message: 'user_2048 starred your repository',
          time: '5 min ago',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          icon: Icons.merge_type,
          iconColor: const Color(0xFF10B981),
          title: 'PR #12 merged',
          message: 'feat: add GlowOrb.draggable() constructor',
          time: '1h ago',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          icon: Icons.bug_report,
          iconColor: const Color(0xFFEF4444),
          title: 'Issue #8 opened',
          message: 'ShimmerEffect flickers on low-end devices',
          time: '3h ago',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          icon: Icons.rocket_launch,
          iconColor: const Color(0xFF6366F1),
          title: 'Published to pub.dev',
          message: 'flutter_shaders_ui v0.1.0 is now live',
          time: '1d ago',
          isUnread: false,
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          icon: Icons.comment,
          iconColor: const Color(0xFF06B6D4),
          title: 'New comment on Issue #5',
          message: 'Great work on the aurora shader!',
          time: '2d ago',
          isUnread: false,
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          icon: Icons.person_add,
          iconColor: const Color(0xFF8B5CF6),
          title: 'New follower',
          message: 'dart_dev_42 started following you',
          time: '3d ago',
          isUnread: false,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF6366F1)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white54,
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification card — unread has pulse effect
// ---------------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    final card = GlassCard(
      borderColor: isUnread
          ? const Color(0xFF6366F1).withValues(alpha: 0.3)
          : null,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container — pulse on unread
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                              isUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!isUnread) return card;

    // Wrap unread notifications in a subtle pulse
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: PulseEffect(
        color: iconColor.withValues(alpha: 0.4),
        speed: 0.4,
        intensity: 0.15,
        child: card,
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.12),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
