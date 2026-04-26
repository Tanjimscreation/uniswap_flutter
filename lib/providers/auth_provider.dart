import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/product.dart';

class AuthProvider extends ChangeNotifier {
  static const _kLoggedIn = 'utm_logged_in';

  static final AppUser _demo = AppUser(
    id: 'utm-001',
    fullName: 'Siti Aisyah',
    email: 'siti.aisyah@graduate.utm.my',
    faculty: 'FC — Faculty of Computing',
    campus: 'Skudai',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop&crop=face',
    trustScore: 4.9,
    successfulSwaps: 27,
    totalListings: 6,
    verified: true,
    memberSince: DateTime(2024, 9, 1),
  );

  AppUser? _user = _demo;
  bool _isLoggedIn = true;
  final List<Product> _listings = List<Product>.from(mockProducts);

  // ── Getters ──
  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  List<Product> get listings => List.unmodifiable(_listings);

  String? get email => _user?.email;
  String? get fullName => _user?.fullName;
  String? get faculty => _user?.faculty;
  String? get campus => _user?.campus;
  String get location => _user?.campusLabel ?? 'UTM Skudai';
  String get trustScore => (_user?.trustScore ?? 5.0).toStringAsFixed(1);
  int get successfulSwaps => _user?.successfulSwaps ?? 0;

  // ── Validation ──
  static final RegExp _utmEmail =
      RegExp(r'^[a-zA-Z0-9._%+-]+@(graduate\.utm\.my|utm\.my)$');

  bool isValidUTMEmail(String email) =>
      _utmEmail.hasMatch(email.trim().toLowerCase());

  // ── Auth ──
  Future<String?> register({
    required String email,
    required String fullName,
    required String password,
    required String faculty,
    required String campus,
    String? phoneNumber,
    required bool acceptedTerms,
  }) async {
    if (!isValidUTMEmail(email)) {
      return 'UniSwap is exclusive to UTM students.\nUse your @utm.my or @graduate.utm.my email.';
    }
    if (fullName.trim().isEmpty) return 'Please enter your full name.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    if (faculty.isEmpty) return 'Please select your faculty.';
    if (campus.isEmpty) return 'Please select your campus.';
    if (!acceptedTerms) return 'Please accept the Campus Safety & Fair Trade terms.';

    _user = AppUser(
      id: 'utm-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      faculty: faculty,
      campus: campus,
      phoneNumber: phoneNumber,
      trustScore: 5.0,
      successfulSwaps: 0,
      totalListings: 0,
      memberSince: DateTime.now(),
    );
    _isLoggedIn = true;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<String?> login({required String email, required String password}) async {
    if (!isValidUTMEmail(email)) return 'Please use a valid UTM email.';
    if (password.isEmpty) return 'Password is required.';

    _user = _demo.copyWith(email: email.trim().toLowerCase());
    _isLoggedIn = true;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedIn);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, _isLoggedIn);
  }

  void addListing(Product p) {
    _listings.insert(0, p);
    notifyListeners();
  }
}
