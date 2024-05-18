import 'package:flutter/material.dart';

class GenderAutoComplete extends StatefulWidget {
  final TextEditingController genderController;

  const GenderAutoComplete({Key? key, required this.genderController})
      : super(key: key);

  @override
  _GenderAutoCompleteState createState() => _GenderAutoCompleteState();
}

class _GenderAutoCompleteState extends State<GenderAutoComplete> {
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
    'Custom'
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _genderOptions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Set the initial value of the fieldTextEditingController to the value of genderController
        fieldTextEditingController.text = widget.genderController.text;
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: const InputDecoration(
            labelText: 'Gender',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter or select a gender';
            }
            return null;
          },
        );
      },
      onSelected: (String selection) {
        widget.genderController.text = selection;
      },
    );
  }
}
