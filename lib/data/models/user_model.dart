import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final int karmaPoints;
  final int trustScore;          // Range: 0-100. Default: 50.
  final String referralCode;     // Unique ID (e.g., "PARTH2024")
  final String? referredBy;      // ID of the referrer
  final bool hasRedeemedReferral;

  const UserModel({
    required this.id,
    required this.email,
    required this.karmaPoints,
    required this.trustScore,
    required this.referralCode,
    this.referredBy,
    required this.hasRedeemedReferral,
  });

  UserModel copyWith({
    String? id,
    String? email,
    int? karmaPoints,
    int? trustScore,
    String? referralCode,
    String? referredBy,
    bool? hasRedeemedReferral,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      karmaPoints: karmaPoints ?? this.karmaPoints,
      trustScore: trustScore ?? this.trustScore,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      hasRedeemedReferral: hasRedeemedReferral ?? this.hasRedeemedReferral,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      karmaPoints: json['karmaPoints'] as int? ?? 0,
      trustScore: json['trustScore'] as int? ?? 50,
      referralCode: json['referralCode'] as String,
      referredBy: json['referredBy'] as String?,
      hasRedeemedReferral: json['hasRedeemedReferral'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'karmaPoints': karmaPoints,
      'trustScore': trustScore,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'hasRedeemedReferral': hasRedeemedReferral,
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    karmaPoints,
    trustScore,
    referralCode,
    referredBy,
    hasRedeemedReferral,
  ];
}
