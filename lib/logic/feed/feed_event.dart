import 'package:equatable/equatable.dart';

enum SwipeDirection {
  left,  // No
  right, // Yes
}

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeed extends FeedEvent {
  const LoadFeed();
}

class SwipeCard extends FeedEvent {
  final String cardId;
  final SwipeDirection direction;

  const SwipeCard({
    required this.cardId,
    required this.direction,
  });

  @override
  List<Object?> get props => [cardId, direction];
}

class ResumeFeed extends FeedEvent {
  const ResumeFeed();
}
