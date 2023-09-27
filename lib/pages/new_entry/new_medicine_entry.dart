import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_reminder_app/global_block.dart';
import 'package:medicine_reminder_app/models/errors.dart';
import 'package:medicine_reminder_app/pages/home_page.dart';
import 'package:medicine_reminder_app/pages/new_entry/new_entry_block.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/convert_time.dart';
import '../../models/medicine.dart';
import '../../models/medicine_type.dart';
import '../success_screen/success_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NewMedicationEntryPage extends StatefulWidget {
  const NewMedicationEntryPage({super.key});

  @override
  State<NewMedicationEntryPage> createState() => _NewMedicationEntryPageState();
}

class _NewMedicationEntryPageState extends State<NewMedicationEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late NewEntryBlock _newEntryBlock;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBlock.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _newEntryBlock = NewEntryBlock();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }

  String getMedicineTypeName(String medicineType) {
    switch (medicineType) {
      case MedicineType.syrup:
        return 'Syrup';
      case MedicineType.capsule:
        return 'Capsule';
      case MedicineType.tablet:
        return 'Tablet';
      default:
        return ''; // Handle any other cases if needed
    }
  }

  String getMedicineTypeIcon(String medicineType) {
    switch (medicineType) {
      case MedicineType.syrup:
        return 'assets/icons/syrup2.svg';
      case MedicineType.capsule:
        return 'assets/icons/capsule.svg';
      case MedicineType.tablet:
        return 'assets/icons/tablet2.svg';
      default:
        return ''; // Handle any other cases if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Medication'),
      ),
      body: Provider<NewEntryBlock>.value(
        value: _newEntryBlock,
        child: Padding(
          padding: EdgeInsets.all(1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(
                title: 'Name of Medication',
                isRequired: true,
              ),
              TextFormField(
                maxLength: 20,
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blue),
              ),
              const PanelTitle(
                title: 'Dosage in mg',
                isRequired: false,
              ),
              TextFormField(
                maxLength: 8,
                controller: dosageController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blue),
              ),
              SizedBox(
                height: 1.h,
              ),
              const PanelTitle(title: "Medicine Type", isRequired: false),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: StreamBuilder<String>(
                  //new entry block
                  stream: _newEntryBlock.selectedMedicineType,

                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MedicineTypeColumn(
                          medicineType: MedicineType.syrup,
                          name: getMedicineTypeName(MedicineType.syrup),
                          iconValue: getMedicineTypeIcon(MedicineType.syrup),
                          isSelected: snapshot.data == MedicineType.syrup,
                        ),
                        MedicineTypeColumn(
                          medicineType: MedicineType.capsule,
                          name: getMedicineTypeName(MedicineType.capsule),
                          iconValue: getMedicineTypeIcon(MedicineType.capsule),
                          isSelected: snapshot.data == MedicineType.capsule,
                        ),
                        MedicineTypeColumn(
                          medicineType: MedicineType.tablet,
                          name: getMedicineTypeName(MedicineType.tablet),
                          iconValue: getMedicineTypeIcon(MedicineType.tablet),
                          isSelected: snapshot.data == MedicineType.tablet,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const PanelTitle(title: "Interval Selection", isRequired: true),
              const IntervalSelection(),
              const PanelTitle(title: 'Starting Time', isRequired: true),
              const SelectTime(),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: SizedBox(
                  width: 80.w,
                  height: 8.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 57, 157, 184),
                      shape: const StadiumBorder(),
                    ),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Color.fromARGB(255, 243, 244, 248)),
                      ),
                    ),
                    onPressed: () async {
                      //add medicine
                      //some validation
                      //go to success screen
                      String? medicineName;
                      int? dosage;
                      int? intervalN;
                      String? medicationType;
                      String? startTimeT;

                      print("medicine type :$medicationType");

                      //medicine name
                      if (nameController.text == "") {
                        _newEntryBlock.submitError(EntryError.nameNull);
                        return;
                      }
                      if (nameController.text != " ") {
                        medicineName = nameController.text;
                      }
                      //dosage
                      if (dosageController.text == "") {
                        dosage = 0;
                      }
                      if (dosageController.text != " ") {
                        dosage = int.parse(dosageController.text);
                      }

                      if (_newEntryBlock.selectedMedicineType!.value != null) {
                        medicationType =
                            _newEntryBlock.selectedMedicineType!.value;
                      } else {
                        // Handle the case where no medicine type is selected.
                        // You can set a default value or display an error message.
                        return;
                      }

                      if (_newEntryBlock.selectIntervals!.value != null) {
                        intervalN = _newEntryBlock.selectIntervals!.value;
                      }

                      // // Calculate startTimeT based on the selected time
                      if (_newEntryBlock.selectedTimeOfDay$!.value != 'None') {
                        startTimeT = _newEntryBlock.selectedTimeOfDay$!.value;
                        // } else {
                        //   // Handle the case where no start time is selected.
                        //   // You can set a default value or display an error message.
                        //   return;
                      }

                      for (var medicine in globalBlock.medicineList$!.value) {
                        if (medicineName == medicine.medicineName) {
                          _newEntryBlock.submitError(EntryError.nameDuplicate);
                          return;
                        }
                      }
                      if (_newEntryBlock.selectIntervals!.value == 0) {
                        _newEntryBlock.submitError(EntryError.interval);
                        return;
                      }
                      if (_newEntryBlock.selectedTimeOfDay$!.value == 'None') {
                        _newEntryBlock.submitError(EntryError.startTime);
                        return;
                      }
                      CollectionReference _medication =
                          FirebaseFirestore.instance.collection('medication');

                      await _medication.add({
                        'name': medicineName,
                        'dosage': dosage,
                        'interval': intervalN,
                        'medicationType': medicationType,
                        'startTime': startTimeT
                      });
                      String medicineType =
                          _newEntryBlock.selectedMedicineType!.value;

                      int interval = _newEntryBlock.selectIntervals!.value;
                      String startTime =
                          _newEntryBlock.selectedTimeOfDay$!.value;

                      List<int> intIDs =
                          makeIDs(24 / _newEntryBlock.selectIntervals!.value);
                      List<String> notificationIDs =
                          intIDs.map((i) => i.toString()).toList();

                      Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime);
                      nameController.clear();
                      dosageController.clear();
                      //update medicine list via global block
                      globalBlock.updateMedicineList(newEntryMedicine);
                      //schedule notification
                      scheduleNotification(newEntryMedicine);
                      //go to success page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessScreen()));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBlock.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("Please enter the name of medicine");
          break;
        case EntryError.nameDuplicate:
          displayError("Medicine already exists");
          break;
        case EntryError.dosage:
          displayError("Please enter the dosage of medicine");
          break;
        case EntryError.interval:
          displayError("Please select the interval of reminder");
          break;
        case EntryError.startTime:
          displayError("Please select the starting time of reminder");
          break;
        default:
      }
    });
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 89, 193, 189),
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000));
    }
    return ids;
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          await onSelectNotification(payload);
        });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: onSelectNotification,
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime![0] + medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2] + medicine.startTime![3]);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      importance: Importance.max,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      if (hour + (medicine.interval! * i) > 23) {
        hour = hour + (medicine.interval! * i) - 24;
      } else {
        hour = hour + (medicine.interval! * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        medicine.medicineType.toString() != MedicineType.none.toString()
            ? 'It is time to take your ${medicine.medicineType!.toUpperCase()}, according to the schedule'
            : 'Please take your medicine',
        Time(hour, minute, 0),
        platformChannelSpecifics,
      );
      hour = ogValue;
    }
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay?> _selectTime() async {
    final NewEntryBlock newEntryBlock =
        Provider.of<NewEntryBlock>(context, listen: false);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;

        // Update state using provider
        newEntryBlock.updateTime(convertTime(_time.hour.toString()) +
            convertTime(_time.minute.toString()));
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 57, 157, 184),
              shape: const StadiumBorder()),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
                _clicked == false
                    ? "Select Time"
                    : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Color.fromARGB(255, 243, 244, 248))),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBlock newEntryBlock = Provider.of<NewEntryBlock>(context);
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.green),
          ),
          DropdownButton(
            iconEnabledColor: Color.fromARGB(255, 89, 193, 189),
            dropdownColor: Color.fromARGB(255, 243, 244, 248),
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text('Select interval',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Color.fromARGB(255, 57, 157, 184),
                        ))
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color.fromARGB(255, 243, 51, 163)),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                  newEntryBlock.updateInterval(newVal);
                },
              );
            },
          ),
          Text(
            _selected == 1 ? "hour" : "hours",
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected});

  final String medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBlock newEntryBlock = Provider.of<NewEntryBlock>(context);
    return GestureDetector(
      onTap: () {
        //selects the medicine type
        //creating a new block to add new entry
        newEntryBlock.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 25.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: isSelected
                    ? Color.fromARGB(255, 89, 193, 189)
                    : Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                top: 1.h,
                bottom: 1.h,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: SvgPicture.asset(iconValue,
                      height: 7.h,
                      color: isSelected
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 89, 193, 189)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromARGB(255, 89, 193, 189)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: isSelected
                          ? Colors.white
                          : Color.fromARGB(255, 89, 193, 189)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});

  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 1.h,
      ),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
                text: isRequired ? "*" : "",
                style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
