import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:to_do_gdsc/data/categories.dart';
import 'package:to_do_gdsc/models/category.dart';
import 'package:to_do_gdsc/models/todolist.dart';
import 'package:to_do_gdsc/widgets/tiles.dart';

import '../services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoItem> toDoList = [];
  Services _s = Services();
  void _removeItem(String documentId) {
    _s.deleteTodoItem(documentId);
    readTasks();
  }

  Future<void> readTasks() async {
    List<ToDoItem> temp = await _s.read() as List<ToDoItem>;
    setState(() {
      toDoList = temp;
    });
  }

  @override
  void initState() {
    readTasks();
    super.initState();
  }

  void _showBottomSheet(BuildContext context) {
    String textTitle = '';
    TextEditingController dateinput = TextEditingController();
    var _selectedCategory = categories[Categories.home]!;
    showModalBottomSheet(
      backgroundColor: Color(0xFFefe6dd),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Add bottom padding
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                    onChanged: (value) {
                      textTitle = value;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  DropdownButtonFormField(
                    value: _selectedCategory,
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(category.value.title),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: dateinput,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFef8354),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () async {
                      ToDoItem newItem = ToDoItem(
                          title: textTitle,
                          category: _selectedCategory,
                          dateTime: DateTime.parse(dateinput.text),
                          id: textTitle +
                              DateTime.parse(dateinput.text).toString());

                      _s.addTask(newItem);

                      await readTasks();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: SizedBox(
          height: 20,
          width: 20,
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        title: const Text(
          'DooIt',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.black,
      ),
      body: toDoList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/emptyimg.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Create your first to-do list...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                itemBuilder: (context, index) => tiles(
                  title: toDoList[index].title,
                  category: toDoList[index].category,
                  date: toDoList[index].dateTime,
                  onRemove: () => _removeItem(toDoList[index].id),
                ),
                separatorBuilder: ((context, index) => SizedBox(
                      height: 20,
                    )),
                itemCount: toDoList.length,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context); // Call the _showBottomSheet function
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
