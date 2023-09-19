import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder_app/global_block.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({super.key, required this.medicine});
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBlock _globalBlock = Provider.of<GlobalBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            ExtendedSection(medicine: widget.medicine),
            Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  //open alert dialog box,+global bloc, later
                  //cool its working
                  openAlertBox(context, _globalBlock);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Color.fromARGB(255, 243, 244, 248)),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }
  // delete a medicine from memory

  openAlertBox(BuildContext context, GlobalBlock _globalBlock) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text(
            'Delete This Reminder?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () {
                //add the delete function
                _globalBlock.removeMedicine(widget.medicine);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;
  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Syrup') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syrup2.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Capsule') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/capsule.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Tablet') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet2.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    }
    //in case of no medicine type icon selection
    return Hero(
      tag: medicine!.medicineName! + medicine!.medicineType!,
      child: Icon(
        Icons.error,
        color: Color.fromARGB(255, 89, 193, 189),
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //lets try another one
        //ok same here, the same problem, imma solve later
        makeIcon(7.h),
        SizedBox(
          width: 2.w,
        ),
        Column(
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: 'Medicine Name',
                    fieldInfo: medicine!.medicineName!),
              ),
            ),
            MainInfoTab(
                fieldTitle: 'Dosage',
                fieldInfo: medicine!.dosage == 0
                    ? 'Not Specified'
                    : "${medicine!.dosage} mg"),
          ],
        )
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Text(
              fieldInfo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type ',
          fieldInfo: medicine!.medicineType! == 'None'
              ? 'Not Specified'
              : medicine!.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Interval',
          fieldInfo:
              'Every ${medicine!.interval} hours | ${medicine!.interval == 24 ? "One time a day" : "${(24 / medicine!.interval!).floor()} times a day"}',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo:
              '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Color(0xFF56485D),
                  ),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Color.fromARGB(255, 89, 193, 189),
                ),
          ),
        ],
      ),
    );
  }
}
