import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/providers/taskList.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Timer? timer;
  final List<String> monthName = ["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
  static var startWeek;
  static var endWeek;
  final infoIcons = [
    Icons.calendar_today_rounded,
    Icons.format_list_bulleted_rounded,
    Icons.rotate_right_rounded,
    Icons.pause_circle_outline_rounded,
    Icons.task_alt_rounded,
    Icons.cancel_rounded
  ];
  final infoIconsColor = [
    Colors.grey, Colors.grey,Colors.blue, Colors.orange, Colors.green, Colors.red
  ];
  final infoSummaryTitle = ["Weekly", "Tasks", "Active", "Deferral", "Completed", "Expired"];
  final infoSummary = [
    "Displays the current week's starting date and ending date",
    "task(s) you've added so far within the week",
    "currently active task(s)",
    "deferred task(s) will be available as active task(s) tomorrow",
    "task(s) you've completed so far within the week",
    "task(s) that wasn't completed within the 24-hour timeframe this week"
  ];

  void showInfoSummary(String titleInfo, String aboutInfo, var info) {
    showDialog(
        context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          titleInfo, style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
        ),
        content: Text("$info $aboutInfo", style: const TextStyle(fontSize: 18),),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text("Close"))
        ],
      )
    );
  }

  DateTime getDate (DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  String startWeekday(DateTime currentDate) {
    var startDate = getDate(currentDate.subtract(Duration(days: currentDate.weekday - 1)));
    var startMonth = startDate.month;
    var startDay = startDate.day;
    return "$startMonth $startDay";
  }

  void checkIfNewWeek() {
    DateTime currDate = DateTime.now();
    String currentDate = "${currDate.month} ${currDate.day}";
    String startOfNewWeekday = startWeekday(currDate);
    debugPrint(startOfNewWeekday);
    // check if new weekday matches current date, if so, trigger week expiration func
    if (startOfNewWeekday == currentDate) {
      context.read<taskList>().taskWeekExpired();
    }
  }

  void setupNewWeekRange() {
    DateTime now = DateTime.now();
    var startDate = getDate(now.subtract(Duration(days: now.weekday - 1)));
    var startMonth = monthName[startDate.month-1];
    var startDay = startDate.day;
    var endDate = getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
    var endMonth = monthName[endDate.month-1];
    var endDay = endDate.day;
    startWeek = "$startMonth $startDay  -";
    endWeek = "$endMonth $endDay";
  }

  @override
  void initState() {
    super.initState();
    // give date of start of week and end of week
    setupNewWeekRange();
  }

  @override
  Widget build(BuildContext context) {
    checkIfNewWeek();
    var info = [
      startWeek,
      context.watch<taskList>().taskLst.length,
      context.watch<taskList>().boolAct.where((x) => x == true).length,
      context.watch<taskList>().boolDefer.where((x) => x == true).length,
      context.watch<taskList>().boolComp.where((x) => x == true).length,
      context.watch<taskList>().boolExp.where((x) => x == true).length,
    ];
    var infoDisplays = [endWeek, "tasks", "active", "deferred","completed","expired"];
    return ListView(
      children: List.generate(
          infoDisplays.length,
              (index) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 13.0
                ),
                leading: Icon(infoIcons[index],
                  color: infoIconsColor[index],
                size: 27.0),
                title: Text("${info[index]}  ${infoDisplays[index]}",
                style: const TextStyle(
                    fontSize: 20.0
                ),
              ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline_rounded),
                  color: Colors.blueAccent,
                  onPressed: () {
                    showInfoSummary("About ${infoSummaryTitle[index]}", infoSummary[index], "${(index == 0) ? "" : info[index]}");
                    },
                ),
            )
          ),
        );
  }
}
