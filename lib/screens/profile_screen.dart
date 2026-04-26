import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';
import '../widgets/list_item_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        if (!auth.isLoggedIn || auth.user == null) return _notLoggedIn(ctx);
        return _ProfileBody(auth: auth);
      },
    );
  }

  Widget _notLoggedIn(BuildContext ctx) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.bgLight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.person_outline_rounded,
                  size: 36, color: AppTheme.textHint),
            ),
            const SizedBox(height: 16),
            Text('Not Signed In', style: AppTheme.displaySm),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(ctx).pushReplacementNamed('/login'),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final AuthProvider auth;
  const _ProfileBody({required this.auth});

  @override
  Widget build(BuildContext context) {
    final u = auth.user!;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSheet(context),
        elevation: 4,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('List Item',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox.shrink(),
            actions: [
              // Settings / logout
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  onPressed: () => _confirmLogout(context),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: u.avatarUrl != null
                                ? Image.network(
                                    u.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _avatarFallback(u.initials),
                                  )
                                : _avatarFallback(u.initials),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Name + badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                u.fullName,
                                style: AppTheme.displayMd.copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (u.verified) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.verified_rounded,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Location pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  size: 13,
                                  color:
                                      Colors.white.withValues(alpha: 0.8)),
                              const SizedBox(width: 4),
                              Text(
                                u.campusLabel,
                                style: AppTheme.bodySm.copyWith(
                                  color:
                                      Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          u.faculty,
                          style: AppTheme.bodySm.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Stats Row (overlapping card) ──
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.r20),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Row(
                  children: [
                    _stat(
                      icon: Icons.star_rounded,
                      iconColor: AppTheme.warning,
                      value: u.trustScore.toStringAsFixed(1),
                      label: 'Trust Score',
                    ),
                    _divider(),
                    _stat(
                      icon: Icons.swap_horiz_rounded,
                      iconColor: AppTheme.accent,
                      value: '${u.successfulSwaps}',
                      label: 'Swaps',
                    ),
                    _divider(),
                    _stat(
                      icon: Icons.inventory_2_outlined,
                      iconColor: AppTheme.primary,
                      value: '${auth.listings.length}',
                      label: 'Listings',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Section header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Row(
                children: [
                  Text('My Listings', style: AppTheme.displaySm),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${auth.listings.length} items',
                      style: AppTheme.bodySm
                          .copyWith(color: AppTheme.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Listings Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => ItemCard(product: auth.listings[i]),
                childCount: auth.listings.length,
              ),
            ),
          ),

          // Bottom padding for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _avatarFallback(String initials) {
    return Container(
      color: AppTheme.primaryLight,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTheme.displayMd.copyWith(color: Colors.white, fontSize: 28),
      ),
    );
  }

  Widget _stat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTheme.headingLg.copyWith(fontSize: 20)),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.bodySm),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 48,
      color: AppTheme.border,
    );
  }

  void _openSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ListItemSheet(),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dlg) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Leaving so soon?', style: AppTheme.headingLg),
        content: Text(
          'Your listings are still visible to other students. You can come back any time.',
          style: AppTheme.bodyMd,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dlg),
                    child: const Text('Stay'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dlg);
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (_) => false);
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
