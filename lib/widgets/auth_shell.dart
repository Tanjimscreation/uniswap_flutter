import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated mesh-gradient background with floating decorative blobs.
/// Used by both Login + Registration to give a unified premium feel.
class AuthShell extends StatefulWidget {
  final Widget child;
  const AuthShell({super.key, required this.child});

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0F4A),
      body: Stack(
        children: [
          // ── Base radial gradient ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.3, -0.6),
                  radius: 1.4,
                  colors: [
                    Color(0xFF6C3CE1),
                    Color(0xFF3A1D8E),
                    Color(0xFF1B0F4A),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Animated floating blobs ──
          AnimatedBuilder(
            animation: _ctrl,
            builder: (ctx, _) {
              return Stack(
                children: [
                  _blob(
                    color: const Color(0xFF8B6CEF).withValues(alpha: 0.55),
                    size: 280,
                    dx: math.sin(_ctrl.value * 2 * math.pi) * 30 - 80,
                    dy: math.cos(_ctrl.value * 2 * math.pi) * 20 + 40,
                  ),
                  _blob(
                    color: const Color(0xFF00D4AA).withValues(alpha: 0.35),
                    size: 220,
                    dx: math.cos(_ctrl.value * 2 * math.pi) * 40 +
                        MediaQuery.of(context).size.width - 200,
                    dy: math.sin(_ctrl.value * 2 * math.pi + 1) * 30 + 100,
                  ),
                  _blob(
                    color: const Color(0xFFFF6B9E).withValues(alpha: 0.30),
                    size: 240,
                    dx: math.sin(_ctrl.value * 2 * math.pi + 2) * 50 +
                        MediaQuery.of(context).size.width * 0.3,
                    dy: math.cos(_ctrl.value * 2 * math.pi + 2) * 40 +
                        MediaQuery.of(context).size.height - 320,
                  ),
                ],
              );
            },
          ),

          // ── Subtle grain / noise via dotted pattern ──
          Positioned.fill(
            child: CustomPaint(painter: _DotPainter()),
          ),

          // ── Content ──
          SafeArea(child: widget.child),
        ],
      ),
    );
  }

  Widget _blob({
    required Color color,
    required double size,
    required double dx,
    required double dy,
  }) {
    return Positioned(
      left: dx,
      top: dy,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
          ),
        ),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.04);
    const spacing = 24.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter old) => false;
}

/// Glassmorphic card used inside AuthShell for forms.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTheme.r24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

/// Glass text field optimised for the dark glassmorphic shell.
class GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final String? errorText;
  final bool? success;

  const GlassField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.errorText,
    this.success,
  });

  @override
  Widget build(BuildContext context) {
    Widget? trailing = suffix;
    if (success == true) {
      trailing = const Icon(Icons.check_circle_rounded,
          color: AppTheme.success, size: 22);
    } else if (errorText != null && errorText!.isNotEmpty) {
      trailing = const Icon(Icons.error_outline_rounded,
          color: AppTheme.error, size: 22);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.7)),
            suffixIcon: trailing,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            labelStyle:
                TextStyle(color: Colors.white.withValues(alpha: 0.75)),
            hintStyle:
                TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.r16),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.r16),
              borderSide: BorderSide(
                color: success == true
                    ? AppTheme.success.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.r16),
              borderSide: BorderSide(
                color: success == true
                    ? AppTheme.success
                    : Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: Color(0xFFFF8A95)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    errorText!,
                    style: const TextStyle(
                        color: Color(0xFFFF8A95),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
