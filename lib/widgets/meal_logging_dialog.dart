import 'dart:convert';
import 'package:diet_app/services/meal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

import '../models/meal_model.dart';

class MealLoggingDialog extends StatefulWidget {
  @override
  _MealLoggingDialogState createState() => _MealLoggingDialogState();
}

class _MealLoggingDialogState extends State<MealLoggingDialog> {
  DateTime selectedDate = DateTime.now();
  String mealType = 'Breakfast';

  // select meal type based on the time of the day
// String mealType = Utils.getMealTypeBasedOnTime();
  List<String> mealTypeOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  List<String> _foods = [];

  // Add a GlobalKey for the Form widget
  final _formKey = GlobalKey<FormState>();
  final TextEditingController foodController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mealTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final String response = await rootBundle.loadString('assets/foods.json');
    final data = await json.decode(response);
    setState(() {
      _foods = List<String>.from(data);
      // sort the _foods list
      _foods.sort();
    });
  }

  void _presentDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Log Meal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: _presentDatePicker,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    initialValue:
                        intl.DateFormat('yyyy-MM-dd').format(selectedDate),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Date',
                    ),
                    validator: (value) {
                      // Example validation: ensure the date is not empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      // validate the date format
                      if (intl.DateFormat('yyyy-MM-dd').parseLoose(value) ==
                          null) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: mealType,
                onChanged: (String? newValue) {
                  setState(() {
                    mealType = newValue!;
                  });
                },
                items: <String>[...mealTypeOptions]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.fastfood),
                  labelText: 'Meal Type',
                ),
                validator: (value) {
                  // Example validation: ensure a meal type is selected
                  if (value == null || value.isEmpty) {
                    return 'Please select a meal type';
                  }
                  if (mealTypeOptions.contains(value) == false) {
                    return 'Please select a valid meal type';
                  }
                  return null;
                },
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return _foods.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Food',
                      icon: Icon(Icons.restaurant_menu),
                    ),
                    validator: (value) {
                      // Example validation: ensure the food is not empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter or select a food';
                      }
                      return null;
                    },
                  );
                },
              ),
              TextFormField(
                controller: caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)',
                  icon: Icon(Icons.fitness_center),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Example validation: ensure calories is a number and not empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Log'),
          onPressed: () {
            // Use the _formKey to validate the form
            if (_formKey.currentState!.validate()) {
              // _logMeal();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  void _logMeal(String food, double calories, DateTime date, String mealType) {
    // MealModel({
    //   uid: 'user1',
    //   food: food,
    //   calories: calories,
    //   date: date,
    //   type: mealType,
    // });
  }
}
