import 'package:equatable/equatable.dart';

enum CardType {
  BINARY,
  GOLDEN_TICKET,
  SPONSORED,
}

class StatsData extends Equatable {
  final int yesPercent;
  final int totalVotes;

  const StatsData({
    required this.yesPercent,
    required this.totalVotes,
  });

  factory StatsData.fromJson(Map<String, dynamic> json) {
    return StatsData(
      yesPercent: json['yesPercent'] as int,
      totalVotes: json['totalVotes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yesPercent': yesPercent,
      'totalVotes': totalVotes,
    };
  }

  @override
  List<Object?> get props => [yesPercent, totalVotes];
}

class CardModel extends Equatable {
  final String id;
  final CardType type;
  final String question;
  final String imageUrl;
  final StatsData stats;
  final int? rewardPoints;

  const CardModel({
    required this.id,
    required this.type,
    required this.question,
    required this.imageUrl,
    required this.stats,
    this.rewardPoints,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      type: CardType.values.firstWhere(
        (e) => e.toString() == 'CardType.${json['type']}',
      ),
      question: json['question'] as String,
      imageUrl: json['imageUrl'] as String,
      stats: StatsData.fromJson(json['stats'] as Map<String, dynamic>),
      rewardPoints: json['rewardPoints'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'question': question,
      'imageUrl': imageUrl,
      'stats': stats.toJson(),
      'rewardPoints': rewardPoints,
    };
  }

  @override
  List<Object?> get props => [id, type, question, imageUrl, stats, rewardPoints];
}
