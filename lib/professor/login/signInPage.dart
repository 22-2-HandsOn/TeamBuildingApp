import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team/helper/helper_function.dart';

class SignInPageP extends StatefulWidget {
  const SignInPageP({Key? key}) : super(key: key);

  @override
  State<SignInPageP> createState() => _SignInPagePState();
}

class _SignInPagePState extends State<SignInPageP> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String username = '';
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
            "로그인",
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
                        keyboardType: TextInputType.emailAddress,
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "이메일 형식이 아닙니다.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "학교이메일",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력하세요.";
                          }
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
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size.fromHeight(40)),
                      child: Text(
                        "로그인",
                        style: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () async {
                        _tryValidation();
                        try {
                          final newUser =
                              await _authentication.signInWithEmailAndPassword(
                                  email: userEmail, password: userPassword);

                          if (newUser.user != null) {
                            await HelperFunctions.saveUserLoggedInStatus(true);
                            await HelperFunctions.saveUserIDSF(
                                FirebaseAuth.instance.currentUser!.uid);
                            await HelperFunctions.saveUserNameSF(username);
                            await HelperFunctions.saveUserEmailSF(userEmail);
                            Navigator.of(context)
                                .pushNamed("/toProjectlistPage");
                            // 테스트를 위해 projectAddPage와 연결
                            // Navigator.of(context)
                            //     .pushNamed("/toProjectAddPage");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "잘못된 이메일 혹은 비밀번호입니다.",
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
