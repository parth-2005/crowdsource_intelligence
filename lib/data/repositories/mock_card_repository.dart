import '../models/card_model.dart';
import 'i_card_repository.dart';

class MockCardRepository implements ICardRepository {
  @override
  Future<List<CardModel>> fetchCards() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final cards = <CardModel>[];
    final questions = [
      'Is pineapple on pizza acceptable?',
      'Should AI have legal rights?',
      'Does social media improve mental health?',
      'Is working from home more productive?',
      'Should we explore Mars before fixing Earth?',
      'Is cryptocurrency the future of money?',
      'Should universities be free?',
      'Is privacy more important than security?',
      'Would you time travel to past or future?',
      'Should we go completely cashless?',
      'Is a hot dog a sandwich?',
      'Should remote work be the default?',
      'Is climate change humanity\'s #1 problem?',
      'Should social media have age limits?',
      'Is video gaming good for mental health?',
      'Would you colonize another planet?',
      'Should we ban single-use plastics?',
      'Is being rich better than being famous?',
      'Should ghosting be acceptable?',
      'Is cereal technically a soup?',
    ];

    // Generate 51 cards with mixed types
    for (int i = 0; i < 51; i++) {
      final CardType type;
      final bool? correctTrapAnswer;
      final String? summaryTitle;
      final int? summaryScore;
      String question;

      // Every 10th card: TRAP
      if ((i + 1) % 10 == 0) {
        type = CardType.TRAP;
        question = 'Swipe LEFT if you are human 🤖';
        correctTrapAnswer = false; // Left is correct
        summaryTitle = null;
        summaryScore = null;
      }
      // Every 7th card (that's not a TRAP): GOLDEN_TICKET
      else if ((i + 1) % 7 == 0 && (i + 1) % 10 != 0) {
        type = CardType.GOLDEN_TICKET;
        question = '🎟️ GOLDEN TICKET! You unlocked bonus rewards!';
        correctTrapAnswer = null;
        summaryTitle = null;
        summaryScore = null;
      }
      // Every 5th card (not TRAP, not GOLDEN): SUMMARY
      else if ((i + 1) % 5 == 0 && (i + 1) % 10 != 0 && (i + 1) % 7 != 0) {
        type = CardType.SUMMARY;
        summaryScore = 60 + (i % 40); // 60-99%
        question = 'You\'re ${summaryScore}% in sync with the community 🎯';
        correctTrapAnswer = null;
        summaryTitle = 'Vibe Check';
      }
      // Rest: BINARY
      else {
        type = CardType.BINARY;
        question = questions[i % questions.length];
        correctTrapAnswer = null;
        summaryTitle = null;
        summaryScore = null;
      }

      cards.add(
        CardModel(
          id: 'card_${i + 1}',
          type: type,
          question: question,
          imageUrl: 'https://via.placeholder.com/400x600?text=Card${i + 1}',
          stats: StatsData(
            yesPercent: 50 + (i % 50),
            totalVotes: 1000 + (i * 50),
          ),
          rewardPoints: type == CardType.GOLDEN_TICKET
              ? 100
              : type == CardType.SURVEY
                  ? 150
                  : 50,
          correctTrapAnswer: correctTrapAnswer,
          summaryTitle: summaryTitle,
          summaryScore: summaryScore,
        ),
      );
    }

    return cards;
  }

  @override
  Future<void> submitSwipe(String cardId, bool isYes) async {
    // Simulate network delay for submission
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would send the swipe data to the backend
  }
}
