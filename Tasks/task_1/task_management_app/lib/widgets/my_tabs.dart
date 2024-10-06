import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabs extends StatefulWidget {
  const MyTabs({super.key});

  @override
  State<MyTabs> createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  List<String> tabs = ['All', 'Work', 'Personal'];
  int current = 0;

  // Calculate the position of the underline dynamically based on the selected tab
  double changePositionOfLine() {
    double basePosition = 0; // Starting left padding for the first tab
    switch (current) {
      case 0:
        return basePosition;
      case 1:
        return basePosition + 70; // Adjusted for width of first tab
      case 2:
        return basePosition + 140; // Adjusted for width of first two tabs
      default:
        return basePosition;
    }
  }

  // Change the width of the underline for each tab
  double changeContainerWidth() {
    switch (current) {
      case 0:
        return 50; // Width for "All"
      case 1:
        return 70; // Width for "Work"
      case 2:
        return 100; // Width for "Personal"
      default:
        return 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.1, // Full height available
      child: Column(
        children: [
          // Tabs Container
          Container(
            width: size.width,
            height: size.height * 0.07, // Slightly increased height

            child: Stack(
              children: [
                // Tab List
                Positioned.fill(
                  child: ListView.builder(
                    itemCount: tabs.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 10 : 23, top: 7, right: 10),
                          child: Text(
                            tabs[index],
                            style: GoogleFonts.poppins(
                              fontSize: current == index ? 20 : 18,
                              fontWeight: current == index
                                  ? FontWeight.w600
                                  : FontWeight.w300,
                              color:
                                  current == index ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Animated underline
                AnimatedPositioned(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 500),
                  bottom: 20,
                  left:
                      changePositionOfLine(), // Dynamically adjust the position
                  child: AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 500),
                    width:
                        changeContainerWidth(), // Dynamically adjust the width
                    height: size.height * 0.008,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Additional content to fill the rest of the screen
          // Expanded(
          //   child: Container(
          //     color: Colors.blue, // Example of filling remaining space
          //     child: Center(
          //       child: Text(
          //         'Content Goes Here',
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
