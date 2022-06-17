import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_1/TaskWidget.dart';
import 'package:provider/provider.dart';
import 'package:project_1/providers/taskList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController eCtrl = TextEditingController();
  int index = -1;

  void showInputDialog() { // dialog for adding new task
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("New task", style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
          content: TextField(
            // capitalize keyboard first letter
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: eCtrl,
            onSubmitted: (text) {
              if (text.isNotEmpty && (text.trim().isNotEmpty)) {
                context.read<taskList>().addDefaultBool(text);
                eCtrl.clear();
                setState(() {
                  index++;
                });
                Navigator.pop(context);
              }
            },
            decoration: const InputDecoration.collapsed(
                hintText: "Add new task...",
                hintStyle: TextStyle(fontSize: 18.0)
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xfafafafa),
    body: Column(
      children: [
        if (context.watch<taskList>().taskLst.isEmpty) // if no task display pic
          Container(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              children: [
                Lottie.asset("images/meditation.json"),
                const Text(
                    "   Hooray, no task!\nYou can rest now :D",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        Expanded(
        child: ListView.builder( // else show tasks
          shrinkWrap: true,
          itemCount: context.watch<taskList>().taskLst.length,
          itemBuilder: (context, index) {
            return TaskCard( // display the active tasks (i.e. no expired, deferrals)
              text: context.watch<taskList>().taskLst[index],
              currTask: index,
            );
          },
        ),
        )
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showInputDialog();
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.green,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
    ),
    );
  }
}
