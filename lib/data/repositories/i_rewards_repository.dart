import '../models/reward_model.dart';

abstract class IRewardsRepository {
  Future<List<RewardItemModel>> fetchRewards();
  Future<RewardItemModel> getRewardById(String rewardId);
  Future<void> redeemReward(String userId, String rewardId);
  Future<List<RedemptionModel>> getUserRedemptions(String userId);
}
