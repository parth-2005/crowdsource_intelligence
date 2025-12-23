import 'package:equatable/equatable.dart';
import '../../data/models/reward_model.dart';

abstract class RewardsState extends Equatable {
  const RewardsState();

  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsState {
  const RewardsInitial();
}

class RewardsLoading extends RewardsState {
  const RewardsLoading();
}

class RewardsLoaded extends RewardsState {
  final List<RewardItemModel> rewards;

  const RewardsLoaded(this.rewards);

  @override
  List<Object?> get props => [rewards];
}

class RedemptionChecking extends RewardsState {
  const RedemptionChecking();
}

class InsufficientPoints extends RewardsState {
  final int pointsNeeded;
  final int pointsAvailable;

  const InsufficientPoints({
    required this.pointsNeeded,
    required this.pointsAvailable,
  });

  @override
  List<Object?> get props => [pointsNeeded, pointsAvailable];
}

class RedemptionSuccess extends RewardsState {
  final RewardItemModel reward;
  final int pointsDeducted;

  const RedemptionSuccess({
    required this.reward,
    required this.pointsDeducted,
  });

  @override
  List<Object?> get props => [reward, pointsDeducted];
}

class RewardsError extends RewardsState {
  final String message;

  const RewardsError(this.message);

  @override
  List<Object?> get props => [message];
}
