import 'package:equatable/equatable.dart';
import '../../data/models/reward_model.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRewards extends RewardsEvent {
  const LoadRewards();
}

class RedeemReward extends RewardsEvent {
  final String userId;
  final String rewardId;
  final RewardItemModel reward;
  final int userCurrentPoints;

  const RedeemReward({
    required this.userId,
    required this.rewardId,
    required this.reward,
    required this.userCurrentPoints,
  });

  @override
  List<Object?> get props => [userId, rewardId, reward, userCurrentPoints];
}

