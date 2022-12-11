import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';
import './MyTeamInfo.dart';

class AddNewTeam extends StatelessWidget {
  String projectID;
  AddNewTeam(this.projectID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
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
  Future _getstu_id() async {
    final result = await projectCRUD.getstu_id();
    setState(() {
      stu_id = result;
    });
  }

  // _navigateAndDisplaySelection(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MyTeamInfoPage(projectID)),
  //   );
  // }

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
    bool isNowLoading = false;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formkey,
        child: ListView(
          children: [
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "팀 이름 ",
                  labelStyle: const TextStyle(
                    fontFamily: "GmarketSansTTF",
                    fontSize: 16,
                  )),
              onSaved: (value) {
                setState(() {
                  teamName = value as String;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              minLines: 6,
              maxLines: null,
              onSaved: (value) {
                setState(() {
                  introduction = value as String;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "팀 소개",
                labelStyle: const TextStyle(
                  fontFamily: "GmarketSansTTF",
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "원하는 팀원",
                labelStyle: const TextStyle(
                  fontFamily: "GmarketSansTTF",
                  fontSize: 16,
                ),
              ),
              minLines: 6,
              maxLines: null,
              onSaved: (value) {
                setState(() {
                  finding_member_info = value as String;
                });
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.lightBlueAccent,
                  disabledBackgroundColor: Colors.lightBlueAccent.shade100,
                  minimumSize: const Size.fromHeight(40)),
              child: Text(
                "팀 생성",
                style: TextStyle(
                  fontFamily: "GmarketSansTTF",
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                _formkey.currentState!.save();

                try {
                  await projectCRUD.addTeam(
                      teamName, introduction, finding_member_info, members);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "팀 생성이 완료되었습니다.",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ));

                  Navigator.pop(context);
                  // _navigateAndDisplaySelection(context);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "팀 생성에 실패하였습니다.",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
