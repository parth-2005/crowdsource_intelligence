import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/form_model.dart';
import '../../logic/forms/forms_bloc.dart';
import '../../logic/forms/forms_event.dart';
import '../../logic/forms/forms_state.dart';
import '../../logic/user/user_bloc.dart';
import '../../logic/user/user_event.dart';

class FormDetailScreen extends StatefulWidget {
  final FormModel form;

  const FormDetailScreen({
    super.key,
    required this.form,
  });

  @override
  State<FormDetailScreen> createState() => _FormDetailScreenState();
}

class _FormDetailScreenState extends State<FormDetailScreen> {
  final Map<String, dynamic> _answers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.form.title),
        centerTitle: true,
      ),
      body: BlocListener<FormsBloc, FormsState>(
        listener: (context, state) {
          if (state is FormSubmitted) {
            // Award points
            context.read<UserBloc>().add(
              AddKarmaPoints(widget.form.rewardPoints),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Form submitted! +${widget.form.rewardPoints} points',
                ),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is FormsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.form.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Est. ${widget.form.estimatedTimeMinutes} min | +${widget.form.rewardPoints} pts',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(
                  widget.form.questions.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _QuestionWidget(
                      question: widget.form.questions[index],
                      onAnswerChanged: (answer) {
                        _answers[widget.form.questions[index].id] = answer;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<FormsBloc, FormsState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is FormsLoading || state is FormSubmitting
                            ? null
                            : () => _submitForm(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: state is FormSubmitting
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Submit Form',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final response = FormResponseModel(
        formId: widget.form.id,
        userId: 'user_123',
        answers: _answers,
        submittedAt: DateTime.now(),
      );

      context.read<FormsBloc>().add(SubmitForm(response));
    }
  }
}

class _QuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(dynamic) onAnswerChanged;

  const _QuestionWidget({
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<_QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<_QuestionWidget> {
  late dynamic _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = _getInitialValue();
  }

  dynamic _getInitialValue() {
    switch (widget.question.type) {
      case QuestionType.TEXT:
        return '';
      case QuestionType.RADIO:
        return null;
      case QuestionType.CHECKBOX:
        return <String>[];
      case QuestionType.RATING:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (widget.question.description != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.question.description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
        const SizedBox(height: 12),
        _buildQuestionInput(context),
      ],
    );
  }

  Widget _buildQuestionInput(BuildContext context) {
    switch (widget.question.type) {
      case QuestionType.TEXT:
        return TextFormField(
          initialValue: _selectedValue,
          onChanged: (value) {
            _selectedValue = value;
            widget.onAnswerChanged(value);
          },
          validator: (value) {
            if (widget.question.required &&
                (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

      case QuestionType.RADIO:
        return Column(
          children: widget.question.options
              .map(
                (option) => RadioListTile<String>(
                  title: Text(option.text),
                  value: option.id,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    widget.onAnswerChanged(value);
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              )
              .toList(),
        );

      case QuestionType.CHECKBOX:
        return Column(
          children: widget.question.options
              .map(
                (option) => CheckboxListTile(
                  title: Text(option.text),
                  value: (_selectedValue as List<String>)
                      .contains(option.id),
                  onChanged: (bool? isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        (_selectedValue as List<String>).add(option.id);
                      } else {
                        (_selectedValue as List<String>).remove(option.id);
                      }
                    });
                    widget.onAnswerChanged(_selectedValue);
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              )
              .toList(),
        );

      case QuestionType.RATING:
        return Row(
          children: List.generate(
            widget.question.maxRating ?? 5,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedValue = index + 1;
                  });
                  widget.onAnswerChanged(index + 1);
                },
                child: Icon(
                  Icons.star,
                  color: (index + 1) <= (_selectedValue ?? 0)
                      ? Colors.amber
                      : Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
        );
    }
  }
}
