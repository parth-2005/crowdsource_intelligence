import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../logic/feed/feed_bloc.dart';
import '../../logic/feed/feed_event.dart';
import '../../logic/feed/feed_state.dart';
import '../../data/models/card_model.dart';
import '../../logic/user/user_bloc.dart';
import '../../logic/user/user_event.dart';
import '../widgets/card_view_widget.dart';
import '../widgets/stats_overlay_widget.dart';
import '../widgets/feedback_pill.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  // Keep a local copy of the last loaded cards to render during transient states
  List<CardModel> _lastCards = const [];

  @override
  void initState() {
    super.initState();
    // Load initial feed
    context.read<FeedBloc>().add(const LoadFeed());
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // Trigger haptic feedback
    HapticFeedback.mediumImpact();

    final feedState = context.read<FeedBloc>().state;
    if (feedState is FeedLoaded && feedState.currentCards.isNotEmpty) {
      final swipedCard = feedState.currentCards[previousIndex];
      
      // Convert CardSwiper direction to our SwipeDirection
      final swipeDirection = direction == CardSwiperDirection.right
          ? SwipeDirection.right
          : SwipeDirection.left;

      // Add swipe event to BLoC
      context.read<FeedBloc>().add(
        SwipeCard(
          cardId: swipedCard.id,
          direction: swipeDirection,
        ),
      );

      // Calculate karma points
      int karmaPoints = AppConstants.baseKarmaPoints;
      if (swipedCard.rewardPoints != null) {
        karmaPoints = swipedCard.rewardPoints!;
      }

      // Add karma points to user
      context.read<UserBloc>().add(AddKarmaPoints(karmaPoints));

      // Return true to allow CardSwiper to remove the card immediately
      return true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<FeedBloc, FeedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.loadingText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          if (state is FeedError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeedBloc>().add(const LoadFeed());
                    },
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          }

          if (state is StatsReveal) {
            // FREEZE: Show stats overlay
            return StatsOverlayWidget(
              stats: state.stats,
              isMajority: state.isMajority,
              isGoldenTicket: state.isGoldenTicket,
              rewardPoints: state.rewardPoints,
              onNext: () {
                // Award points based on fairness result
                final pts = state.rewardPoints ?? 0;
                if (pts > 0) {
                  context.read<UserBloc>().add(AddKarmaPoints(pts));
                }
                // Resume feed to show next card
                context.read<FeedBloc>().add(const ResumeFeed());
              },
            );
          }

          if (state is FeedLoaded || state is SwipeFeedback) {
            final cards = state is FeedLoaded ? state.currentCards : (state as SwipeFeedback).currentCards;
            if (cards.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppConstants.noMoreCardsText,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Base card stack with optional feedback pill overlay
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: CardSwiper(
                          controller: _swiperController,
                          cardsCount: cards.length,
                          numberOfCardsDisplayed: math.min(3, cards.length),
                          backCardOffset: const Offset(0, 40),
                          padding: const EdgeInsets.all(0),
                          duration: AppConstants.cardSwipeDuration,
                          maxAngle: 30,
                          threshold: 80,
                          scale: 0.9,
                          isDisabled: false,
                          onSwipe: _onSwipe,
                          cardBuilder: (context, index, _, __) {
                            return CardViewWidget(card: cards[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (state is SwipeFeedback)
                    Positioned(
                      top: 24,
                      child: FeedbackPill(
                        text: state.feedback,
                        color: state.feedback.contains('Connected')
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                        isGold: false,
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
