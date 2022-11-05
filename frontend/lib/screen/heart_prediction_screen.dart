import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/predict_model.dart';
import 'package:frontend/screen/team_member_screen.dart';
import 'package:frontend/widget/dropdown_input_widget.dart';
import 'package:frontend/widget/error_snackbar_widget.dart';
import 'package:frontend/widget/loading_widget.dart';
import 'package:frontend/widget/text_input_widget.dart';

import '../course_list.dart';

class HeartPredictionScreen extends StatefulWidget {
  const HeartPredictionScreen({Key? key}) : super(key: key);

  @override
  State<HeartPredictionScreen> createState() => _HeartPredictionScreenState();
}

class _HeartPredictionScreenState extends State<HeartPredictionScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController highController = TextEditingController();
  TextEditingController lowController = TextEditingController();
  TextEditingController openController = TextEditingController();
  DropdownEditingController<String> genderController =
      DropdownEditingController();
  DropdownEditingController<String> courseController =
      DropdownEditingController();
  DropdownEditingController<String> yearController =
      DropdownEditingController();
  DropdownEditingController<String> gpaController = DropdownEditingController();
  DropdownEditingController<String> maritalController =
      DropdownEditingController();
  DropdownEditingController<String> anxietyController =
      DropdownEditingController();
  DropdownEditingController<String> panicController =
      DropdownEditingController();
  DropdownEditingController<String> treatmentController =
      DropdownEditingController();

  late String? age = ageController.text;
  late String? high = highController.text;
  late String? low = lowController.text;
  late String? open = openController.text;
  late String? gender = genderController.value;
  late String? course = courseController.value;
  late String? year = yearController.value;
  late String? gpa = gpaController.value;
  late String? marital = maritalController.value;
  late String? anxiety = anxietyController.value;
  late String? panic = panicController.value;
  late String? treatment = treatmentController.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prediction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              App.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInputSymptom(context),
            buildPredictButton(context),
            TeamMemberScreen(),
          ],
        ),
      ),
    );
  }

  Widget buildInputSymptom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildGenderInputBox(context),
        buildAgeInputBox(context),
        buildCourseInputBox(context),
        buildYearInputBox(context),
        buildGPAInputBox(context),
        buildMaritalInputBox(context),
        buildAnxietyInputBox(context),
        buildPanicInputBox(context),
        buildTreatmentInputBox(context),
      ],
    );
  }

  Widget buildGenderInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Gender',
      controller: genderController,
      dropdownData: const ['Male', 'Female'],
    );
  }

  Widget buildCourseInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Course',
      controller: genderController,
      dropdownData: courseList,
    );
  }

  Widget buildYearInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Year of Study',
      controller: genderController,
      dropdownData: const ['Year 1', 'Year 2', 'Year 3', 'Year 4'],
    );
  }

  Widget buildGPAInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'GPA',
      controller: genderController,
      dropdownData: const [
        '0 - 1.99',
        '2.00 - 2.49',
        '2.50 - 2.99',
        '3.00 - 3.49',
        '3.50 - 4.00'
      ],
    );
  }

  Widget buildMaritalInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Marital Status',
      controller: genderController,
      dropdownData: const ['Yes', 'No'],
    );
  }

  Widget buildAnxietyInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Do you have anxiety?',
      controller: genderController,
      dropdownData: const ['Yes', 'No'],
    );
  }

  Widget buildPanicInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Do you have Panic attack?',
      controller: genderController,
      dropdownData: const ['Yes', 'No'],
    );
  }

  Widget buildTreatmentInputBox(BuildContext context) {
    return DropdownInputWidget(
      title: 'Did you seek any specialist for a treatment',
      controller: genderController,
      dropdownData: const ['Yes', 'No'],
    );
  }

  Widget buildAgeInputBox(BuildContext context) {
    return TextInputWidget(
      title: 'Age',
      controller: ageController,
    );
  }

  Widget buildPredictButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          onPressed: () async {
            // await Api.get('severity');
            // showResult();

            if (course != "" &&
                gender != "" &&
                age != "" &&
                year != "" &&
                gpa != "" &&
                marital != "" &&
                anxiety != "" &&
                panic != "" &&
                treatment != "") {
              showResult();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            }
          },
          child: const Text('Predict'),
        ),
      ),
    );
  }

  Future<PredictModel> postRequest() async {
    int cgpa = 0;
    if (gpa == "0 - 1.99") {
      cgpa = 0;
    } else if (gpa == "2.00 - 2.49") {
      cgpa = 1;
    } else if (gpa == "2.50 - 2.99") {
      cgpa = 2;
    } else if (gpa == "3.00 - 3.49") {
      cgpa = 3;
    } else {
      cgpa = 4;
    }

    var data = {
      "Choose your gender": gender == 'Male' ? 1 : 0,
      "Age": age,
      "What is your course?": course,
      "Your current year of Study": year,
      "What is your CGPA?": cgpa,
      "Marital status": marital == 'Yes' ? 1 : 0,
      "Do you have Anxiety?": anxiety == 'Yes' ? 1 : 0,
      "Do you have Panic attack?": panic == 'Yes' ? 1 : 0,
      "Did you seek any specialist for a treatment?": treatment == 'Yes' ? 1 : 0
    };
    print(data);

    return await Api.post('/api/predict', data);
  }

  void showResult() {
    Widget okButton = TextButton(
      child: const Text("CLOSE"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<PredictModel>(
          future: postRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                title: Text(
                  "Prediction",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your result: ${snapshot.data!.predict!}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                actions: [
                  okButton,
                ],
              );
            }
            return const LoadingWidget();
          },
        );
      },
    );
  }
}
