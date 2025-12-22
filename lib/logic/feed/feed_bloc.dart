import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/card_model.dart';
import '../../data/models/stats_model.dart';
import '../../data/repositories/i_card_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final ICardRepository repository;
  List<CardModel> _allCards = [];
  CardModel? _lastSwipedCard;

  FeedBloc({required this.repository}) : super(const FeedLoading()) {
    on<LoadFeed>(_onLoadFeed);
    on<SwipeCard>(_onSwipeCard);
    on<ResumeFeed>(_onResumeFeed);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    
    try {
      _allCards = await repository.fetchCards();
      emit(FeedLoaded(currentCards: _allCards));
    } catch (e) {
      emit(FeedError(message: 'Failed to load cards: ${e.toString()}'));
    }
  }

  Future<void> _onSwipeCard(SwipeCard event, Emitter<FeedState> emit) async {
    try {
      // Find the swiped card
      final swipedCard = _allCards.firstWhere((card) => card.id == event.cardId);
      _lastSwipedCard = swipedCard;

      // Submit the swipe to repository
      await repository.submitSwipe(
        event.cardId,
        event.direction == SwipeDirection.right,
      );

      // Calculate if user is in majority
      final isYesSwipe = event.direction == SwipeDirection.right;
      final isMajority = (isYesSwipe && swipedCard.stats.yesPercent >= 50) ||
                         (!isYesSwipe && swipedCard.stats.yesPercent < 50);

      // Create stats model
      final statsModel = StatsModel(
        yesPercent: swipedCard.stats.yesPercent,
        noPercent: 100 - swipedCard.stats.yesPercent,
        totalVotes: swipedCard.stats.totalVotes,
        isMajority: isMajority,
        cardId: swipedCard.id,
      );

      // Check if it's a golden ticket
      final isGoldenTicket = swipedCard.type == CardType.GOLDEN_TICKET;

      // Emit stats reveal state - FREEZE the UI here
      emit(StatsReveal(
        stats: statsModel,
        isMajority: isMajority,
        isGoldenTicket: isGoldenTicket,
        rewardPoints: swipedCard.rewardPoints,
      ));
    } catch (e) {
      emit(FeedError(message: 'Failed to process swipe: ${e.toString()}'));
    }
  }

  Future<void> _onResumeFeed(ResumeFeed event, Emitter<FeedState> emit) async {
    // Remove the last swiped card from the stack
    if (_lastSwipedCard != null) {
      _allCards.removeWhere((card) => card.id == _lastSwipedCard!.id);
      _lastSwipedCard = null;
    }

    // Check if there are more cards
    if (_allCards.isEmpty) {
      emit(const FeedError(message: 'No more cards available!'));
    } else {
      // Emit the updated card stack
      emit(FeedLoaded(currentCards: _allCards));
    }
  }
}
