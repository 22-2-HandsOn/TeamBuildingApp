import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';

class AddNewTeam extends StatelessWidget {
  String projectID;
  AddNewTeam(this.projectID);

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
          "팀 추가",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      body: AddNewTeamForm(projectID),
    );
  }
}

class AddNewTeamForm extends StatefulWidget {
  String projectID;
  AddNewTeamForm(this.projectID);

  @override
  State<AddNewTeamForm> createState() => _AddNewTeamFormState(projectID);
}

class _AddNewTeamFormState extends State<AddNewTeamForm> {
  final _formkey = GlobalKey<FormState>();
  String projectID;
  _AddNewTeamFormState(this.projectID);
  late final ProjectCRUD projectCRUD = ProjectCRUD(projectID);
  String stu_id = "";
  Future _getstu_id() async{
     final result = await projectCRUD.getstu_id();
     setState(() {
       stu_id = result;
     });
  }
  @override
  void initState() {
    super.initState();
    _getstu_id();
  }
  @override
  Widget build(BuildContext context) {
    String teamName = "";
    String introduction = "";
    String finding_member_info = "";
    List members = [stu_id];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    Text('팀 이름', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value){
                        setState(() {
                          teamName = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('팀 소개', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 6,
                      onSaved: (value){
                        setState(() {
                          introduction = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('원하는 팀원', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 6,
                      onSaved: (value){
                        setState(() {
                          finding_member_info = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),


                    ElevatedButton(
                      onPressed: () async{
                        _formkey.currentState!.save();
                        projectCRUD.addTeam(teamName, introduction, finding_member_info, members);
                        Navigator.pop(context);
                      },
                      child: const Text("등록"),
                    ),
                  ],
                ),
                ),
              );
            }
          }