import 'package:flutter/material.dart';
import 'controllers.dart';

class BirthdayInput extends StatelessWidget {
  const BirthdayInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: birthdayController,
      decoration: const InputDecoration(
        labelText: 'Birthday',
      ),
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
            String formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
            birthdayController.text = formattedDate;
        }
      },
    );
  }
}