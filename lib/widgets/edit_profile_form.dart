import 'dart:ffi';

import 'package:diet_app/models/user_model.dart';
import 'package:diet_app/services/auth_service.dart';
import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/validators.dart';
import 'package:diet_app/widgets/dob_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/global_state.dart';
import 'gender_auto_complete.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _daysToAchieveGoalController =
      TextEditingController();
  final TextEditingController _currentWeightController =
      TextEditingController();
  final TextEditingController _goalWeightController = TextEditingController();

  final String _kilogram = 'kg';
  final String _pound = 'lbs';
  final String _centimeter = 'cm';

  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  String _currentWeightLabel = 'Current Weight (kg)';
  String _goalWeightLabel = 'Goal Weight (kg)';
  String _email = '';

  void _updateWeightUnitLabels(String newUnit) {
    setState(() {
      _weightUnit = newUnit;
      _currentWeightLabel = 'Current Weight ($_weightUnit)';
      _goalWeightLabel = 'Goal Weight ($_weightUnit)';
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = context.read<GlobalState>().currentUser;
    updateFormValues(_user);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: $_email',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DOBField(dobController: _dobController),
          const SizedBox(height: 20),
          GenderAutoComplete(genderController: _genderController),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: 'Height'),
                  validator: (value) {
                    if (_heightUnit == _centimeter) {
                      return RangeValidator.validate(value, min: 1, max: 400);
                    } else {
                      return RangeValidator.validate(value, min: 1, max: 120);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _heightUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    _heightUnit = newValue!;
                  });
                },
                items: <String>[_centimeter]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Text('Weight Unit:', style: TextStyle(fontSize: 16)),
          // DropdownButton<String>(
          //   value: _weightUnit,
          //   onChanged: (String? newValue) {
          //     if (newValue != null) {
          //       _weightUnit = newValue;
          //       _updateWeightUnitLabels(newValue);
          //     }
          //   },
          //   items: <String>[_kilogram, _pound]
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _currentWeightController,
                  decoration: InputDecoration(
                      labelText: _currentWeightLabel, suffixText: _weightUnit),
                  validator: (value) {
                    if (_weightUnit == _kilogram) {
                      return RangeValidator.validate(value, min: 1, max: 1000);
                    } else {
                      return RangeValidator.validate(value, min: 1, max: 2205);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _goalWeightController,
                  decoration: InputDecoration(
                      labelText: _goalWeightLabel, suffixText: _weightUnit),
                  validator: (value) {
                    if (_weightUnit == _kilogram) {
                      return RangeValidator.validate(value, min: 1, max: 1000);
                    } else {
                      return RangeValidator.validate(value, min: 1, max: 2205);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _daysToAchieveGoalController,
            decoration: const InputDecoration(
              labelText: 'Number of Days to Achieve Goal Weight',
              suffixText: 'Days',
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveUserProfile();
                }
              },
              child: Text('Save'),
            ),
          )
        ],
      ),
    );
  }

  void _saveUserProfile() async {
    try {
      context.read<GlobalState>().setLoading(true);

      UserModel? _user = context.read<GlobalState>().currentUser;
      if (_user == null) {
        throw Exception('User not found');
      }
      final user = UserModel(
        uid: _user.uid,
        email: _user.email,
        name: _nameController.text,
        dob: _dobController.text,
        gender: _genderController.text,
        height: double.tryParse(_heightController.text),
        weightUnit: _weightUnit,
        currentWeight: double.tryParse(_currentWeightController.text),
        goalWeight: double.tryParse(_goalWeightController.text),
        daysToAchieveGoal: int.tryParse(_daysToAchieveGoalController.text),
      );
      await AuthService().updateUser(user);

      // Update the user profile in the app state
      context.read<GlobalState>().setUser(user);
      // Update the form values
      updateFormValues(user);

      // Show success message
      showAlertDialog(context, 'Saved', 'Profile saved successfully');
    } catch (e) {
      print('Error saving user profile: $e');
      showAlertDialog(
          context, 'Error', 'Error saving user profile ${e.toString()}');
    } finally {
      context.read<GlobalState>().setLoading(false);
    }
  }

  void updateFormValues(UserModel? user) {
    if (user != null) {
      _email = user.email ?? '';
      _nameController.text = user.name ?? '';
      _dobController.text = user.dob ?? '';
      _genderController.text = user.gender ?? '';
      _heightController.text =
          user.height.toString() != 'null' ? user.height.toString() : '';
      _daysToAchieveGoalController.text =
          user.daysToAchieveGoal.toString() != 'null'
              ? user.daysToAchieveGoal.toString()
              : '';
      _currentWeightController.text = user.currentWeight.toString() != 'null'
          ? user.currentWeight.toString()
          : '';
      _goalWeightController.text = user.goalWeight.toString() != 'null'
          ? user.goalWeight.toString()
          : '';
      _updateWeightUnitLabels(user.weightUnit ?? _kilogram);
    }
  }
}
