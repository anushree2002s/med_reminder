import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_reminder_app/global_block.dart';
import 'package:medicine_reminder_app/pages/front_page/sign_in_page.dart';
// import 'package:medicine_reminder_app/pages/new_entry/new_entry_block.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:medicine_reminder_app/pages/new_entry/new_medicine_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  tz.initializeTimeZones();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //root of the app
  GlobalBlock? globalBlock;

  @override
  void initState() {
    globalBlock = GlobalBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBlock>.value(
      value: globalBlock!,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          //added sizer for automatically adapting UI to different screen sizes
          return MaterialApp(
            title: 'Medication Reminder',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Color.fromARGB(255, 243, 244, 248),
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    iconTheme: IconThemeData(
                        color: Color.fromARGB(255, 243, 51, 163), size: 20),
                    titleTextStyle: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 243, 51, 163),
                        fontStyle: FontStyle.normal,
                        fontSize: 18.sp)),
                textTheme: TextTheme(
                    headlineLarge: GoogleFonts.aBeeZee(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 243, 51, 163)),
                    titleSmall: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 243, 51, 163)),
                    headlineMedium: GoogleFonts.aBeeZee(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 243, 51, 163),
                        letterSpacing: 1.0),
                    headlineSmall: GoogleFonts.aBeeZee(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 243, 51, 163),
                    ),
                    bodySmall: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Color(0xFFC5BDCD),
                    ),
                    titleMedium: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                    labelMedium: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.green)),
                inputDecorationTheme: const InputDecorationTheme(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 172, 163, 163),
                            width: 0.7)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 172, 163, 163))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 172, 163, 163)))),
                //customizing the time picker
                timePickerTheme: TimePickerThemeData(
                    backgroundColor: Color.fromARGB(255, 243, 244, 248),
                    hourMinuteColor: Color.fromARGB(255, 86, 72, 93),
                    hourMinuteTextColor: Color.fromARGB(255, 243, 244, 248),
                    dayPeriodColor: Color.fromARGB(255, 86, 72, 93),
                    dayPeriodTextColor: Color.fromARGB(255, 243, 244, 248),
                    dialBackgroundColor: Color.fromARGB(255, 86, 72, 93),
                    dialHandColor: Color.fromARGB(255, 57, 157, 184),
                    dialTextColor: Color.fromARGB(255, 243, 244, 248),
                    entryModeIconColor: Color.fromARGB(255, 89, 193, 189),
                    dayPeriodTextStyle: GoogleFonts.aBeeZee(fontSize: 8.sp))),
            home: SignInScreen(),
          );
        },
      ),
    );
  }
}
