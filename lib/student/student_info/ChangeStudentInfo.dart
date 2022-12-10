import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';

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
  @override
  Widget build(BuildContext context) {
    String introduction = "";
    String wantedteam = "";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: projectCRUD.getAttendeeInfo(),
    builder: (context, snapshot){
        if (snapshot.hasData){
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
                  onSaved: (value){
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
                  initialValue: snapshot.data['finding_team_info'].toString(),
                  onSaved: (value){
                    setState(() {
                      wantedteam = value as String;
                    });
                  },
                ),
                //add contact
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () async{
                      _formkey.currentState!.save();
                      projectCRUD.setIntro(introduction);
                      projectCRUD.setWantedTeam(wantedteam);
                      Navigator.pop(context);

                },
                    child: const Text("등록"),
                ),
              ],
            ),
          );
        }
        else{
          return CircularProgressIndicator();
        }
       }
      ),
    );
  }
}

