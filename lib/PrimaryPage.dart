import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/HomePage.dart';
import 'package:project_1/OverviewPage.dart';
import 'package:project_1/providers/taskList.dart';

class Primary extends StatefulWidget {
  const Primary({Key? key}) : super(key: key);

  @override
  State<Primary> createState() => _PrimaryState();
}

class _PrimaryState extends State<Primary> {
  final headers = ["            Today", "          Weekly Overview"];
  int currentIndex = 0;
  final screens = [
    const HomePage(), const OverviewPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
        appBar: AppBar(
          title: Text(headers[currentIndex],
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              )),
          toolbarHeight: 110,
          backgroundColor: const Color(0xfafafafa),
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 0.0,
          ),
          child: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
            onTap: ((index) {
              setState(() {
                currentIndex = index;
              });
            }
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_rounded),
                label: 'To-do'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Overview',
            ),
          ],
          iconSize: 30.0,
          currentIndex: currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: true,
        ),
      ),
      ConfettiWidget(
        confettiController: context.read<taskList>().confetti,
        shouldLoop: false,
        colors: const [Colors.green, Colors.purple, Colors.orange, Colors.blue, Colors.red, Colors.yellow],
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: 0,
        numberOfParticles: 45,
        minBlastForce: 10,
        maxBlastForce: 15,
        minimumSize: const Size(11,11),
        maximumSize: const Size(11,11),
        gravity: 0.3,
      )
    ],

    );
  }
}
