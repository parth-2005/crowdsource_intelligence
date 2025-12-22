import '../models/card_model.dart';
import 'i_card_repository.dart';

class MockCardRepository implements ICardRepository {
  @override
  Future<List<CardModel>> fetchCards() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      // Card #1: Standard Binary Question
      const CardModel(
        id: '1',
        type: CardType.BINARY,
        question: 'Is pineapple on pizza a crime?',
        imageUrl: 'https://picsum.photos/400/600?random=1',
        stats: StatsData(
          yesPercent: 68,
          totalVotes: 1247,
        ),
      ),
      
      // Card #2: Standard Binary Question
      const CardModel(
        id: '2',
        type: CardType.BINARY,
        question: 'Should AI have rights?',
        imageUrl: 'https://picsum.photos/400/600?random=2',
        stats: StatsData(
          yesPercent: 42,
          totalVotes: 3542,
        ),
      ),
      
      // Card #3: Golden Ticket
      const CardModel(
        id: '3',
        type: CardType.GOLDEN_TICKET,
        question: '🎟️ GOLDEN TICKET! Share this app with a friend!',
        imageUrl: 'https://picsum.photos/400/600?random=3',
        stats: StatsData(
          yesPercent: 100,
          totalVotes: 0,
        ),
        rewardPoints: 50,
      ),
      
      // Card #4: Standard Binary Question
      const CardModel(
        id: '4',
        type: CardType.BINARY,
        question: 'Does social media improve mental health?',
        imageUrl: 'https://picsum.photos/400/600?random=4',
        stats: StatsData(
          yesPercent: 23,
          totalVotes: 8921,
        ),
      ),
      
      // Card #5: Controversial Topic - Tight Race
      const CardModel(
        id: '5',
        type: CardType.BINARY,
        question: 'Is working from home more productive than office work?',
        imageUrl: 'https://picsum.photos/400/600?random=5',
        stats: StatsData(
          yesPercent: 49,
          totalVotes: 5000,
        ),
      ),
      
      // Card #6: Sponsored
      const CardModel(
        id: '6',
        type: CardType.SPONSORED,
        question: 'Would you try a new eco-friendly product brand?',
        imageUrl: 'https://picsum.photos/400/600?random=6',
        stats: StatsData(
          yesPercent: 81,
          totalVotes: 2156,
        ),
      ),
      
      // Card #7: Standard Binary Question
      const CardModel(
        id: '7',
        type: CardType.BINARY,
        question: 'Is breakfast the most important meal of the day?',
        imageUrl: 'https://picsum.photos/400/600?random=7',
        stats: StatsData(
          yesPercent: 72,
          totalVotes: 4321,
        ),
      ),
    ];
  }

  @override
  Future<void> submitSwipe(String cardId, bool isYes) async {
    // Simulate network delay for submission
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would send the swipe data to the backend
  }
}
