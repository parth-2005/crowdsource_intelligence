import '../models/reward_model.dart';
import 'i_rewards_repository.dart';

class MockRewardsRepository implements IRewardsRepository {
  @override
  Future<List<RewardItemModel>> fetchRewards() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      const RewardItemModel(
        id: 'r1',
        title: 'Amazon Gift Card \$50',
        description: 'Digital gift card for Amazon purchases',
        cost: 500,
        category: 'gift_card',
        imageUrl: 'https://picsum.photos/200/200?random=r1',
      ),
      const RewardItemModel(
        id: 'r2',
        title: 'Starbucks Voucher \$25',
        description: 'Enjoy your favorite coffee on us',
        cost: 300,
        category: 'voucher',
        imageUrl: 'https://picsum.photos/200/200?random=r2',
      ),
      const RewardItemModel(
        id: 'r3',
        title: 'Movie Ticket Voucher',
        description: 'One free cinema ticket',
        cost: 350,
        category: 'voucher',
        imageUrl: 'https://picsum.photos/200/200?random=r3',
      ),
      const RewardItemModel(
        id: 'r4',
        title: 'Gym Day Pass',
        description: '1 day unlimited access to premium gym',
        cost: 250,
        category: 'service',
        imageUrl: 'https://picsum.photos/200/200?random=r4',
      ),
      const RewardItemModel(
        id: 'r5',
        title: 'Apple AirPods Pro',
        description: 'Premium wireless earbuds',
        cost: 1200,
        category: 'physical',
        imageUrl: 'https://picsum.photos/200/200?random=r5',
      ),
      const RewardItemModel(
        id: 'r6',
        title: 'Netflix 3-Month Pass',
        description: '3 months of unlimited streaming',
        cost: 450,
        category: 'subscription',
        imageUrl: 'https://picsum.photos/200/200?random=r6',
      ),
    ];
  }

  @override
  Future<RewardItemModel> getRewardById(String rewardId) async {
    final rewards = await fetchRewards();
    return rewards.firstWhere((r) => r.id == rewardId);
  }

  @override
  Future<void> redeemReward(String userId, String rewardId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, deduct points and create redemption
  }

  @override
  Future<List<RedemptionModel>> getUserRedemptions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}
