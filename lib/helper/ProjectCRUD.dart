import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ProjectCRUD {
  String projectID;
  ProjectCRUD(this.projectID);
  late final attendeesCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("attendees");
  late final studentCollection = FirebaseFirestore.instance
      .collection('students')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  late final teamsCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("teams");

  Future getstu_id() async {
    final snapshot = await studentCollection.get();
    var data = snapshot.data() as Map<String, dynamic>;
    return data['stu_id'].toString();
  }

  Future getAttendeeInfo() async {
    final snapshot = await attendeesCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return dataElement;
      }
    }
  }

  Future addAttendeeReply(String comment_id, String content) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        if (attendeesCollection
            .doc(doc.id)
            .collection('comments').doc(comment_id).collection('reply').get().toString().length == 0){
          final b = await attendeesCollection
              .doc(doc.id)
              .collection('comments').doc(comment_id).collection('reply').add({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
        else {
          final a = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc(comment_id).collection('reply').doc().set({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
      }
    }
  }

  Future updateAttendeeReply(String comment_id, String reply_id, String content) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final a = await attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .doc(comment_id)
            .collection('replys')
            .doc(reply_id)
            .update({'content': content});
      }
    }
  }

  Future deleteAttendeeReply(String comment_id, String reply_id) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        DocumentReference delete = await attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .doc(comment_id)
            .collection('replys')
            .doc(reply_id);
        await delete.delete();
      }
    }
  }

  Future getAttendeeReply(String comment_id) async {
    var stu_id = await getstu_id();
    var attendee_id = await getAttendeeID();
    List data = [];
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        QuerySnapshot snapshot2 = await attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .doc(comment_id)
            .collection('replys')
            .get();
        for (var doc2 in snapshot2.docs) {
          data.add(doc2.data());
        }
      }
    }
    return data;
  }

  Future addAttendeeComment(String content, bool isSecret) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        if (attendeesCollection
            .doc(doc.id)
            .collection('comments').get().toString().length == 0){
          final b = await attendeesCollection
              .doc(doc.id)
              .collection('comments').add({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'isSecret': isSecret,
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
        else {
          final a = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc()
              .set({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'isSecret': isSecret,
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
      }
    }
  }

  Future addTeamComment(String content, bool isSecret) async {
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String,dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i=0;i<dataElement.length;i++ ) {
        if (dataElement[i].toString() == stu_id) {
          if (teamsCollection
              .doc(doc.id)
              .collection('comments')
              .get()
              .toString()
              .length == 0) {
            final b = await teamsCollection
                .doc(doc.id)
                .collection('comments').add({
              'author_doc_id': attendeeId,
              'name': attendee["name"],
              'isSecret': isSecret,
              'content': content,
              'timestamp': FieldValue.serverTimestamp()
            });
          }
          else {
            final a = await teamsCollection
                .doc(doc.id)
                .collection('comments')
                .doc()
                .set({
              'author_doc_id': attendeeId,
              'name': attendee["name"],
              'isSecret': isSecret,
              'content': content,
              'timestamp': FieldValue.serverTimestamp()
            });
          }
        }
      }
    }
  }

  Future updateAttendeeComment(String content, String comment_id) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final a = await attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .doc(comment_id)
            .update({'content': content});
      }
    }
  }

  Future getAttendeeComment() async {
    var stu_id = await getstu_id();
    var attendee_id = await getAttendeeID();
    List data = [];
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        QuerySnapshot snapshot2 =
        await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          data.add(doc2.data());
        }
      }
    }
    return data;
  }

  Future getTeamComment() async {
    var stu_id = await getstu_id();
    List data = [];
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      List dataElement = mapp['members'];
      for (int i=0;i<dataElement.length;i++ ) {
        if (dataElement[i].toString() == stu_id) {
          QuerySnapshot snapshot2 =
          await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            data.add(doc2.data());
          }
        }
      }
    }
    print(data);
    return data;
  }

  Future deleteAttendeeComment(String comment_id) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        DocumentReference delete = await attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .doc(comment_id);
        await delete.delete();
      }
    }
  }

  Future getTeamInfo() async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    }
    return {"isNull": true};
  }

  Future addTeam(String teamname, String introduction,
      String finding_member_info, List members) async {
    final teamDoc = await teamsCollection.doc().set({
      'name': teamname,
      'introduction': introduction,
      'finding_member_info': finding_member_info,
      'members': members,
      'isFinished': false,
    });
  }

  Future getAttendeeID() async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get("stu_id");
      if (dataElement == stu_id) {
        return doc.id;
      }
    }
  }

  Future setStudentIntro(String intro) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        attendeesCollection.doc(doc.id).update({'introduction': intro});
      }
    }
  }

  Future setContactInfo(List<dynamic> contacts) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        print(contacts);
        attendeesCollection.doc(doc.id).update({'contact_infos': contacts});
      }
    }
  }

  Future setWantedTeam(String intro) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        attendeesCollection.doc(doc.id).update({'finding_team_info': intro});
      }
    }
  }

  Future setWantedMember(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'finding_member_info': intro});
        }
      }
    }
  }

  Future setTeamIntro(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'introduction': intro});
        }
      }
    }
  }

  Future setTeamName(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'name': intro});
        }
      }
    }
  }

  Future getattendeedoc(String comment) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return doc.id;
      }
    }
  }
}
