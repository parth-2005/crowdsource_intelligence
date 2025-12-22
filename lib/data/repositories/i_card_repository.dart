import '../models/card_model.dart';

abstract class ICardRepository {
  Future<List<CardModel>> fetchCards();
  Future<void> submitSwipe(String cardId, bool isYes);
}
