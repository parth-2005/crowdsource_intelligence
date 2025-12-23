import 'package:equatable/equatable.dart';

enum QuestionType {
  TEXT,        // Free text input
  RADIO,       // Single choice
  CHECKBOX,    // Multiple choice
  RATING,      // 1-5 stars
}

class OptionModel extends Equatable {
  final String id;
  final String text;

  const OptionModel({
    required this.id,
    required this.text,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  List<Object?> get props => [id, text];
}

class QuestionModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final QuestionType type;
  final List<OptionModel> options; // For radio/checkbox
  final bool required;
  final int? minRating; // For rating type
  final int? maxRating;

  const QuestionModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.options = const [],
    this.required = true,
    this.minRating,
    this.maxRating,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
      ),
      options: (json['options'] as List<dynamic>?)
              ?.map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
              .toList() ??
          [],
      required: json['required'] as bool? ?? true,
      minRating: json['minRating'] as int?,
      maxRating: json['maxRating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'options': options.map((o) => o.toJson()).toList(),
      'required': required,
      'minRating': minRating,
      'maxRating': maxRating,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, description, type, options, required, minRating, maxRating];
}

class FormModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final int estimatedTimeMinutes;
  final List<QuestionModel> questions;
  final String? imageUrl;

  const FormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.estimatedTimeMinutes,
    required this.questions,
    this.imageUrl,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      rewardPoints: json['rewardPoints'] as int,
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rewardPoints': rewardPoints,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'questions': questions.map((q) => q.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        rewardPoints,
        estimatedTimeMinutes,
        questions,
        imageUrl,
      ];
}

class FormResponseModel extends Equatable {
  final String formId;
  final String userId;
  final Map<String, dynamic> answers; // questionId -> answer
  final DateTime submittedAt;

  const FormResponseModel({
    required this.formId,
    required this.userId,
    required this.answers,
    required this.submittedAt,
  });

  factory FormResponseModel.fromJson(Map<String, dynamic> json) {
    return FormResponseModel(
      formId: json['formId'] as String,
      userId: json['userId'] as String,
      answers: json['answers'] as Map<String, dynamic>,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'userId': userId,
      'answers': answers,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [formId, userId, answers, submittedAt];
}
