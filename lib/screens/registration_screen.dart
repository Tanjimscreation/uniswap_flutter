import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

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
  String? _faculty;
  String? _campus;
  bool _terms = false;
  bool _obscure = true;

  static const _faculties = [
    'FKM — Mechanical Engineering',
    'FKE — Electrical Engineering',
    'FKA — Civil Engineering',
    'FES — Engineering Sciences',
    'FABU — Built Environment & Surveying',
    'FC — Computing',
    'FS — Science',
    'AHIBS — Business School',
  ];
  static const _campuses = ['Skudai', 'KL'];

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Top gradient strip
          Container(
            height: size.height * 0.22,
            decoration: const BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_step > 0) {
                          setState(() => _step--);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Text('Join UniSwap',
                        style: AppTheme.headingLg
                            .copyWith(color: Colors.white)),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // Card body
          Positioned.fill(
            top: size.height * 0.16,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.r24),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepper(),
                    const SizedBox(height: 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _step == 0
                          ? _buildStep1(key: const ValueKey(0))
                          : _buildStep2(key: const ValueKey(1)),
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

  // ── Stepper ──
  Widget _buildStepper() {
    return Row(
      children: [
        _stepDot(0, 'Credentials'),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: _step >= 1 ? AppTheme.primary : AppTheme.border,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        _stepDot(1, 'Faculty & Campus'),
      ],
    );
  }

  Widget _stepDot(int idx, String label) {
    final active = _step >= idx;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active ? AppTheme.primaryGradient : null,
            color: active ? null : AppTheme.bgLight,
            border: active
                ? null
                : Border.all(color: AppTheme.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: active
              ? Text('${idx + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14))
              : Text('${idx + 1}',
                  style: TextStyle(
                      color: AppTheme.textHint,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: AppTheme.bodySm.copyWith(
              color: active ? AppTheme.primary : AppTheme.textHint,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            )),
      ],
    );
  }

  // ── Step 1 ──
  Widget _buildStep1({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('The UTM Gate', style: AppTheme.displaySm),
        const SizedBox(height: 6),
        Text('Verify your scholarly status with your UTM email.',
            style: AppTheme.bodyMd),
        const SizedBox(height: 24),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'UTM Email',
            hintText: 'name@utm.my  ·  name@graduate.utm.my',
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _passCtrl,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'At least 6 characters',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppTheme.textHint,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _next,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continue',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? ', style: AppTheme.bodyMd),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/login'),
              child: Text('Sign In',
                  style:
                      AppTheme.labelLg.copyWith(color: AppTheme.primary)),
            ),
          ],
        ),
      ],
    );
  }

  void _next() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return _toast('Enter your UTM email.');
    if (!context.read<AuthProvider>().isValidUTMEmail(email)) {
      return _toast(
          'UniSwap is for UTM students only.\nUse @utm.my or @graduate.utm.my.');
    }
    if (_passCtrl.text.length < 6) {
      return _toast('Password must be at least 6 characters.');
    }
    setState(() => _step = 1);
  }

  // ── Step 2 ──
  Widget _buildStep2({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tell us about you', style: AppTheme.displaySm),
        const SizedBox(height: 6),
        Text('So fellow UTMians know who they\'re swapping with.',
            style: AppTheme.bodyMd),
        const SizedBox(height: 24),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'e.g. Siti Aisyah',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone (optional)',
            hintText: '+60',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _faculty,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Faculty',
            prefixIcon: Icon(Icons.school_outlined),
          ),
          items: _faculties
              .map((f) => DropdownMenuItem(
                  value: f,
                  child:
                      Text(f, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (v) => setState(() => _faculty = v),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _campus,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Campus',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          items: _campuses
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c == 'KL'
                      ? 'UTM Kuala Lumpur'
                      : 'UTM Skudai (Johor Bahru)')))
              .toList(),
          onChanged: (v) => setState(() => _campus = v),
        ),
        const SizedBox(height: 20),

        // T&C
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.r16),
            border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _terms,
                onChanged: (v) =>
                    setState(() => _terms = v ?? false),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _terms = !_terms),
                  child: RichText(
                    text: TextSpan(
                      style: AppTheme.bodySm.copyWith(
                          color: AppTheme.textPrimary, height: 1.5),
                      children: const [
                        TextSpan(text: 'I agree to UniSwap\'s '),
                        TextSpan(
                          text: 'Campus Safety & Fair Trade',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
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
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: () => setState(() => _step = 0),
                  child: const Text('Back'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text('Create Account',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _register() async {
    final err = await context.read<AuthProvider>().register(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          fullName: _nameCtrl.text.trim(),
          faculty: _faculty ?? '',
          campus: _campus ?? '',
          phoneNumber: _phoneCtrl.text.trim().isEmpty
              ? null
              : _phoneCtrl.text.trim(),
          acceptedTerms: _terms,
        );
    if (!mounted) return;
    if (err != null) return _toast(err);
    _toast('✓ Welcome to UniSwap, Scholar!');
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/profile');
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(m)));
}
