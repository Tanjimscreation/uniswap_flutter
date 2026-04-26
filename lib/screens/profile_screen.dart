import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Copy Address'),
                onTap: () => _copyAddress(),
              ),
              PopupMenuItem(
                child: const Text('View on Explorer'),
                onTap: () => _viewOnExplorer(),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text(
                  'Disconnect Wallet',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _disconnectWallet(),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          if (!walletProvider.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wallet, size: 64, color: Color(0xFF888888)),
                  const SizedBox(height: 16),
                  Text(
                    'No Wallet Connected',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Connect Wallet'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Wallet Header Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2D2D2D)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Connected Wallet',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                walletProvider.walletUsername ??
                                    walletProvider.getTruncatedAddress(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFFF007A).withOpacity(0.6),
                                  const Color(0xFFFF007A),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Network: ${walletProvider.selectedNetwork?.toUpperCase() ?? 'Ethereum'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Portfolio Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total Balance',
                          '\$12,456.78',
                          Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '24h Change',
                          '+2.45%',
                          Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Assets'),
                    Tab(text: 'NFTs'),
                    Tab(text: 'Activity'),
                  ],
                ),

                // Tab Content
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Assets Tab
                      _buildAssetsTab(context),
                      // NFTs Tab
                      _buildNFTsTab(context),
                      // Activity Tab
                      _buildActivityTab(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D2D2D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Icon(icon, size: 16, color: const Color(0xFFFF007A)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAssetItem(context, 'ETH', '2.5', '\$4,500'),
        _buildAssetItem(context, 'USDC', '3000', '\$3,000'),
        _buildAssetItem(context, 'UNI', '100', '\$1,245'),
        _buildAssetItem(context, 'DAI', '5000', '\$5,000'),
      ],
    );
  }

  Widget _buildAssetItem(BuildContext context, String symbol, String amount, String usdValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D2D2D)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(symbol, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text('$amount $symbol', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          Text(usdValue, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildNFTsTab(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2D2D2D)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 48, color: Color(0xFF888888)),
              const SizedBox(height: 8),
              Text(
                'NFT #${index + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityItem(context, 'Swapped', 'ETH → USDC', '2 hours ago', '\$5,000'),
        _buildActivityItem(context, 'Sent', 'USDC to 0x1234...', '1 day ago', '-\$1,000'),
        _buildActivityItem(context, 'Received', 'UNI from 0x5678...', '3 days ago', '+100 UNI'),
        _buildActivityItem(context, 'Added', 'Liquidity ETH/USDC', '1 week ago', '+\$10,000'),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String type,
    String description,
    String time,
    String amount,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D2D2D)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(time, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          Text(amount, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  void _copyAddress() {
    final walletProvider = context.read<WalletProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: ${walletProvider.getTruncatedAddress()}')),
    );
  }

  void _viewOnExplorer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Etherscan...')),
    );
  }

  void _disconnectWallet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Disconnect Wallet?'),
        content: const Text('Are you sure you want to disconnect your wallet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WalletProvider>().disconnectWallet();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text(
              'Disconnect',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
