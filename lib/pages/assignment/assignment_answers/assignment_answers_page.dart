import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:school_erp/theme/colors.dart';
import 'package:school_erp/pages/common_widgets/custom_app_bar.dart';
import 'package:school_erp/pages/assignment/assignment_check_page/widgets/student_item.dart';
import 'package:school_erp/theme/text_styles.dart';
import 'widgets/assignment_card.dart';

class AssignmentAnswersPage extends StatefulWidget {
  final Student student; // Add this line

  const AssignmentAnswersPage(
      {super.key,
      required this.student}); // Update the constructor to include this parameter

  @override
  _AssignmentAnswersPageState createState() => _AssignmentAnswersPageState();
}

class _AssignmentAnswersPageState extends State<AssignmentAnswersPage> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      questions = jsonResponse;
      // Automatically select the correct option for the first question
      if (questions.isNotEmpty && questions[0]['type'] == 'multi') {
        final correctOption = questions[0]['answers']
            .firstWhere((option) => option['is_correct'] == 1);
        selectedOption = correctOption['id'];
      }
    });
  }

  void _handleBackPress(BuildContext context) {
    Navigator.pop(context);
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        // Automatically select the correct answer for the next question
        if (questions[currentQuestionIndex]['type'] == 'multi') {
          final correctOption = questions[currentQuestionIndex]['answers']
              .firstWhere((option) => option['is_correct'] == 1);
          selectedOption = correctOption['id'];
        } else {
          selectedOption = null; // Clear selection for non-multi questions
        }
      });
    } else {
      _handleSubmit(context, questions[currentQuestionIndex]);
    }
  }

  void _handleSubmit(BuildContext context, dynamic question) {
    // Handle submission logic
  }

  void _updateQuestion() {
    // Handle update logic
  }

  void _onOptionSelected(int optionId) {
    setState(() {
      selectedOption = optionId;
    });
  }

  QuestionType _getQuestionType(String type) {
    switch (type) {
      case 'multi':
        return QuestionType.multipleChoice;
      case 'essay':
        return QuestionType.essay;
      case 'short':
        return QuestionType.shortAnswer;
      case 'true_false':
        return QuestionType.trueOrFalse;
      default:
        return QuestionType
            .multipleChoice; // default to multiple choice if type is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${widget.student.name} Assignment Answers", // Example usage
        onBackPressed: () => _handleBackPress(context),
      ),
      body: Stack(
        children: [
          Container(color: AppColors.primaryColor),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: AssignmentCard(
                          question: questions[currentQuestionIndex],
                          currentQuestionIndex: currentQuestionIndex,
                          totalQuestions: questions.length,
                          selectedOption: selectedOption,
                          onOptionSelected: _onOptionSelected,
                          onNextPressed: _nextQuestion,
                          onUpdatePressed: _updateQuestion,
                          questionType: _getQuestionType(
                              questions[currentQuestionIndex]['type']),
                          isInteractionEnabled: false,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
