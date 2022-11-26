import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPageS extends StatefulWidget {
  const SignUpPageS({Key? key}) : super(key: key);

  @override
  State<SignUpPageS> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPageS> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String studentid = '';
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(
            "회원가입",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (() {
            FocusScope.of(context).unfocus();
          }),
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "다시 입력하세요.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userName = value!;
                        }),
                        onChanged: (value) {
                          userName = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "이름",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        validator: ((value) {
                          if (value!.isEmpty || value.length != 8) {
                            return "다시 입력하세요.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          studentid = value!;
                        }),
                        onChanged: (value) {
                          studentid = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "학번",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "이메일 형식에 맞게 입력하세요";
                          }
                          return null;
                        }),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "학교 이메일",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: ((value) {
                          // if (value!.isEmpty || value.length < 8) {
                          //   return "Password must be at least 8 characters long";
                          // }
                          return null;
                        }),
                        onSaved: ((value) {
                          userPassword = value!;
                        }),
                        onChanged: (value) {
                          userPassword = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "비밀번호",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "비밀번호재확인",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 40),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                            minimumSize: const Size.fromHeight(40)),
                        child: Text(
                          "가입하기",
                          style: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () async {
                          _tryValidation();

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                                    email: userEmail, password: userPassword);
                            await FirebaseFirestore.instance.collection('student').doc(newUser.user!.uid).set({
                              'userName' : userName,
                              'studentID' : studentid,
                            });

                            if (newUser.user != null) {
                              Navigator.of(context)
                                  .pushNamed("/toProjectlistPage");
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "잘못된 이메일, 패스워드입니다.",
                                style: TextStyle(
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                            ));
                          }
                        })
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
