import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team/initPage.dart';
import 'package:team/professor/login/initPageP.dart';
import 'package:team/professor/login/signInPage.dart';
import 'package:team/professor/login/signUpPage.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/student/login/initPage.dart';
import 'package:team/student/login/signInPage.dart';
import 'package:team/student/login/signUpPage.dart';
import 'package:team/Project/projectAddPage.dart';
import 'package:team/student/stuprojectList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // 폰트 크기 고정
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.78),
          );
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          //login
          '/': (context) => const InitPage(),
          // '/toPro_LoginPage': (context) => const loginInitPageP(),
          '/toPro_SignInPage': (context) => const SignInPageP(),
          '/toPro_SignUpPage': (context) => const SignUpPageP(),

          // '/toStu_LoginPage': (context) => const loginInitPageS(),
          '/toStu_SignInPage': (context) => const SignInPageS(),
          '/toStu_SignUpPage': (context) => const SignUpPageS(),

          //Project
          '/toProfProjectlistPage': (context) => const ProfProjectListPage(),
          '/toStuProjectlistPage': (context) => const StuProjectListPage(),
          '/toProjectAddPage': (context) =>
              const ProjectAddPage(), // *TODO : 이후 교수의 projectListPage에서 버튼 클릭을 통해 여기로 이동할 수 있도록 설정해야 함
        });
  }
}
