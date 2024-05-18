import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalorieProgressIndicator extends StatefulWidget {
  final int currentCalories;
  final int totalCaloriesGoal;
  final String totalCaloriesMessage;
  final bool isTotalCaloriesAssumed;

  const CalorieProgressIndicator({
    Key? key,
    required this.currentCalories,
    required this.totalCaloriesGoal,
    required this.totalCaloriesMessage,
    required this.isTotalCaloriesAssumed,
  }) : super(key: key);

  @override
  _CalorieProgressIndicatorState createState() =>
      _CalorieProgressIndicatorState();
}

class _CalorieProgressIndicatorState extends State<CalorieProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.totalCaloriesGoal > 0
        ? widget.currentCalories / widget.totalCaloriesGoal
        : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                strokeWidth: 12,
              ),
              Center(
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Today\'s Intake: ${widget.currentCalories} kcal',
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Goal: ${widget.totalCaloriesGoal} kcal ${widget.isTotalCaloriesAssumed ? " (Assumed)" : ""}',
              style: const TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Calorie Goal Information'),
                  content: Text(widget.totalCaloriesMessage),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
