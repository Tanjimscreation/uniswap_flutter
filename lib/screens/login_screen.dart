import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_button.dart';
import '../widgets/network_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedNetwork = 'ethereum';
  bool _showQrCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Wallet'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Network Selection
              Text(
                'Select Network',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              NetworkSelector(
                selectedNetwork: _selectedNetwork,
                onNetworkChanged: (network) {
                  setState(() {
                    _selectedNetwork = network;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Wallet Providers
              Text(
                'Connect Your Wallet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              WalletButton(
                label: 'MetaMask',
                icon: '🦊',
                onPressed: () => _connectWallet('MetaMask'),
              ),
              const SizedBox(height: 12),
              
              WalletButton(
                label: 'Coinbase Wallet',
                icon: '💙',
                onPressed: () => _connectWallet('Coinbase'),
              ),
              const SizedBox(height: 12),
              
              WalletButton(
                label: 'WalletConnect',
                icon: '📱',
                onPressed: () => _showQrCodeDialog(),
              ),
              const SizedBox(height: 12),
              
              WalletButton(
                label: 'Uniswap Extension',
                icon: '🔌',
                onPressed: () => _connectWallet('Uniswap'),
              ),
              const SizedBox(height: 32),

              // Create New Wallet Option
              Center(
                child: Column(
                  children: [
                    Text(
                      'Don\'t have a wallet?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/registration');
                      },
                      child: const Text('Create New Wallet'),
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

  void _connectWallet(String provider) {
    // Mock wallet connection
    final mockAddress = '0x${List.generate(40, (i) => '0123456789abcdef'[i % 16]).join()}';
    
    context.read<WalletProvider>().connectWallet(
      mockAddress,
      network: _selectedNetwork,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to $provider')),
    );

    Navigator.of(context).pushReplacementNamed('/profile');
  }

  void _showQrCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Scan with WalletConnect'),
        content: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('QR Code Placeholder'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
