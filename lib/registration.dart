import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:registration_local_db/home.dart';
import 'package:registration_local_db/main.dart';
import 'package:registration_local_db/model/data_model.dart';

class RegistrationPage extends StatefulWidget {
  String? name;
  String? birthDate;
  String? mobileNo;
  String? gender;
  int? dataKey;

  RegistrationPage(
      {Key? key,
      this.name,
      this.birthDate,
      this.mobileNo,
      this.gender,
      this.dataKey})
      : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedGender;
  Box<DataModel>? dataBox;
  int? key;

  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    nameController.text = widget.name ?? '';
    dateController.text = widget.birthDate ?? '';
    mobileController.text = widget.mobileNo ?? '';
    selectedGender = widget.gender;
    key = widget.dataKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Full Name'),
                controller: nameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Name';
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(hintText: 'Birthdate'),
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Birthdate';
                  }
                },
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now())
                      .then((selectedDate) {
                    if (selectedDate != null) {
                      var formattedDate =
                          DateFormat('dd-MM-yyyy').format(selectedDate);
                      dateController.text = formattedDate;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(hintText: 'Mobile Number'),
                controller: mobileController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                },
              ),
              SizedBox(height: 30),
              Text(
                'Select Gender',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListTile(
                  title: Text("Male"),
                  leading: Radio(
                      value: "male",
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value.toString();
                        });
                      }),
                ),
                ListTile(
                  title: Text("Female"),
                  leading: Radio(
                      value: "female",
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value.toString();
                        });
                      }),
                )
              ]),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: ()  {
                  if (isValidData(
                      name: nameController.text,
                      birthdate: dateController.text,
                      mobileNumber: mobileController.text,
                    gender: selectedGender,
                      )) {
                    final String name = nameController.text;
                    final String birthDate = dateController.text;
                    final String mobile = mobileController.text;
                    final String gender = selectedGender!;
                    DataModel data = DataModel(
                        name: name,
                        birthDate: birthDate,
                        mobileNo: mobile,
                        gender: gender);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  name: nameController.text,
                                  birthDate: dateController.text,
                                  mobileNo: mobileController.text,
                                  gender: selectedGender,
                                )));
                    if (key != null) {
                      dataBox!.put(key, data);
                    } else {
                      dataBox!.add(data);
                    }
                    nameController.clear();
                    dateController.clear();
                    mobileController.clear();
                  }
                  // if(_formKey.currentState!.validate() && selectedGender!.isNotEmpty){
                  //   final String name = nameController.text;
                  //   final String birthDate = dateController.text;
                  //   final String mobile = mobileController.text;
                  //   final String gender = selectedGender!;
                  //   DataModel data = DataModel(
                  //       name: name,
                  //       birthDate: birthDate,
                  //       mobileNo: mobile,
                  //       gender: gender);
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => MyHomePage(
                  //             name: nameController.text,
                  //             birthDate: dateController.text,
                  //             mobileNo: mobileController.text,
                  //             gender: selectedGender,
                  //           )));
                  //   if(key != null){
                  //     dataBox!.put(key, data);
                  //   }else{
                  //     dataBox!.add(data);
                  //   }
                  //   nameController.clear();
                  //   dateController.clear();
                  //   mobileController.clear();
                  // }
                },
                child: key != null ? Text('Save Changes') : Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidData(
      {required String name,
      required String birthdate,
      required String mobileNumber,
       String? gender
      }) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter Name')));
      return false;
    } else if (birthdate.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter Birthdate')));
      return false;
    } else if (mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter Mobile Number')));
      return false;
    } else if (gender == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select Gender')));
      return false;
    }
    return true;
  }
}
