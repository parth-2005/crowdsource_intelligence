import 'package:equatable/equatable.dart';

class RewardItemModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final int cost; // Points cost
  final String? imageUrl;
  final String category; // e.g., 'gift_card', 'voucher', 'physical'

  const RewardItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    this.imageUrl,
    required this.category,
  });

  factory RewardItemModel.fromJson(Map<String, dynamic> json) {
    return RewardItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cost: json['cost'] as int,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cost': cost,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [id, title, description, cost, imageUrl, category];
}

class RedemptionModel extends Equatable {
  final String id;
  final String userId;
  final String rewardId;
  final DateTime redeemedAt;
  final String status; // 'pending', 'shipped', 'delivered'

  const RedemptionModel({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.redeemedAt,
    required this.status,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      rewardId: json['rewardId'] as String,
      redeemedAt: DateTime.parse(json['redeemedAt'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'rewardId': rewardId,
      'redeemedAt': redeemedAt.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, userId, rewardId, redeemedAt, status];
}
