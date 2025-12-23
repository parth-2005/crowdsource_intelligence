import 'package:equatable/equatable.dart';
import '../../data/models/card_model.dart';
import '../../data/models/stats_model.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<CardModel> currentCards;

  const FeedLoaded({
    required this.currentCards,
  });

  @override
  List<Object?> get props => [currentCards];
}

class SwipeFeedback extends FeedState {
  final String feedback;
  final int? rewardPoints;
  final List<CardModel> currentCards;

  const SwipeFeedback({
    required this.feedback,
    this.rewardPoints,
    required this.currentCards,
  });

  @override
  List<Object?> get props => [feedback, rewardPoints, currentCards];
}

class TrapDetected extends FeedState {
  final bool isCorrect;
  final CardModel card;

  const TrapDetected({
    required this.isCorrect,
    required this.card,
  });

  @override
  List<Object?> get props => [isCorrect, card];
}

class StatsReveal extends FeedState {
  final StatsModel stats;
  final bool isMajority;
  final bool isGoldenTicket;
  final int? rewardPoints;

  const StatsReveal({
    required this.stats,
    required this.isMajority,
    this.isGoldenTicket = false,
    this.rewardPoints,
  });

  @override
  List<Object?> get props => [stats, isMajority, isGoldenTicket, rewardPoints];
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object?> get props => [message];
}