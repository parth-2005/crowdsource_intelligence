import '../models/form_model.dart';
import 'i_forms_repository.dart';

class MockFormsRepository implements IFormsRepository {
  @override
  Future<List<FormModel>> fetchForms() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      FormModel(
        id: 'f1',
        title: 'EV Charging Experience',
        description: 'Help us improve electric vehicle charging networks',
        rewardPoints: 150,
        estimatedTimeMinutes: 5,
        imageUrl: 'https://picsum.photos/400/300?random=f1',
        questions: [
          QuestionModel(
            id: 'q1',
            title: 'How often do you charge your EV?',
            type: QuestionType.RADIO,
            options: [
              const OptionModel(id: 'opt1', text: 'Daily'),
              const OptionModel(id: 'opt2', text: '3-4 times a week'),
              const OptionModel(id: 'opt3', text: 'Once a week'),
              const OptionModel(id: 'opt4', text: 'Rarely'),
            ],
          ),
          QuestionModel(
            id: 'q2',
            title: 'Which charging stations do you use?',
            type: QuestionType.CHECKBOX,
            options: [
              const OptionModel(id: 'opt1', text: 'Tesla Supercharger'),
              const OptionModel(id: 'opt2', text: 'ChargePoint'),
              const OptionModel(id: 'opt3', text: 'Electrify America'),
              const OptionModel(id: 'opt4', text: 'Other'),
            ],
          ),
          QuestionModel(
            id: 'q3',
            title: 'Rate your overall experience',
            description: '1 = Poor, 5 = Excellent',
            type: QuestionType.RATING,
            minRating: 1,
            maxRating: 5,
          ),
          QuestionModel(
            id: 'q4',
            title: 'What improvements would you suggest?',
            type: QuestionType.TEXT,
          ),
        ],
      ),
      FormModel(
        id: 'f2',
        title: 'Commute Preferences Survey',
        description: 'Tell us about your daily commute habits',
        rewardPoints: 120,
        estimatedTimeMinutes: 4,
        imageUrl: 'https://picsum.photos/400/300?random=f2',
        questions: [
          QuestionModel(
            id: 'q1',
            title: 'What is your primary mode of commute?',
            type: QuestionType.RADIO,
            options: [
              const OptionModel(id: 'opt1', text: 'Car'),
              const OptionModel(id: 'opt2', text: 'Public Transport'),
              const OptionModel(id: 'opt3', text: 'Bike'),
              const OptionModel(id: 'opt4', text: 'Walk'),
              const OptionModel(id: 'opt5', text: 'Remote'),
            ],
          ),
          QuestionModel(
            id: 'q2',
            title: 'Commute distance (one way)',
            type: QuestionType.RADIO,
            options: [
              const OptionModel(id: 'opt1', text: '< 5 km'),
              const OptionModel(id: 'opt2', text: '5-15 km'),
              const OptionModel(id: 'opt3', text: '15-30 km'),
              const OptionModel(id: 'opt4', text: '> 30 km'),
            ],
          ),
          QuestionModel(
            id: 'q3',
            title: 'Would you switch to greener commute options?',
            type: QuestionType.RATING,
            minRating: 1,
            maxRating: 5,
          ),
        ],
      ),
      FormModel(
        id: 'f3',
        title: 'Online Shopping Habits',
        description: 'Share your e-commerce preferences',
        rewardPoints: 100,
        estimatedTimeMinutes: 3,
        imageUrl: 'https://picsum.photos/400/300?random=f3',
        questions: [
          QuestionModel(
            id: 'q1',
            title: 'How often do you shop online?',
            type: QuestionType.RADIO,
            options: [
              const OptionModel(id: 'opt1', text: 'Daily'),
              const OptionModel(id: 'opt2', text: 'Weekly'),
              const OptionModel(id: 'opt3', text: 'Monthly'),
              const OptionModel(id: 'opt4', text: 'Rarely'),
            ],
          ),
          QuestionModel(
            id: 'q2',
            title: 'Which categories do you purchase?',
            type: QuestionType.CHECKBOX,
            options: [
              const OptionModel(id: 'opt1', text: 'Electronics'),
              const OptionModel(id: 'opt2', text: 'Fashion'),
              const OptionModel(id: 'opt3', text: 'Home & Garden'),
              const OptionModel(id: 'opt4', text: 'Books'),
              const OptionModel(id: 'opt5', text: 'Sports'),
            ],
          ),
          QuestionModel(
            id: 'q3',
            title: 'Additional feedback',
            type: QuestionType.TEXT,
            required: false,
          ),
        ],
      ),
    ];
  }

  @override
  Future<FormModel> getFormById(String formId) async {
    final forms = await fetchForms();
    return forms.firstWhere((f) => f.id == formId);
  }

  @override
  Future<void> submitFormResponse(FormResponseModel response) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, send to backend
  }
}
