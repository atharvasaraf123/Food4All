import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Donate_Food extends StatefulWidget {
  @override
  _Donate_FoodState createState() => _Donate_FoodState();
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class _Donate_FoodState extends State<Donate_Food> {
  DateTime selectedDateTime;
  TextEditingController dateController = TextEditingController();
  var gradesRange = RangeValues(0, 100);

  bool pressed = false;

  Widget _displayDateTime(selectedDateTime) {
    return Center(
        child: Text(
      "Selected  $selectedDateTime",
      style: TextStyle(fontSize: 15),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Donate Food Details',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: '* Pickup where ?',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                        suffixIcon: Icon(Icons.my_location_outlined)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Food Item(s)',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
                        suffixIcon: Icon(Icons.fastfood)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: dateController,
                    onTap: () => setState(() {
                      pressed = true;

                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        // print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        selectedDateTime = date;
                        dateController.text = date.toString();
                      }, currentTime: DateTime(2020, 01, 01, 12, 00, 00));
                    }),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Prefered Time',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
                        suffixIcon: Icon(Icons.calendar_today)),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Quantity: 500 persons',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RangeSlider(
                  min: 0,
                  max: 100,
                  divisions: 20,
                  labels:
                      RangeLabels('${gradesRange.start}', '${gradesRange.end}'),
                  values: gradesRange,
                  onChanged: (RangeValues value) {
                    setState(() {
                      gradesRange = value;
                    });
                  },
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Positioned(
                    bottom: 0,
                    child: Material(

                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.orangeAccent.shade400,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () => {},
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
