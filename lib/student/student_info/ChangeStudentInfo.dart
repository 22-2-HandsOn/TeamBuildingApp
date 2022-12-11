import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:form_validator/form_validator.dart';

class ChangeMyStudentInfo extends StatelessWidget {
  String projectID;
  ChangeMyStudentInfo(this.projectID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: const Text(
          "내 정보 수정",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      body: StudentInfoForm(projectID),
    );
  }
}

class StudentInfoForm extends StatefulWidget {
  String projectID;
  StudentInfoForm(this.projectID);

  @override
  State<StudentInfoForm> createState() => _StudentInfoFormState(projectID);
}

class _StudentInfoFormState extends State<StudentInfoForm> {
  final _formkey = GlobalKey<FormState>();
  String projectID;
  _StudentInfoFormState(this.projectID);
  late final ProjectCRUD projectCRUD = ProjectCRUD(projectID);
  final _contactChoices = ['이메일', '웹주소', '핸드폰'];

  @override
  Widget build(BuildContext context) {
    String introduction = "";
    String wantedteam = "";
    String contactType1 = "";
    String email = "";
    String phone = "";
    String url1 = "";
    String url2 = "";
    String url3 = "";

    final validatoremail = ValidationBuilder().email().maxLength(50).build();
    final validatorurl = ValidationBuilder().url().maxLength(100).build();
    final validatorphone =
        ValidationBuilder().phone().minLength(11).maxLength(11).build();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
          future: projectCRUD.getAttendeeInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formkey,
                child: ListView(
                  children: [
                    Text('내 소개 수정', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 6,
                      initialValue: snapshot.data['introduction'].toString(),
                      onSaved: (value) {
                        setState(() {
                          introduction = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('원하는 팀 수정', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 6,
                      initialValue:
                          snapshot.data['finding_team_info'].toString(),
                      onSaved: (value) {
                        setState(() {
                          wantedteam = value as String;
                        });
                      },
                    ),
                    //add contact
                    const SizedBox(
                      height: 25,
                    ),
                    Text('Contacts (Optional)', style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 15,
                    ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: '이메일 주소',
                    //     hintText: '(Optional)',
                    //   ),
                    //   initialValue:
                    //       snapshot.data['contact_infos']['email'].toString(),
                    //   onSaved: (value) {
                    //     setState(() {
                    //       email = value as String;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: '핸드폰 번호',
                    //     hintText: '(Optional)',
                    //   ),
                    //   initialValue:
                    //       snapshot.data['contact_infos']['phone'].toString(),
                    //   onSaved: (value) {
                    //     setState(() {
                    //       phone = value as String;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: '웹주소 1',
                    //     hintText: '(Optional)',
                    //   ),
                    //   initialValue:
                    //       snapshot.data['contact_infos']['url1'].toString(),
                    //   onSaved: (value) {
                    //     setState(() {
                    //       url1 = value as String;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: '웹주소 2',
                    //     hintText: '(Optional)',
                    //   ),
                    //   initialValue:
                    //       snapshot.data['contact_infos']['url2'].toString(),
                    //   onSaved: (value) {
                    //     setState(() {
                    //       url2 = value as String;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: '웹주소 3',
                    //     hintText: '(Optional)',
                    //   ),
                    //   initialValue:
                    //       snapshot.data['contact_infos']['url3'].toString(),
                    //   onSaved: (value) {
                    //     setState(() {
                    //       url3 = value as String;
                    //     });
                    //   },
                    // ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        child: const Text("등록"),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            projectCRUD.setStudentIntro(introduction);
                            projectCRUD.setWantedTeam(wantedteam);
                            Navigator.pop(context);
                            Map<String, String> contacts = {
                              'email': email,
                              'phone': phone,
                              'url1': url1,
                              'url2': url2,
                              'url3': url3,
                            };
                            projectCRUD.setContactInfo(contacts);
                          }
                          ;
                        }),
                  ],
                ),
              );
            }
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.lightBlueAccent));
          }),
    );
  }
}
