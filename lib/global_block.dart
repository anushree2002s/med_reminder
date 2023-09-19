import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/medicine.dart';

class GlobalBlock {
  BehaviorSubject<List<Medicine>>? _medicineList$;
  BehaviorSubject<List<Medicine>>? get medicineList$ => _medicineList$;

  GlobalBlock() {
    //initializes the medicine list
    _medicineList$ = BehaviorSubject<List<Medicine>>.seeded([]);
    makeMedicineList();
  }
//add a new medicine to the list
//blocklist to store the medicine list temporarily
  Future updateMedicineList(Medicine newMedicine) async {
    var blockList = _medicineList$!.value;
    blockList.add(newMedicine);
    _medicineList$!.add(blockList);

    Map<String, dynamic> tempMap = newMedicine.toJson();
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    String newMedicineJson = jsonEncode(tempMap);
    List<String> medicineJsonList = [];
    if (sharedUser.getStringList('medicines') == null) {
      medicineJsonList.add(newMedicineJson);
    }
    sharedUser.setStringList('medicines', medicineJsonList);
  }

  Future removeMedicine(Medicine tobeRemoved) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> medicineJsonList = [];

    var blockList = _medicineList$!.value;
    blockList.removeWhere(
        (medicine) => medicine.medicineName == tobeRemoved.medicineName);

    for (int i = 0; i < (24 / tobeRemoved.interval!).floor(); i++) {
      flutterLocalNotificationsPlugin.cancel(int.parse(tobeRemoved.notificationIDs![i]));
    }
    if (blockList.isNotEmpty) {
      for (var blockMedicine in blockList) {
        String medicineJson = jsonEncode(blockMedicine.toJson());
        medicineJsonList.add(medicineJson);
      }
    }
    sharedUser.setStringList('medicines', medicineJsonList);
    _medicineList$!.add(blockList);
  }

//Future keyword in Dart is used to represent a potential value or error that will be available at some point in the future. used in async functions. used to work with operations that may take some time to complete, such as I/O operations, network requests, and more.
  Future makeMedicineList() async {
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    List<String>? jsonList = sharedUser.getStringList('medicines');
    List<Medicine> prefList = [];

    if (jsonList == null) {
      return;
    } else {
      for (String jsonMedicine in jsonList) {
        dynamic userMap = jsonDecode(jsonMedicine);
        Medicine tempMedicine = Medicine.fromJson(userMap);
        prefList.add(tempMedicine);
      }
      //state update
      _medicineList$!.add(prefList);
    }
  }

// The dispose method is used to close the _medicineList$ when it's no longer needed, which releases any resources associated with it.
  void dispose() {
    _medicineList$!.close();
  }
}
