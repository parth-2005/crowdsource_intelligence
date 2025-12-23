import '../models/form_model.dart';

abstract class IFormsRepository {
  Future<List<FormModel>> fetchForms();
  Future<FormModel> getFormById(String formId);
  Future<void> submitFormResponse(FormResponseModel response);
}
