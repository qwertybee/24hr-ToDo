import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class taskList with ChangeNotifier {
  final confetti = ConfettiController();
  List<String> taskLst = [];
  List<bool> boolAct = [];
  List<bool> boolDefer = [];
  List<bool> boolComp = [];
  List<bool> boolExp = [];
  List<int> boolDeferIndex = [];

  void addDefaultBool(String addTodo) {
    taskLst.add(addTodo);
    boolAct.add(true);
    boolDefer.add(false);
    boolComp.add(false);
    boolExp.add(false);
    notifyListeners();
  }
  void setBoolAct(int index, bool status) {
    boolAct[index] = status;
    notifyListeners();
  }
  void setBoolComp(int index, bool status) {
    boolComp[index] = status;
    notifyListeners();
  }
  void setBoolExp(int index, bool status) {
    boolExp[index] = status;
    notifyListeners();
  }
  void storeDeferredTasks(int index) {
    boolDefer[index] = true;
    boolDeferIndex.add(index);
    notifyListeners();
  }
  void setDeferTasks() { // new day, check for deferred tasks to set up
    for (int i = 0; i < boolDeferIndex.length; i++) {
      taskLst.add(taskLst[boolDeferIndex[i]]);
      boolDefer[boolDeferIndex[i]] = false;
      boolDeferIndex.clear();
    }
    notifyListeners();
  }
  void taskDayExpired(int index) {// after 24 hours
    // if active aka incomplete
    // set active and expired to false, and expired to true
    // leave completed alone as they have to be in weekly overview
    // taskLst.removeAt(index);
    boolAct[index] = false;
    boolExp[index] = true;
    notifyListeners();
  }
  void taskWeekExpired() {// after 1 week
    // delete every list up to the latest (true) expired
    int allLatestExp = boolExp.where((x) => x == true).length;
    taskLst.removeRange(0, allLatestExp);
    boolAct.removeRange(0, allLatestExp);
    boolComp.removeRange(0, allLatestExp);
    boolExp.removeRange(0, allLatestExp);
    notifyListeners();
  }
}