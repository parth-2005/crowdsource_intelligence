import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/i_rewards_repository.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final IRewardsRepository repository;

  RewardsBloc({required this.repository}) : super(const RewardsInitial()) {
    on<LoadRewards>(_onLoadRewards);
    on<RedeemReward>(_onRedeemReward);
  }

  Future<void> _onLoadRewards(
    LoadRewards event,
    Emitter<RewardsState> emit,
  ) async {
    try {
      emit(const RewardsLoading());
      final rewards = await repository.fetchRewards();
      emit(RewardsLoaded(rewards));
    } catch (e) {
      emit(RewardsError('Failed to load rewards: $e'));
    }
  }

  Future<void> _onRedeemReward(
    RedeemReward event,
    Emitter<RewardsState> emit,
  ) async {
    try {
      emit(const RedemptionChecking());
      
      // Validate points
      if (event.userCurrentPoints < event.reward.cost) {
        final pointsNeeded = event.reward.cost - event.userCurrentPoints;
        emit(InsufficientPoints(
          pointsNeeded: pointsNeeded,
          pointsAvailable: event.userCurrentPoints,
        ));
        return;
      }

      // Process redemption
      await repository.redeemReward(
        event.userId,
        event.rewardId,
      );

      emit(RedemptionSuccess(
        reward: event.reward,
        pointsDeducted: event.reward.cost,
      ));
    } catch (e) {
      emit(RewardsError('Redemption failed: $e'));
    }
  }
}
