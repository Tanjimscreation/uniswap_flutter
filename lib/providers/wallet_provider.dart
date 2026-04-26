import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  String? _walletAddress;
  String? _walletUsername;
  String? _selectedNetwork;
  bool _isConnected = false;

  String? get walletAddress => _walletAddress;
  String? get walletUsername => _walletUsername;
  String? get selectedNetwork => _selectedNetwork;
  bool get isConnected => _isConnected;

  Future<void> connectWallet(String address, {String? username, String network = 'ethereum'}) async {
    _walletAddress = address;
    _walletUsername = username;
    _selectedNetwork = network;
    _isConnected = true;
    notifyListeners();
  }

  Future<void> disconnectWallet() async {
    _walletAddress = null;
    _walletUsername = null;
    _selectedNetwork = null;
    _isConnected = false;
    notifyListeners();
  }

  void updateNetwork(String network) {
    _selectedNetwork = network;
    notifyListeners();
  }

  String getTruncatedAddress() {
    if (_walletAddress == null) return '';
    return '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}';
  }
}
