import 'package:cloud_firestore/cloud_firestore.dart';
// projects 관련 CRUD func

Future addProject(final projectData, final attendeeDataList) async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  final studentsRef = db.collection('students');
  final attendeesRef = db.collection('attendees');

  final stus = await studentsRef.get();
  final stuMap = stus.docs
      .map((stu) => {"stu_doc_id": stu.id, "stu_id": stu["stu_id"]})
      .toList();
  List<String> stuIdMap =
      stuMap.map((stu) => stu["stu_id"].toString()).toList();
  // print(stuMap);
  // print(stuIdMap);

  // projects 문서 추가
  final projectDoc = await db.collection('projects').add(projectData);

  attendeeDataList.forEach((attendee) {
    int ind = stuIdMap.indexOf(attendee["stu_id"].toString());
    if (ind != -1) {
      // 이미 회원가입한 학생의 경우
      print("이미 회원가입한 학생 : " + attendee["name"].toString());
      attendee["stu_doc_id"] = stuMap.elementAt(ind)["stu_doc_id"].toString();

      // students에 새 플젝 정보 추가해주기
      batch.update(studentsRef.doc(attendee["stu_doc_id"]), {
        "projects": FieldValue.arrayUnion([
          {
            "doc_id": projectDoc.id,
            "name": projectData["name"],
            "isFinished": false,
            "deadline": projectData["deadline"]
          }
        ])
      });
    }

    attendee["project_doc_id"] = projectDoc.id.toString();

    batch.set(attendeesRef.doc(), attendee);
  });

  await batch.commit();
  print("생성 완료");
}
