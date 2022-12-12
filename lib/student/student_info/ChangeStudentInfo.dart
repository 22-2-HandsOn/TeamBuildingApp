import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:form_validator/form_validator.dart';

class ChangeMyStudentInfo extends StatelessWidget {
  String projectID;
  ChangeMyStudentInfo(this.projectID);

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
          "내 정보 수정",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
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
  // final _contactChoices = ['이메일', '웹주소', '핸드폰'];

  List<dynamic> contacts = [];
  void _setContacts(List<String> title, List<String> content) {
    int length = title.length;
    setState(() {
      contacts = [];

      for (int i = 0; i < length; i++) {
        if (title[i] == '' || content[i] == '') {
          continue;
        }
        var temp = {"title": title[i], "content": content[i]};
        contacts.add(temp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String introduction = "";
    String wantedteam = "";

    // final validatoremail = ValidationBuilder().email().maxLength(50).build();
    // final validatorurl = ValidationBuilder().url().maxLength(100).build();
    // final validatorphone =
    //     ValidationBuilder().phone().minLength(11).maxLength(11).build();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: FutureBuilder(
          future: projectCRUD.getAttendeeInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formkey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: " 내 소개 ",
                          labelStyle: const TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          )),
                      minLines: 6,
                      maxLines: null,
                      initialValue: snapshot.data['introduction'].toString(),
                      onSaved: (value) {
                        setState(() {
                          introduction = value as String;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: " 원하는 팀 ",
                        labelStyle: const TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                        ),
                      ),
                      minLines: 6,
                      maxLines: null,
                      initialValue:
                          snapshot.data['finding_team_info'].toString(),
                      onSaved: (value) {
                        setState(() {
                          wantedteam = value as String;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text(
                            "  연락 방법  ",
                            style: const TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 11,
                                color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                          Container(width: 280, height: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                    Contacts(
                        contact_infos: snapshot.data["contact_infos"] != null
                            ? snapshot.data["contact_infos"]
                            : [],
                        setter: _setContacts),
                    const SizedBox(
                      height: 40,
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
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                            disabledBackgroundColor:
                                Colors.lightBlueAccent.shade100,
                            minimumSize: const Size.fromHeight(40)),
                        child: const Text("수정"),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            projectCRUD.setStudentIntro(introduction);
                            projectCRUD.setWantedTeam(wantedteam);
                            projectCRUD.setContactInfo(contacts);
                            Navigator.pop(context);
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

class Contacts extends StatefulWidget {
  final List<dynamic> contact_infos;
  final Function(List<String> title, List<String> content) setter;
  const Contacts({Key? key, required this.contact_infos, required this.setter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _contactInputState();
}

class _contactInputState extends State<Contacts> {
  List<String> title = [];
  List<String> content = [];

  @override
  void initState() {
    setState(() {
      widget.contact_infos.forEach((value) {
        title.add(value["title"]!);
        content.add(value["content"]!);
      });

      Future.delayed(Duration.zero, () {
        widget.setter(title, content);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(title);

    // TODO: implement build
    return ListView.builder(
        shrinkWrap: true,
        itemCount: title.length + 1,
        itemBuilder: (ctx, ind) {
          if (ind != title.length) {
            return Row(children: <Widget>[
              Flexible(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "종류",
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
                    hintStyle: const TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 12,
                    ),
                  ),
                  initialValue: title[ind],
                  onChanged: (value) {
                    setState(() {
                      title[ind] = value.trim();
                      widget.setter(title, content);
                    });
                  },
                ),
              ),
              const Text(
                "   :   ",
                style: TextStyle(
                    fontFamily: "GmarketSansTTF",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(
                flex: 6,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "내용",
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
                    hintStyle: const TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 12,
                    ),
                  ),
                  initialValue: content[ind],
                  onChanged: (value) {
                    setState(() {
                      content[ind] = value.trim();
                      print(value);
                      widget.setter(title, content);
                    });
                  },
                ),
              ),
              Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.remove, color: Colors.black38, size: 18),
                    onPressed: () {
                      setState(() {
                        title.removeAt(ind);
                        content.removeAt(ind);
                        widget.setter(title, content);
                      });
                    },
                  )),
            ]);
          } else {
            return TextButton(
              child: const Text(
                '+ 새 연락 방법 추가',
                style: TextStyle(
                  fontFamily: "GmarketSansTTF",
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                setState(() {
                  title.add("");
                  content.add("");
                });
              },
            );
          }
        });
  }
}
