import 'package:flutter/material.dart';

// 가장 먼저 실행되는 페이지입니다
class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/toInitialPageT');
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Text("학생",
                    style: TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 50,
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/toInitialPage');
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.lightBlueAccent,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Text("교수",
                    style: TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 50,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
