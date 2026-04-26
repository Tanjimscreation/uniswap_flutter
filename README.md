# Uniswap Flutter - Sprint One

A decentralized application (dApp) for Uniswap trading built with Flutter.

## Sprint One - Feature Overview

Sprint One focuses on the core authentication and user profile system for Web3 wallet connectivity:

### ✅ Features Implemented

1. **Login (Connect Wallet Flow)**
   - Multiple wallet provider buttons (MetaMask, Coinbase, WalletConnect, Uniswap)
   - Network selection (Ethereum, Polygon, Arbitrum, Base)
   - QR code modal for WalletConnect
   - Mock wallet connection

2. **Registration (New User Wallet Creation)**
   - Step-by-step wizard (3 steps):
     - **Step 1:** Seed phrase generation with hidden/reveal view
     - **Step 2:** Phrase verification with word selection
     - **Step 3:** Username claiming (`.uni.eth` format)

3. **User Profile (Portfolio Dashboard)**
   - Wallet identity display (address or `.eth` username)
   - Portfolio stats (total balance, 24h change)
   - **Assets Tab:** Token holdings with USD values
   - **NFTs Tab:** Digital collectibles gallery
   - **Activity Tab:** Transaction history
   - Wallet menu with disconnect option

4. **Logout (Disconnect Action)**
   - Wallet menu dropdown
   - Copy address functionality
   - View on Explorer link
   - Disconnect wallet confirmation

### 🎨 Design System

- **Dark Mode:** Default dark theme (#0D0D0D background)
- **Primary Color:** Pink (#FF007A)
- **Cards:** Glassmorphism style with rounded borders
- **Font:** Roboto with Material Design 3

## Project Structure

```
lib/
├── main.dart              # App entry point
├── theme/
│   └── app_theme.dart     # Dark theme configuration
├── providers/
│   └── wallet_provider.dart    # Wallet state management
├── screens/
│   ├── splash_screen.dart      # Splash/loading screen
│   ├── login_screen.dart       # Connect wallet screen
│   ├── registration_screen.dart # Create wallet screen
│   └── profile_screen.dart     # Portfolio dashboard
└── widgets/
    ├── wallet_button.dart      # Wallet provider button
    └── network_selector.dart   # Network selection widget
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/uniswap_flutter.git
cd uniswap_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- **flutter:** SDK for UI development
- **provider:** State management
- **web3dart:** Blockchain interaction
- **walletconnect_flutter_v2:** WalletConnect integration
- **qr_flutter:** QR code generation
- **bip39:** Seed phrase generation
- **dio:** HTTP networking
- **shared_preferences:** Local storage
- **google_fonts:** Custom typography

## API Integration (Mock for Sprint One)

- **Wallet Connection:** Currently uses mock addresses
- **Balance Fetching:** Mock data from Alchemy/Infura APIs (coming in Sprint Two)
- **Transaction History:** Mock transaction data
- **NFT Gallery:** Placeholder implementation

## Next Steps (Sprint Two)

- [ ] Real wallet connection via MetaMask and WalletConnect
- [ ] Integration with Alchemy/Infura APIs for balance and transaction data
- [ ] NFT metadata fetching from OpenSea/NFT APIs
- [ ] Real transaction signing and submission
- [ ] QR code implementation with camera plugin
- [ ] Enhanced error handling and user feedback
- [ ] Unit and integration tests

## Contributing

Follow these guidelines:
1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Create a pull request

## License

MIT License

## Support

For issues or questions, please open an issue on GitHub.
