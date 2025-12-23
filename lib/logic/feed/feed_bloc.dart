import 'dart:math';
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
  DateTime? _lastSwipeTime;
  int _swipeCount = 0;
  late int _nextSummaryThreshold;

  FeedBloc({required this.repository}) : super(const FeedLoading()) {
    on<LoadFeed>(_onLoadFeed);
    on<SwipeCard>(_onSwipeCard);
    on<ResumeFeed>(_onResumeFeed);
    
    // Initialize random summary threshold (8-12 swipes)
    _nextSummaryThreshold = 8 + Random().nextInt(5);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    
    try {
      _allCards = await repository.fetchCards();
      _swipeCount = 0;
      _nextSummaryThreshold = 8 + Random().nextInt(5);
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
      await repository.submitSwipe(event.cardId, event.direction == SwipeDirection.right);

      _swipeCount++;

      // Handle TRAP cards
      if (swipedCard.type == CardType.TRAP) {
        final isCorrect = swipedCard.correctTrapAnswer == (event.direction == SwipeDirection.left);
        emit(TrapDetected(
          isCorrect: isCorrect,
          card: swipedCard,
        ));
        return;
      }

      // Calculate if user is in majority
      final isYesSwipe = event.direction == SwipeDirection.right;
      final isMajority = (isYesSwipe && swipedCard.stats.yesPercent >= 50) ||
                         (!isYesSwipe && swipedCard.stats.yesPercent < 50);

      // Fair Points Algorithm (anti-spam)
      final now = DateTime.now();
      bool isSpam = false;
      if (_lastSwipeTime != null) {
        final diff = now.difference(_lastSwipeTime!);
        if (diff.inMilliseconds < 1200) {
          isSpam = true;
        }
      }
      _lastSwipeTime = now;

      // Determine reward points (0 if spam)
      final int? computedRewardPoints = isSpam ? 0 : swipedCard.rewardPoints;

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

      // Remove the swiped card immediately for non-freeze types
      final willFreeze = swipedCard.type == CardType.SUMMARY || isGoldenTicket;
      if (!willFreeze) {
        _allCards.removeWhere((card) => card.id == swipedCard.id);
      }

      // Check if we need to inject a summary card
      if (_swipeCount >= _nextSummaryThreshold) {
        // Create and inject a summary card at the top
        final summaryCard = CardModel(
          id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
          type: CardType.SUMMARY,
          question: 'You\'re 75% in sync with the community 🎯',
          imageUrl: 'https://via.placeholder.com/400x600?text=Vibe+Check',
          stats: const StatsData(
            yesPercent: 75,
            totalVotes: 0,
          ),
          summaryTitle: 'Vibe Check',
          summaryScore: 75,
        );

        // Insert at the beginning of the stack
        _allCards.insert(0, summaryCard);

        // Reset counters
        _swipeCount = 0;
        _nextSummaryThreshold = 8 + Random().nextInt(5);
      }

      // For BINARY, SURVEY, SPONSORED: Show quick feedback then continue
      // For SUMMARY, GOLDEN_TICKET: Freeze and show stats
      if (swipedCard.type == CardType.SUMMARY || isGoldenTicket) {
        emit(StatsReveal(
          stats: statsModel,
          isMajority: isMajority,
          isGoldenTicket: isGoldenTicket,
          rewardPoints: computedRewardPoints,
        ));
      } else {
        // Continuous flow: emit feedback pill and resume
        emit(SwipeFeedback(
          feedback: isMajority ? 'Connected! +${computedRewardPoints ?? 0}' : 'Unique! +${computedRewardPoints ?? 0}',
          rewardPoints: computedRewardPoints,
          currentCards: List<CardModel>.from(_allCards),
        ));
      }
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
