import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/constants/colors.dart';
import 'package:task_management_app/widgets/my_dialogbox.dart';
import 'package:task_management_app/widgets/my_tabs.dart';
import 'package:task_management_app/widgets/to_fo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<dynamic>> todolist = [
    ['Make Tutorial', false],
    ['Review Code', false],
    ['Prepare Presentation', false],
  ];

  final TextEditingController _controller = TextEditingController();

  void checkboxchanged(bool? value, int index) {
    setState(() {
      todolist[index][1] = value!; // Fix toggle logic
    });
  }

  void savenewtask() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        todolist.add([_controller.text, false]);
        _controller.clear(); // Clear the input field after saving
      }
    });
    Navigator.of(context).pop();
  }

  void createnewtask() {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialogbox(
          controller: _controller,
          onCancel: () {
            _controller.clear(); // Clear controller on cancel as well
            Navigator.of(context).pop();
          },
          onSave: savenewtask,
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      todolist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 120,
              width: 120,
            ),
            const Spacer(),
            const CircleAvatar(
              child: Icon(Icons.notifications),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: createnewtask,
        child: const Icon(Icons.add),
        tooltip: 'Add Task', // Added tooltip for better UX
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuesday',
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '4th October, 2024',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${todolist.length}', 
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Tasks in total',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const MyTabs(),
            Text(
              'Today\'s task',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            // Use Container to provide height for ListView
            Container(
              height: MediaQuery.of(context).size.height *
                  0.5, // Adjust height as needed
              child: ListView.builder(
                itemCount: todolist.length,
                itemBuilder: (context, index) {
                  return ToFoTile(
                    taskname: todolist[index][0],
                    taskcompleted: todolist[index][1],
                    onChanged: (value) => checkboxchanged(value, index),
                    deletefunction: (context) => deleteTask(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
