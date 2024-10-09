import 'package:flutter/material.dart';
import 'package:task_management_app/widgets/my_button.dart';

class MyDialogbox extends StatelessWidget {
  final controller;

  VoidCallback onSave;
  VoidCallback onCancel;
   MyDialogbox({super.key, required this.controller, required this.onCancel, required this.onSave});

   @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 140,
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add new Text',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons properly
                children: [
                  MyButton(
                    text: 'Save',
                    onPressed: onSave, // Use the passed onSave callback
                  ),
                  MyButton(
                    text: 'Cancel',
                    onPressed: onCancel, // Use the passed onCancel callback
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
