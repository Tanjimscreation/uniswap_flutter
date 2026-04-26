class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String faculty;
  final String campus;
  final String? phoneNumber;
  final String? avatarUrl;
  final double trustScore;
  final int successfulSwaps;
  final int totalListings;
  final bool verified;
  final DateTime memberSince;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.faculty,
    required this.campus,
    this.phoneNumber,
    this.avatarUrl,
    this.trustScore = 5.0,
    this.successfulSwaps = 0,
    this.totalListings = 0,
    this.verified = true,
    required this.memberSince,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return fullName.isNotEmpty ? fullName[0] : '?';
  }

  String get campusLabel =>
      campus == 'KL' ? 'UTM Kuala Lumpur' : 'UTM Skudai';

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
    String? faculty,
    String? campus,
    String? phoneNumber,
    String? avatarUrl,
    double? trustScore,
    int? successfulSwaps,
    int? totalListings,
    bool? verified,
    DateTime? memberSince,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      faculty: faculty ?? this.faculty,
      campus: campus ?? this.campus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      trustScore: trustScore ?? this.trustScore,
      successfulSwaps: successfulSwaps ?? this.successfulSwaps,
      totalListings: totalListings ?? this.totalListings,
      verified: verified ?? this.verified,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}
