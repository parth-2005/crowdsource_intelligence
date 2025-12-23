import 'package:equatable/equatable.dart';
import '../../data/models/form_model.dart';

abstract class FormsState extends Equatable {
  const FormsState();

  @override
  List<Object?> get props => [];
}

class FormsInitial extends FormsState {
  const FormsInitial();
}

class FormsLoading extends FormsState {
  const FormsLoading();
}

class FormsLoaded extends FormsState {
  final List<FormModel> forms;

  const FormsLoaded(this.forms);

  @override
  List<Object?> get props => [forms];
}

class FormDetailLoaded extends FormsState {
  final FormModel form;

  const FormDetailLoaded(this.form);

  @override
  List<Object?> get props => [form];
}

class FormSubmitting extends FormsState {
  const FormSubmitting();
}

class FormSubmitted extends FormsState {
  final int pointsEarned;

  const FormSubmitted(this.pointsEarned);

  @override
  List<Object?> get props => [pointsEarned];
}

class FormsError extends FormsState {
  final String message;

  const FormsError(this.message);

  @override
  List<Object?> get props => [message];
}
