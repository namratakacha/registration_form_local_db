import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:registration_local_db/model/data_model.dart';
import 'package:registration_local_db/registration.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  String? name;
  String? birthDate;
  String? mobileNo;
  String? gender;
  var hiveBox;

  MyHomePage(
      {Key? key,
      this.name,
      this.birthDate,
      this.mobileNo,
      this.gender,
      this.hiveBox})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<DataModel> dataBox;

  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
        centerTitle: true,
      ),
      body: Container(
        child: ValueListenableBuilder(
          valueListenable: dataBox.listenable(),
          builder: (context, Box<DataModel> userData, _) {
            List<int> keys = userData.keys.cast<int>().toList();
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final int key = keys[index];
                    final DataModel? dataItem = userData.get(key);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                'Name :- ${dataItem!.name}',
                                style: titleStyle(),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'DoB :- ${dataItem.birthDate}',
                                style: titleStyle(),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Mobile No. :- ${dataItem.mobileNo}',
                                style: titleStyle(),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Gender :- ${dataItem.gender}',
                                style: titleStyle(),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage(
                                                      name: dataItem.name,
                                                      birthDate:
                                                          dataItem.birthDate,
                                                      mobileNo:
                                                          dataItem.mobileNo,
                                                      gender: dataItem.gender,
                                                      dataKey: key,
                                                    )));
                                      },
                                      child: Text('Edit')),
                                  SizedBox(width: 40),
                                  ElevatedButton(
                                      onPressed: () {
                                        dataBox.delete(key);
                                      }, child: Text('Delete')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistrationPage()));
        },
        label: Text('Add data'),
      ),
    );
  }

  titleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }
}
