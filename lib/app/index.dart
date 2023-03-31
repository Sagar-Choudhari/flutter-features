import 'package:features/app/table_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppData.dart';

class TablePdf extends StatefulWidget {
  const TablePdf({Key? key}) : super(key: key);

  @override
  State<TablePdf> createState() => _TablePdfState();
}

class _TablePdfState extends State<TablePdf> {
  List<String> _genders = [];

  List<String> appData = [];

  TextEditingController tName = TextEditingController();
  TextEditingController tGender = TextEditingController();
  TextEditingController tDateInput = TextEditingController();
  TextEditingController tPhone = TextEditingController();
  TextEditingController tAddress = TextEditingController();

  @override
  initState() {
    tDateInput.text = "";
    super.initState();
    _getDataFromFirestore();
    _loadDataFromSharedPreferences();
  }

/*  final String name = '';
  final String gender = '';
  final String dob = '';
  final String phone = '';
  final String address = '';*/

  CollectionReference users = FirebaseFirestore.instance.collection('appData');

  Future<void> addData(AppData appData) async {
    final docUser = FirebaseFirestore.instance.collection('appData').doc();
    appData.id = docUser.id;
    final json = appData.toJson();
    await docUser.set(json);

    // var id = users
    // return users
    //     .add({
    //       'name': appData.name,
    //       'gender': appData.gender,
    //       'dob': appData.dob,
    //       'phone': appData.phone,
    //       'address': appData.address
    //     })
    //     .then((value) => debugPrint("User Added"))
    //     .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Name'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _genders.isEmpty
                            ? const CircularProgressIndicator()
                            : DropdownButtonFormField<String>(
                                // value: _selectedGender,
                                hint: const Text('Select Item'),
                                borderRadius: BorderRadius.circular(15),
                                elevation: 10,
                                dropdownColor: Colors.grey[300],
                                items: _genders
                                    .map((gender) => DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(gender),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    tGender.text = value!;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tDateInput,
                        //editing controller of this TextField
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            debugPrint(pickedDate.toString());
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            debugPrint(formattedDate);
                            setState(() {
                              tDateInput.text = formattedDate;
                            });
                          } else {}
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tPhone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Phone'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tAddress,
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Address',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          String name1 = tName.text;
                          String gender1 = tGender.text;
                          String dob1 = tDateInput.text;
                          String phone1 = tPhone.text;
                          String address1 = tAddress.text;
                          var data = AppData(
                              name: name1,
                              gender: gender1,
                              dob: dob1,
                              phone: phone1,
                              address: address1);
                          addData(data);
                          tName.clear();
                          tGender.clear();
                          tDateInput.clear();
                          tPhone.clear();
                          tAddress.clear();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal:
                                    MediaQuery.of(context).size.width / 3)),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: MediaQuery.of(context).size.width / 9)),
                onPressed: () {
                  _getNewDataFromFirestore();
                },
                child: const Text('Download to Shared Preferences & show it in table')),
          ],
        ),
      ),
    );
  }

  Future<void> _getDataFromFirestore() async {
    final collection = FirebaseFirestore.instance.collection('gender');
    final documents = await collection.orderBy('count').get();
    final genders =
        documents.docs.map((doc) => doc['name'].toString()).toList();
    // debugPrint('From firestore::: ${genders.toString()}');
    setState(() {
      _genders = genders;
    });
    _saveDataToSharedPreferences(genders);
  }

  Future<void> _saveDataToSharedPreferences(List<String> genders) async {
    final prefs = await SharedPreferences.getInstance();
    // debugPrint('save to share::: ${genders.toString()}');
    await prefs.setStringList('genders', genders);
  }

  Future<void> _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final genders = prefs.getStringList('genders');
    // debugPrint('load from share::: ${genders.toString()}');
    if (genders != null) {
      setState(() {
        _genders = genders;
      });
    }
  }

  Future<void> _getNewDataFromFirestore() async {
    final collection = FirebaseFirestore.instance.collection('appData');
    final documents = await collection.orderBy('name').get();
    final appdata =
        documents.docs.map((doc) => AppData.fromJson(doc.data())).toList();

    List<AppData> dataList = [];

    for (var data in appdata) {
      // debugPrint('Name: ${data.name}, Gender: ${data.gender}, Dob: ${data.dob}, Phone: ${data.phone}, Address: ${data.address}');
      dataList.add(data);
      _saveNewDataToSharedPreferences(data);
    }
    gotoTable(dataList);
  }

  Future<void> _saveNewDataToSharedPreferences(AppData appdata) async {
    final prefs = await SharedPreferences.getInstance();
    final List<AppData> appDataList = [appdata];
    for (final data in appDataList) {
      debugPrint(
          'Name: ${data.name}, Gender: ${data.gender}, Dob: ${data.dob}, Phone: ${data.phone}, Address: ${data.address}');
      await prefs.setStringList(data.id,
          [data.name, data.gender, data.dob, data.phone, data.address]);
    }

    // debugPrint('saveToShared::::: ${appdata.phone.toString()}');
    // await prefs.setStringList(appdata.id, appdata);
    // _loadNewDataFromSharedPreferences(appdata);
  }
  // Future<void> _loadNewDataFromSharedPreferences(AppData appdata) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // final data = prefs.getStringList('genders');
  //   // debugPrint('loadFromShare::::: ${data.toString()}');
  //   final List<AppData> appDataList = [appdata];
  //   for (final aPPData in appDataList) {
  //     final data1 = prefs.getStringList(aPPData.id);
  //     debugPrint('loadFromShare::::: ${data1.toString()}');
  //   }
  // }

  gotoTable(List<AppData> appdata1) {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) {
    //   return const LoadData();
    // }));
    debugPrint('gotoTable run');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TableData(title: 'App Data', appdata: appdata1)));
    // runApp(MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: TableData(
    //     title: 'App Data',
    //     appdata: appdata1,
    //   ),
    // ));
  }

/*
  Stream<List<AppData>> readData() => FirebaseFirestore.instance
      .collection('appData')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => AppData.fromJson(doc.data())).toList());
*/
}
