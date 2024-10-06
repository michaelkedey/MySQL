import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/constants/colors.dart';

class ToFoTile extends StatelessWidget {
  final String taskname;
  final bool taskcompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deletefunction;
  ToFoTile(
      {super.key,
      required this.taskname,
      required this.taskcompleted,
      required this.onChanged, required this.deletefunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [SlidableAction(onPressed: deletefunction, icon: Icons.delete,backgroundColor: Colors.red,)]),
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: primaryColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  taskname,
                  style: GoogleFonts.poppins(
                      decoration: taskcompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Spacer(),
                Checkbox(
                  value: taskcompleted,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
