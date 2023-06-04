import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_gdsc/data/categories.dart';
import 'package:to_do_gdsc/models/category.dart';
import 'package:to_do_gdsc/models/todolist.dart';

class Services {
  Future<void> addTask(ToDoItem newItem) async {
    Map<String, dynamic> obj = {
      "name": newItem.title,
      "category": newItem.category.title,
      "date": newItem.dateTime,
      "id": newItem.id
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
    documents.forEach((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      dynamic category = element["category"];
      if (category == "Home") {
        category = Categories.home;
      } else if (category == "Work") {
        category = Categories.work;
      } else if (category == "Personal") {
        category = Categories.personal;
      } else if (category == "Outside") {
        category = Categories.outside;
      } else {
        category = Categories.other;
      }

      tasks.add(ToDoItem(
          title: element["name"],
          category: categories[category]!,
          dateTime: element["date"].toDate(),
          id: element["name"] + element["date"].toDate().toString()));
    });
    return tasks;
  }

  Future<void> deleteTodoItem(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
        firestore.collection('tasks').doc(documentId);
    await documentReference.delete();
  }
}
