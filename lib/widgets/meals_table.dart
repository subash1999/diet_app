import 'package:diet_app/services/meal_service.dart';
import 'package:diet_app/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/models/meal_model.dart';
import 'package:provider/provider.dart';

import '../utils/global_state.dart';
import '../utils/utils.dart';

class MealsTable extends StatefulWidget {
  final List<MealModel> meals;

  const MealsTable({Key? key, required this.meals}) : super(key: key);

  @override
  _MealsTableState createState() => _MealsTableState();
}

class _MealsTableState extends State<MealsTable> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Food')),
                    DataColumn(label: Text('Calories')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: widget.meals
                      .map((meal) => DataRow(cells: [
                            DataCell(Text(
                                meal.type + Utils.getMealTypeIcon(meal.type))),
                            DataCell(Flexible(
                                child: Text(meal.food,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis))),
                            DataCell(Text('${meal.calories} kcal')),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, meal),
                            )),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.meals.isEmpty ? 'No Meals Added' : ''),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, MealModel meal) async {
    if (meal.id == null) return;
    String confirmationMessage = 'Are you sure you want to delete this meal?';
    confirmationMessage += "\n\nDate: ${meal.date}";
    confirmationMessage +=
        "\n\nType: ${meal.type} ${Utils.getMealTypeIcon(meal.type)}";
    confirmationMessage += "\nFood: ${meal.food}";
    confirmationMessage += "\nCalories: ${meal.calories} kcal";

    bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text(confirmationMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmed) {
      _deleteMeal(meal);
    }
  }

  Future<bool> _deleteMeal(MealModel meal) async {
    context.read<GlobalState>().setLoading(true);
    try {
      await MealService.deleteMealForUser(meal.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Meal deleted successfully")),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete meal")),
      );
      return false;
    } finally {
      context.read<GlobalState>().setLoading(false);
    }
  }
}
