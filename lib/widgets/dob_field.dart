import 'package:flutter/material.dart';

import '../utils/validators.dart';

class DOBField extends StatefulWidget {
  final TextEditingController dobController;

  const DOBField({Key? key, required this.dobController}) : super(key: key);

  @override
  _DOBFieldState createState() => _DOBFieldState();
}

class _DOBFieldState extends State<DOBField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dobController,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'YYYY-MM-DD',
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? dob = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (dob != null) {
          setState(() {
            widget.dobController.text =
                '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day}';
          });
        }
      },
      validator: (value) {
        // Assuming DateValidator.validate is accessible
        return DateValidator.validate(value);
      },
    );
  }
}
