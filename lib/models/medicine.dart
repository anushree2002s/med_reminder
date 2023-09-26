
// represents a property of a medicine object. final keyword indicates that these variables can only be assigned once, typically in the class's constructor.
class Medicine {
  final List<dynamic>? notificationIDs;
  final String? medicineName;
  final int? dosage;
  final String? medicineType;
  final int? interval;
  final String? startTime;

//this is constructor for medicine object
  Medicine(
      {this.notificationIDs,
      this.medicineName,
      this.dosage,
      this.medicineType,
      this.interval,
      this.startTime});


 
 //getters
 //eg getName gets medicine name
 // the ! operator is used to assert that the nullable properties like medicineName, dosage, medicineType, interval, startTime, and notificationIDs will not be null when accessed using these getters.

  String get getName => medicineName!;
  int get getDosage => dosage!;
  String get getType => medicineType!;
  int get getInterval => interval!;
  String get getStartTime => startTime!;
  List<dynamic> get getIDs => notificationIDs!;

//converts to json
  Map<String, dynamic> toJson() {
    return {
      'ids': notificationIDs,
      'name': medicineName,
      'type': medicineType,
      'dosage': dosage,
      'interval': interval,
      'start': startTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      medicineType: parsedJson['type'],
      dosage: parsedJson['dosage'],
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],

    );
  }
}