// import 'package:flutter/material.dart';
// import 'package:team/helper/helper_function.dart';
// import 'package:team/helper/DatabaseService.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class StuProjectListPage extends StatefulWidget {
//   const StuProjectListPage({Key? key}) : super(key: key);

//   @override
//   _StuProjectListPagestate createState() => _StuProjectListPagestate();
// }

// class _StuProjectListPagestate extends State<StuProjectListPage> {
//   @override
//   void initState() {
//     gettingUserData();
//     super.initState();
//   }

//   gettingUserData() async {}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.black87,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         backgroundColor: Colors.white,
//         title: const Text(
//           "팀원 신청 목록",
//           style: TextStyle(
//               color: Colors.black87,
//               fontFamily: "GmarketSansTTF",
//               fontSize: 20,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//           padding: const EdgeInsets.symmetric(vertical: 7),
//           child: projectlist()),
//     );
//   }

//   projectlist() {
//     return StreamBuilder(
//       // stream: ,
//       builder: (context, AsyncSnapshot snapshot) {
//         // make some checks
//         if (snapshot.hasData) {
//           //
//         } else {
//           return Center(
//             child: CircularProgressIndicator(color: Colors.lightBlueAccent),
//           );
//         }
//       },
//     );
//   }
// }
