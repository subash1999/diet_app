import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/global_state.dart';
import '../utils/utils.dart';

class HomePageDateChanger extends StatefulWidget {
  final DateTime? initialDate;

  const HomePageDateChanger({Key? key, this.initialDate}) : super(key: key);

  @override
  _HomePageDateChangerState createState() => _HomePageDateChangerState();
}

class _HomePageDateChangerState extends State<HomePageDateChanger> {
  late DateTime _dashboardDate;

  @override
  void initState() {
    super.initState();
    _dashboardDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Ensure the lastDate is set to today with the time part reset to the start of the day
    final DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dashboardDate,
      firstDate: DateTime(2000),
      lastDate: today, // Use 'today' with the time part reset
    );
    if (picked != null && picked != _dashboardDate) {
      setState(() {
        _dashboardDate = picked;
        context.read<GlobalState>().setDashboardDate(_dashboardDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed:
              _dashboardDate.year > 2000 ? () => _changeDate(false) : null,
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 8),
              Text(Utils.dateFormat(_dashboardDate)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: _dashboardDate
                  .isBefore(DateTime.now().subtract(Duration(days: 1)))
              ? () => _changeDate(true)
              : null,
        ),
      ],
    );
  }

  void _changeDate(bool increment) {
    final newDate = increment
        ? _dashboardDate.add(Duration(days: 1))
        : _dashboardDate.subtract(Duration(days: 1));
    if (newDate.year >= 2000 &&
        newDate.isBefore(DateTime.now().add(Duration(days: 1)))) {
      setState(() {
        _dashboardDate = newDate;
        context.read<GlobalState>().setDashboardDate(_dashboardDate);
      });
    }
  }
}
