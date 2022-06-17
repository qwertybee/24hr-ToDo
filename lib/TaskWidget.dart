import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/providers/taskList.dart';

class TaskCard extends StatefulWidget {
  final String text;
  final int currTask;

  const TaskCard({required this.text, required this.currTask});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isDone = false;
  int counter = 86400;
  Timer? timer;

  Color getTextColor(bool textToBeAssessed) {
    if (!isDone) return Colors.black;
    return Colors.grey;
  }

  TextDecoration getTextStyle(bool textToBeAssessed) {
    if (!isDone) return TextDecoration.none;
    return TextDecoration.lineThrough;
  }

  Color getTimerColor(bool textToBeAssessed) {
    if (textToBeAssessed == false) { // check if checkbox still unticked
      if ((counter/3600).ceil() <= 1) return Colors.red;
      else if ((counter/3600).ceil() <= 6) return Colors.orange;
      else if ((counter/3600).ceil() > 6) return Colors.green;
    }
    return Colors.grey; // completed
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (counter > 0) {
          setState(() {
            counter--;
          });
        } else {
          setState(() {
            timer?.cancel();
            // delete expired tasks thats been up for 24hrs
            context.read<taskList>().taskDayExpired(widget.currTask);
          });
        }
      });
  }

  @override
  void initState() {
    // call timer here once since in build() it get re-rendered and messes up w timer
    super.initState();
    startTimer();
  }

  void playConfettiOrNot(bool isDone) {
    if (isDone) {
      context.read<taskList>().confetti.play();
      Future.delayed(const Duration(seconds: 1), (){
        // if without delay it wouldnt play at all cos too fast
        context.read<taskList>().confetti.stop();
      });
    }
  }

  void showDeferDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context, 'OK');
      },
    );
    Widget deferButton = TextButton(
      child: const Text("Defer"),
      onPressed:  () {
        context.read<taskList>().storeDeferredTasks(widget.currTask);
        Navigator.pop(context, 'OK');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text(
        "Defer Task", style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
      ),
      content: Text("Would you like to defer task '${widget.text}' to tomorrow instead?",
        style: const TextStyle(fontSize: 18),),
      actions: [
        cancelButton,
        deferButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
    onLongPress: () { // defer task to another day
        if (!isDone) {
          showDeferDialog(context);
        }
      },
    onTap: () { // maybe suggest to show time when the widget
      // (not checkbox widget) is tapped instead so it does two separate jobs
        setState(() {
          isDone = !isDone;
        });
        context.read<taskList>().setBoolAct(widget.currTask, !isDone);
        context.read<taskList>().setBoolComp(widget.currTask, isDone);
        playConfettiOrNot(isDone);
      },
      leading: Checkbox(
        value: isDone,
        onChanged: (value) {
          setState(() {
            isDone = !isDone;
          });
          context.read<taskList>().setBoolAct(widget.currTask, !isDone);
          context.read<taskList>().setBoolComp(widget.currTask, isDone);
          playConfettiOrNot(isDone);
        },
      ),
      title: RichText(
        text: TextSpan(
          text: widget.text,
          style: TextStyle(
              color: getTextColor(isDone),
              decoration: getTextStyle(isDone),
              fontSize: 21.0
          ),
          children: [
            TextSpan(text: (counter > 0) ? ' \u2022 ${(counter/3600).ceil()}${'h'}' : "",
            style: TextStyle(color: getTimerColor(isDone), fontSize: 19.0)),
            ],
        ),
      ),
    );
  }
}
