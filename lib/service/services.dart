import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:to_do_gdsc/data/categories.dart';
import 'package:to_do_gdsc/models/category.dart';
import 'package:to_do_gdsc/models/todolist.dart';

class Services extends GetxController {
  Future<void> addTask(ToDoItem newItem) async {
    Map<String, dynamic> obj = {
      "name": newItem.title,
      "category": newItem.category.title,
      "date": newItem.dateTime,
      "id": newItem.id,
      "ispined": newItem.ispined
    };
    String docId = newItem.id;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference tasksRef = firestore.collection("tasks").doc(docId);
    await tasksRef.set(obj);
  }

  Future<List> read() async {
    List<ToDoItem> tasks = [];
    final snapshot = await FirebaseFirestore.instance.collection("tasks").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for (var element in documents) {
      dynamic category = element["category"];
      if (category == "Personal") {
        category = Categories.Personal;
      } else if (category == "Finance") {
        category = Categories.Finance;
      } else if (category == "Work") {
        category = Categories.Work;
      } else {
        category = Categories.Other;
      }

      tasks.add(ToDoItem(
          title: element["name"],
          category: categories[category]!,
          dateTime: element["date"].toDate(),
          id: element["name"] + element["date"].toDate().toString(),
          ispined: element["ispined"] as bool));
    }
    return tasks;
  }

  Future<void> deleteTodoItem(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
        firestore.collection('tasks').doc(documentId);
    await documentReference.delete();
  }
}
