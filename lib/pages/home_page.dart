import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicine_reminder_app/global_block.dart';
import 'package:medicine_reminder_app/pages/front_page/sign_in_page.dart';
import 'package:medicine_reminder_app/pages/medicine_details/medicine_details.dart';
import 'package:medicine_reminder_app/pages/new_entry/new_medicine_entry.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import '../models/medicine.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Waasah",
            style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 243, 51, 163))),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 30,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(1.h),
        child: Column(
          children: [
            const TopContainer(),
            SizedBox(
              height: 1.h,
            ),
            //flexible makes the widget take as much space it needs
            Flexible(
              child: BottomContainer(),
            ),
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          //REDIRECTS TO NEW PAGE,
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewMedicationEntryPage()));
        },
        child: SizedBox(
          width: 20.w,
          height: 10.h,
          child: Card(
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.add_outlined,
              color: Colors.white,
              size: 50.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
              bottom:
                  1.h), //this is from SIZER. It will take a 2% of screen height
          child: Text(
            'Have you taken your medication?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'Set a reminder NOW!!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        StreamBuilder<List<Medicine>>(
            stream: globalBlock.medicineList$,
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              );
            }),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    //use conditions to show saved data
    // return Center(
    //   child: Text(
    //     'No medicines currently',
    //     textAlign: TextAlign.center,
    //     style: Theme.of(context).textTheme.titleMedium,
    //   ),
    //
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);

    return StreamBuilder(
      stream: globalBlock.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //if no data is saved
          return Container();
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Medicine',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        } else {
          return GridView.builder(
            padding: EdgeInsets.only(top: 1.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return MedicineCard(
                medicine: snapshot.data![index],
              );
            },
          );
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;
  //for getting the current details of the saved items

  //first we need to get the medicine type icon
  //lets make a function

  Hero makeIcon(double size) {
    //here is the bug, the capital word of the first letter
    //lets fix
    if (medicine.medicineType == 'syrup') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syrup2.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'capsule') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/capsule.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'tablet') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet2.svg',
          color: Color.fromARGB(255, 89, 193, 189),
          height: 7.h,
        ),
      );
    }
    //in case of no medicine type icon selection
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child: Icon(
        Icons.error,
        color: Color.fromARGB(255, 89, 193, 189),
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        //go to details activity with animation, later

        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine: medicine),
                  );
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(2.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            //call the MakeIcons() function here to display the everyday medicine in front
            makeIcon(7.h),
            const Spacer(),
            //animation later
            Hero(
              tag: medicine.medicineName!,
              child: Text(medicine.medicineName!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            //time interval data with conditions
            Text(
                medicine.interval == 1
                    ? "Every ${medicine.interval} hour"
                    : "Every ${medicine.interval} hour",
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
    );
  }
}
