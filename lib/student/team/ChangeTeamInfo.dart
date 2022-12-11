import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';

class ChangeTeamInfo extends StatelessWidget {
  String projectID;
  ChangeTeamInfo(this.projectID);

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
          "팀 정보 수정",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      body: TeamInfoForm(projectID),
    );
  }
}

class TeamInfoForm extends StatefulWidget {
  String projectID;
  TeamInfoForm(this.projectID);

  @override
  State<TeamInfoForm> createState() => _TeamInfoFormState(projectID);
}

class _TeamInfoFormState extends State<TeamInfoForm> {
  final _formkey = GlobalKey<FormState>();
  String projectID;
  _TeamInfoFormState(this.projectID);
  late final ProjectCRUD projectCRUD = ProjectCRUD(projectID);
  @override
  Widget build(BuildContext context) {
    String name = "";
    String introduction = "";
    String finding_member_info = "";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
          future: projectCRUD.getTeamInfo(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              return Form(
                key: _formkey,
                child: ListView(
                  children: [
                    Text('팀 명', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      initialValue: snapshot.data['name'].toString(),
                      onSaved: (value){
                        setState(() {
                          name = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('팀 소개 수정', style: TextStyle(fontSize: 20)),
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
                    Text('원하는 팀원', style: TextStyle(fontSize: 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 6,
                      initialValue: snapshot.data['finding_member_info'].toString(),
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
                        projectCRUD.setTeamName(name);
                        projectCRUD.setTeamIntro(introduction);
                        projectCRUD.setWantedMember(finding_member_info);
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

