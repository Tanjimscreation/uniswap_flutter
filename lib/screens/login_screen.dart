import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool? _emailValid;

  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Animation<double> _stagger(double start) {
    return CurvedAnimation(
      parent: _entryCtrl,
      curve: Interval(start, math1(start + 0.6), curve: Curves.easeOut),
    );
  }

  double math1(double v) => v > 1 ? 1 : v;

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // ── Brand mark ──
            FadeTransition(
              opacity: _stagger(0.0),
              child: _brand(),
            ),
            const SizedBox(height: 40),

            // ── Greeting ──
            SlideTransition(
              position: Tween(begin: const Offset(0, 0.15), end: Offset.zero)
                  .animate(_stagger(0.1)),
              child: FadeTransition(
                opacity: _stagger(0.1),
                child: _greeting(),
              ),
            ),
            const SizedBox(height: 28),

            // ── Glass form card ──
            SlideTransition(
              position: Tween(begin: const Offset(0, 0.2), end: Offset.zero)
                  .animate(_stagger(0.25)),
              child: FadeTransition(
                opacity: _stagger(0.25),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassField(
                        controller: _emailCtrl,
                        label: 'UTM Email',
                        hint: 'name@utm.my',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        success: _emailValid,
                        onChanged: (v) {
                          final auth = context.read<AuthProvider>();
                          setState(() {
                            _emailValid = v.isEmpty
                                ? null
                                : auth.isValidUTMEmail(v);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GlassField(
                        controller: _passCtrl,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgot,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sign in button
                      _signInButton(),

                      const SizedBox(height: 18),

                      // Divider
                      Row(children: [
                        Expanded(
                            child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.18))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or continue with',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12)),
                        ),
                        Expanded(
                            child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.18))),
                      ]),
                      const SizedBox(height: 18),

                      // Google
                      _googleButton(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Sign up link ──
            FadeTransition(
              opacity: _stagger(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New on campus? ",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed('/registration'),
                    child: const Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF00D4AA),
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Social proof ──
            FadeTransition(
              opacity: _stagger(0.5),
              child: _socialProof(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pieces ─────────────────────────────────────────────

  Widget _brand() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child:
              const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 10),
        const Text(
          'UniSwap',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF00D4AA).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: const Color(0xFF00D4AA).withValues(alpha: 0.5)),
          ),
          child: const Text(
            'UTM',
            style: TextStyle(
              color: Color(0xFF00D4AA),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome back,',
          style: AppTheme.displayLg.copyWith(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFF00D4AA), Color(0xFFFFFFFF), Color(0xFFFF6B9E)],
          ).createShader(b),
          child: Text(
            'Scholar.',
            style: AppTheme.displayLg.copyWith(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to swap, UTMians?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _signInButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: const Color(0xFF0A2540),
          elevation: 8,
          shadowColor: const Color(0xFF00D4AA).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.r16),
          ),
        ),
        child: _loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF0A2540),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: _loading ? null : _google,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.r16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Real multi-color Google G
            CustomPaint(
              size: const Size(20, 20),
              painter: _GoogleGPainter(),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialProof() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar stack
            SizedBox(
              width: 60,
              height: 24,
              child: Stack(
                children: [
                  _avatar('https://i.pravatar.cc/40?img=1', 0),
                  _avatar('https://i.pravatar.cc/40?img=5', 16),
                  _avatar('https://i.pravatar.cc/40?img=12', 32),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified_rounded,
                color: Color(0xFF00D4AA), size: 14),
            const SizedBox(width: 4),
            Text(
              'Trusted by 2,000+ UTMians',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1B0F4A), width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppTheme.primaryLight),
          ),
        ),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────

  Future<void> _login() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      _toast('Enter your email and password.');
      return;
    }
    setState(() => _loading = true);
    final err = await context.read<AuthProvider>().login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      _toast(err);
    } else {
      Navigator.of(context).pushReplacementNamed('/profile');
    }
  }

  void _google() =>
      _toast('Google sign-in coming soon — use your UTM email for now.');

  void _forgot() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Password', style: AppTheme.headingLg),
        content: Text(
          "We'll send a reset link to your UTM email. Check your @utm.my inbox.",
          style: AppTheme.bodyMd,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it')),
        ],
      ),
    );
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
}

/// Brand-accurate Google "G" rendered with paint primitives so we don't
/// need to ship the asset.
class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    final stroke = r * 0.32;

    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final green = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final rect = Rect.fromCircle(center: c, radius: r - stroke / 2);
    // Blue: top-right arc
    canvas.drawArc(rect, -1.0, 1.4, false, blue);
    // Green: bottom-right
    canvas.drawArc(rect, 0.4, 1.5, false, green);
    // Yellow: bottom-left
    canvas.drawArc(rect, 1.9, 1.4, false, yellow);
    // Red: top-left
    canvas.drawArc(rect, 3.3, 1.6, false, red);

    // Horizontal bar (G)
    final bar = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(r - stroke * 0.1, r - stroke * 0.4,
          r - stroke * 0.2, stroke * 0.8),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleGPainter oldDelegate) => false;
}
