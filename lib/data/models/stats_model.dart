import 'package:equatable/equatable.dart';

class StatsModel extends Equatable {
  final int yesPercent;
  final int noPercent;
  final int totalVotes;
  final bool isMajority;
  final String cardId;

  const StatsModel({
    required this.yesPercent,
    required this.noPercent,
    required this.totalVotes,
    required this.isMajority,
    required this.cardId,
  });

  @override
  List<Object?> get props => [yesPercent, noPercent, totalVotes, isMajority, cardId];
}
