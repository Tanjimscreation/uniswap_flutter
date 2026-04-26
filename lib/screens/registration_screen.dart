import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  late List<String> _seedPhrase;
  late List<String> _verificationPhrase;
  bool _phraseVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  late List<bool> _selectedWords;

  @override
  void initState() {
    super.initState();
    _generateSeedPhrase();
  }

  void _generateSeedPhrase() {
    // Mock seed phrase generation
    _seedPhrase = [
      'abandon', 'ability', 'able', 'about', 'above', 'absent',
      'absorb', 'abstract', 'abuse', 'access', 'accident', 'account'
    ];
    _selectedWords = List.filled(_seedPhrase.length, false);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Wallet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              Row(
                children: [
                  _buildStepIndicator(0, 'Generate'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 0
                          ? const Color(0xFFFF007A)
                          : const Color(0xFF2D2D2D),
                    ),
                  ),
                  _buildStepIndicator(1, 'Verify'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 1
                          ? const Color(0xFFFF007A)
                          : const Color(0xFF2D2D2D),
                    ),
                  ),
                  _buildStepIndicator(2, 'Username'),
                ],
              ),
              const SizedBox(height: 32),

              // Step 0: Display Seed Phrase
              if (_currentStep == 0) ...[
                Text(
                  'Your Recovery Phrase',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Save this phrase in a safe place. You\'ll need it to recover your wallet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    border: Border.all(color: const Color(0xFF2D2D2D)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() => _phraseVisible = true);
                    },
                    onExit: (_) {
                      setState(() => _phraseVisible = false);
                    },
                    child: Center(
                      child: _phraseVisible
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3,
                              ),
                              itemCount: _seedPhrase.length,
                              itemBuilder: (context, index) => Center(
                                child: Text(
                                  '${index + 1}. ${_seedPhrase[index]}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                const Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFF888888),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Hover to reveal phrase',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _copySeedPhrase,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _currentStep = 1);
                    },
                    child: const Text('I\'ve Saved My Phrase'),
                  ),
                ),
              ],

              // Step 1: Verify Seed Phrase
              if (_currentStep == 1) ...[
                Text(
                  'Verify Your Phrase',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Select the correct words to verify you saved your phrase.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                // Mock verification questions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVerificationQuestion('What was the 1st word?', 0),
                    const SizedBox(height: 16),
                    _buildVerificationQuestion('What was the 6th word?', 5),
                    const SizedBox(height: 16),
                    _buildVerificationQuestion('What was the 12th word?', 11),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _currentStep = 2);
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],

              // Step 2: Claim Username
              if (_currentStep == 2) ...[
                Text(
                  'Claim Your Username',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose a unique name for your wallet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., yourname',
                    suffix: Text(
                      '.uni.eth',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This will be your human-readable wallet address.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _completeRegistration,
                    child: const Text('Complete Setup'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF007A) : const Color(0xFF2D2D2D),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF888888),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFFFF007A) : const Color(0xFF888888),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationQuestion(String question, int wordIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _seedPhrase.asMap().entries.map((entry) {
            final idx = entry.key;
            final word = entry.value;
            return FilterChip(
              label: Text(word),
              selected: _selectedWords[idx],
              backgroundColor: const Color(0xFF1A1A1A),
              selectedColor: const Color(0xFFFF007A),
              onSelected: (selected) {
                setState(() {
                  _selectedWords[idx] = selected;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _copySeedPhrase() {
    // Mock copy functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seed phrase copied to clipboard')),
    );
  }

  void _completeRegistration() {
    final walletProvider = context.read<WalletProvider>();
    final mockAddress = '0x${List.generate(40, (i) => '0123456789abcdef'[i % 16]).join()}';

    walletProvider.connectWallet(
      mockAddress,
      username: _usernameController.text.isEmpty
          ? null
          : '${_usernameController.text}.uni.eth',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet created successfully!')),
    );

    Navigator.of(context).pushReplacementNamed('/profile');
  }
}
