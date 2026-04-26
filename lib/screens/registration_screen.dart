import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_shell.dart';

class _Faculty {
  final String code;
  final String name;
  final IconData icon;
  final Color color;
  const _Faculty(this.code, this.name, this.icon, this.color);
  String get full => '$code — $name';
}

const _faculties = <_Faculty>[
  _Faculty('FC', 'Computing', Icons.code_rounded, Color(0xFF6C3CE1)),
  _Faculty('FKM', 'Mechanical Engineering', Icons.precision_manufacturing_rounded, Color(0xFFEF4444)),
  _Faculty('FKE', 'Electrical Engineering', Icons.bolt_rounded, Color(0xFFF59E0B)),
  _Faculty('FKA', 'Civil Engineering', Icons.foundation_rounded, Color(0xFF22C55E)),
  _Faculty('FES', 'Engineering Sciences', Icons.science_rounded, Color(0xFF3B82F6)),
  _Faculty('FABU', 'Built Environment', Icons.architecture_rounded, Color(0xFFEC4899)),
  _Faculty('FS', 'Science', Icons.biotech_rounded, Color(0xFF14B8A6)),
  _Faculty('AHIBS', 'Business', Icons.trending_up_rounded, Color(0xFF8B5CF6)),
];

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _step = 0;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  _Faculty? _faculty;
  String? _campus;
  bool _terms = false;
  bool _obscure = true;
  bool? _emailValid;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top bar ──
            Row(
              children: [
                _topIcon(Icons.arrow_back_rounded, () {
                  if (_step > 0) {
                    setState(() => _step--);
                  } else {
                    Navigator.pop(context);
                  }
                }),
                const Spacer(),
                Text(
                  'Step ${_step + 1} of 2',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 20),

            // ── Stepper ──
            _stepper(),
            const SizedBox(height: 28),

            // ── Body ──
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (c, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(a),
                    child: c,
                  ),
                ),
                child: _step == 0
                    ? _step1(key: const ValueKey(0))
                    : _step2(key: const ValueKey(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stepper ─────────────────────────────────────────────
  Widget _stepper() {
    return Row(
      children: [
        _stepDot(0, 'UTM Gate', Icons.shield_rounded),
        Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 350),
              alignment: Alignment.centerLeft,
              widthFactor: _step >= 1 ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF8B6CEF)],
                  ),
                ),
              ),
            ),
          ),
        ),
        _stepDot(1, 'Identity', Icons.person_rounded),
      ],
    );
  }

  Widget _stepDot(int idx, String label, IconData icon) {
    final active = _step >= idx;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active
                ? const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF8B6CEF)],
                  )
                : null,
            color: active ? null : Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: active
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D4AA).withValues(alpha: 0.4),
                      blurRadius: 16,
                    )
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: active ? 1 : 0.4),
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: active ? 1 : 0.5),
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _topIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ── Step 1 ──────────────────────────────────────────────
  Widget _step1({Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Colors.white, Color(0xFF00D4AA)],
            ).createShader(b),
            child: Text(
              'The UTM Gate',
              style: AppTheme.displayLg.copyWith(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verify your scholarly status with your UTM email.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassField(
                  controller: _emailCtrl,
                  label: 'UTM Email',
                  hint: 'name@utm.my  ·  name@graduate.utm.my',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  success: _emailValid,
                  errorText: (_emailValid == false &&
                          _emailCtrl.text.isNotEmpty)
                      ? 'Must end in @utm.my or @graduate.utm.my'
                      : null,
                  onChanged: (v) {
                    setState(() {
                      _emailValid = v.isEmpty
                          ? null
                          : context.read<AuthProvider>().isValidUTMEmail(v);
                    });
                  },
                ),
                const SizedBox(height: 16),
                GlassField(
                  controller: _passCtrl,
                  label: 'Password',
                  hint: 'At least 6 characters',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const SizedBox(height: 22),
                _continueButton(_next),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _signInLink(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _next() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return _toast('Enter your UTM email.');
    if (!context.read<AuthProvider>().isValidUTMEmail(email)) {
      return _toast('Use @utm.my or @graduate.utm.my only.');
    }
    if (_passCtrl.text.length < 6) {
      return _toast('Password must be at least 6 characters.');
    }
    setState(() => _step = 1);
  }

  // ── Step 2 ──────────────────────────────────────────────
  Widget _step2({Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tell us about you',
            style: AppTheme.displayLg.copyWith(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "So fellow UTMians know who they're swapping with.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // Name + phone
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GlassField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'e.g. Siti Aisyah',
                  icon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                GlassField(
                  controller: _phoneCtrl,
                  label: 'Phone (optional)',
                  hint: '+60',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Faculty picker
          _sectionLabel('Choose your faculty'),
          const SizedBox(height: 12),
          _facultyGrid(),
          const SizedBox(height: 22),

          // Campus picker
          _sectionLabel('Which campus?'),
          const SizedBox(height: 12),
          _campusPicker(),
          const SizedBox(height: 22),

          // T&C
          _termsBox(),
          const SizedBox(height: 24),

          // Action row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _step = 0),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.25)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.r16),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _continueButton(_register, label: 'Create Account'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _facultyGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _faculties.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (_, i) {
        final f = _faculties[i];
        final selected = _faculty == f;
        return GestureDetector(
          onTap: () => setState(() => _faculty = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected
                  ? f.color.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? f.color
                    : Colors.white.withValues(alpha: 0.12),
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: f.color.withValues(alpha: 0.4),
                        blurRadius: 12,
                      )
                    ]
                  : null,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: f.color.withValues(alpha: selected ? 1 : 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(f.icon, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  f.code,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: selected ? 1 : 0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _campusPicker() {
    Widget option(String code, String label, String sub, String img) {
      final selected = _campus == code;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _campus = code),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? const Color(0xFF00D4AA)
                    : Colors.white.withValues(alpha: 0.15),
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00D4AA).withValues(alpha: 0.4),
                        blurRadius: 16,
                      )
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(img,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.primaryDark,
                              ],
                            ),
                          ),
                        )),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        sub,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF00D4AA),
                      child: Icon(Icons.check_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        option(
          'Skudai',
          'UTM Skudai',
          'Johor Bahru',
          'https://images.unsplash.com/photo-1607237138185-eedd9c632b0b?w=600&h=400&fit=crop',
        ),
        const SizedBox(width: 12),
        option(
          'KL',
          'UTM KL',
          'Kuala Lumpur',
          'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=600&h=400&fit=crop',
        ),
      ],
    );
  }

  Widget _termsBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith(
                  (s) => s.contains(WidgetState.selected)
                      ? const Color(0xFF00D4AA)
                      : Colors.transparent,
                ),
                side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.5), width: 1.5),
              ),
            ),
            child: Checkbox(
              value: _terms,
              onChanged: (v) => setState(() => _terms = v ?? false),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _terms = !_terms),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                  children: const [
                    TextSpan(text: "I agree to UniSwap's "),
                    TextSpan(
                      text: 'Campus Safety & Fair Trade',
                      style: TextStyle(
                        color: Color(0xFF00D4AA),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' policy — meet only on campus, list honest condition, no scams.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Buttons & helpers ────────────────────────────────────
  Widget _continueButton(VoidCallback onTap, {String label = 'Continue'}) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: const Color(0xFF0A2540),
          elevation: 8,
          shadowColor: const Color(0xFF00D4AA).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.r16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _signInLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already a UTMian? ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF00D4AA),
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    final err = await context.read<AuthProvider>().register(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          fullName: _nameCtrl.text.trim(),
          faculty: _faculty?.full ?? '',
          campus: _campus ?? '',
          phoneNumber: _phoneCtrl.text.trim().isEmpty
              ? null
              : _phoneCtrl.text.trim(),
          acceptedTerms: _terms,
        );
    if (!mounted) return;
    if (err != null) return _toast(err);
    _toast('✓ Welcome to UniSwap, Scholar!');
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/profile');
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
}
