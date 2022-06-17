import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1/PrimaryPage.dart';
import 'package:project_1/providers/taskList.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => taskList()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.libreFranklinTextTheme(
          Theme.of(context).textTheme,
        ),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green;
              }
              return Colors.grey;
            })
        ),
        // disables splash effect of clicking buttons
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: Primary(),
    );
  }
}