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
  
  // Local state for the "Toast" pill
  bool _showPill = false;
  String _pillText = '';
  Color _pillColor = Colors.white;

  @override
  void initState() {
    super.initState();
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
    HapticFeedback.lightImpact(); // Light impact for speed

    final feedState = context.read<FeedBloc>().state;
    // Handle SwipeFeedback state too, as it contains the list now
    List<CardModel> currentList = [];
    
    if (feedState is FeedLoaded) currentList = feedState.currentCards;
    else if (feedState is SwipeFeedback) currentList = feedState.currentCards;

    if (currentList.isNotEmpty) {
      final swipedCard = currentList[previousIndex];
      
      final swipeDirection = direction == CardSwiperDirection.right
          ? SwipeDirection.right
          : SwipeDirection.left;

      context.read<FeedBloc>().add(
        SwipeCard(
          cardId: swipedCard.id,
          direction: swipeDirection,
        ),
      );

      // Optimistic UI update for karma (makes it feel faster)
      int karmaPoints = swipedCard.rewardPoints ?? AppConstants.baseKarmaPoints;
      context.read<UserBloc>().add(AddKarmaPoints(karmaPoints));

      return true; // Card flies away immediately (Continuous Flow)
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<FeedBloc, FeedState>(
        listener: (context, state) {
          // 1. Listen for the Feedback State to trigger the Pill
          if (state is SwipeFeedback) {
            setState(() {
              _showPill = true;
              _pillText = state.feedback;
              _pillColor = state.feedback.contains('Connected') 
                  ? AppTheme.successColor 
                  : AppTheme.primaryColor;
            });

            // 2. Auto-hide the pill after 1.5 seconds
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                setState(() => _showPill = false);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is FeedLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }

          if (state is FeedError) {
            return Center(child: Text(state.message)); // Simplified error for brevity
          }

          if (state is StatsReveal) {
            return StatsOverlayWidget(
              stats: state.stats,
              isMajority: state.isMajority,
              isGoldenTicket: state.isGoldenTicket,
              rewardPoints: state.rewardPoints,
              onNext: () {
                final pts = state.rewardPoints ?? 0;
                if (pts > 0) context.read<UserBloc>().add(AddKarmaPoints(pts));
                context.read<FeedBloc>().add(const ResumeFeed());
              },
            );
          }

          // Determine which cards to show
          List<CardModel> cards = [];
          if (state is FeedLoaded) cards = state.currentCards;
          if (state is SwipeFeedback) cards = state.currentCards;

          if (cards.isEmpty) {
            return const Center(child: Text("No more cards!"));
          }

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Layer 1: The Swiper
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardSwiper(
                  controller: _swiperController,
                  cardsCount: cards.length,
                  numberOfCardsDisplayed: math.min(3, cards.length),
                  backCardOffset: const Offset(0, 40),
                  padding: EdgeInsets.zero,
                  duration: const Duration(milliseconds: 200), // Fast swipe
                  onSwipe: _onSwipe,
                  cardBuilder: (context, index, _, __) {
                    return CardViewWidget(card: cards[index]);
                  },
                ),
              ),

              // Layer 2: The Feedback Pill (Controlled by Local State)
              if (_showPill)
                Positioned(
                  top: 60, // Sits nicely below status bar
                  child: FeedbackPill(
                    text: _pillText,
                    color: _pillColor,
                    isGold: false,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}