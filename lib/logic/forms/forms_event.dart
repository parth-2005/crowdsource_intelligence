import 'package:equatable/equatable.dart';
import '../../data/models/form_model.dart';

abstract class FormsEvent extends Equatable {
  const FormsEvent();

  @override
  List<Object?> get props => [];
}

class LoadForms extends FormsEvent {
  const LoadForms();
}

class LoadFormById extends FormsEvent {
  final String formId;

  const LoadFormById(this.formId);

  @override
  List<Object?> get props => [formId];
}

class SubmitForm extends FormsEvent {
  final FormResponseModel response;

  const SubmitForm(this.response);

  @override
  List<Object?> get props => [response];
}
