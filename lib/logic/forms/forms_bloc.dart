import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/i_forms_repository.dart';
import 'forms_event.dart';
import 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final IFormsRepository repository;

  FormsBloc({required this.repository}) : super(const FormsInitial()) {
    on<LoadForms>(_onLoadForms);
    on<LoadFormById>(_onLoadFormById);
    on<SubmitForm>(_onSubmitForm);
  }

  Future<void> _onLoadForms(LoadForms event, Emitter<FormsState> emit) async {
    emit(const FormsLoading());
    try {
      final forms = await repository.fetchForms();
      emit(FormsLoaded(forms));
    } catch (e) {
      emit(FormsError('Failed to load forms: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFormById(
    LoadFormById event,
    Emitter<FormsState> emit,
  ) async {
    emit(const FormsLoading());
    try {
      final form = await repository.getFormById(event.formId);
      emit(FormDetailLoaded(form));
    } catch (e) {
      emit(FormsError('Failed to load form: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<FormsState> emit,
  ) async {
    emit(const FormSubmitting());
    try {
      await repository.submitFormResponse(event.response);
      // Assume full reward for successful submission
      // In real app, backend validates and awards points
      emit(const FormSubmitted(0)); // Points awarded by UserBloc
    } catch (e) {
      emit(FormsError('Failed to submit form: ${e.toString()}'));
    }
  }
}
