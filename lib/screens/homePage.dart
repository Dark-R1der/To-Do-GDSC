import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:to_do_gdsc/data/categories.dart';
import 'package:to_do_gdsc/models/category.dart';
import 'package:to_do_gdsc/models/todolist.dart';
import 'package:to_do_gdsc/widgets/button.dart';
import 'package:to_do_gdsc/widgets/pin.dart';
import 'package:to_do_gdsc/widgets/tiles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoItem> toDoList = [];
  List<ToDoItem> toDoListPinned = [];

  void _removeItem(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void _removeItemPinned(int index) {
    setState(() {
      toDoListPinned.removeAt(index);
    });
  }

  Future<dynamic> showDia() {
    String textTitle = '';
    TextEditingController dateinput = TextEditingController();
    var _selectedCategory = categories[Categories.Personal]!;
    int _selectedButtonIndex = 0;
    bool pin = false;
    void updatePin(bool contd) {
      pin = contd;
    }

    void _updateSelectedButtonIndex(int index) {
      setState(() {
        _selectedButtonIndex = index;
      });
      print(_selectedButtonIndex);
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text(
                'Task',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              Spacer(),
              PinWidget(
                updatePin: updatePin,
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(20)),
            height: 270,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    textTitle = value;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                Spacer(),
                TextField(
                  controller: dateinput,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    icon: Icon(Icons.calendar_today),
                    hintText: "Enter Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateinput.text = formattedDate;
                      });
                    }
                  },
                ),
                Spacer(),
                ColorChangingButton(
                  onButtonSelected: _updateSelectedButtonIndex,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (_selectedButtonIndex == 0) {
                    _selectedCategory = categories[Categories.Personal]!;
                  }
                  if (_selectedButtonIndex == 1) {
                    _selectedCategory = categories[Categories.Work]!;
                  }
                  if (_selectedButtonIndex == 2) {
                    _selectedCategory = categories[Categories.Finance]!;
                  }
                  if (_selectedButtonIndex == 3) {
                    _selectedCategory = categories[Categories.Other]!;
                  }
                  // print(_selectedButtonIndex);
                  ToDoItem newItem = ToDoItem(
                    title: textTitle,
                    category: _selectedCategory,
                    dateTime: DateTime.parse(dateinput.text),
                  );
                  if (pin) {
                    toDoListPinned.add(newItem);
                  }
                  toDoList.add(newItem);
                });
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget showDialogBox() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 90,
          ),
          Image.asset('assets/emptyimg.png'),
          const SizedBox(
            height: 60,
          ),
          Text(
            'Create your first to-do list...',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showDia();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              'New List',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
            leading: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                'assets/appBarLogo.png',
              ),
            ),
            title: Text(
              'DooIt',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorPadding: EdgeInsets.symmetric(horizontal: 16.0),
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "All List",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Pinned",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            toDoList.isEmpty
                ? showDialogBox()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      itemBuilder: (context, index) => tiles(
                        title: toDoList[index].title,
                        category: toDoList[index].category,
                        date: toDoList[index].dateTime,
                        onRemove: () => _removeItem(index),
                      ),
                      separatorBuilder: ((context, index) => SizedBox(
                            height: 20,
                          )),
                      itemCount: toDoList.length,
                    ),
                  ),
            toDoListPinned.isEmpty
                ? showDialogBox()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      itemBuilder: (context, index) => tiles(
                        title: toDoListPinned[index].title,
                        category: toDoListPinned[index].category,
                        date: toDoListPinned[index].dateTime,
                        onRemove: () => _removeItemPinned(index),
                      ),
                      separatorBuilder: ((context, index) => SizedBox(
                            height: 20,
                          )),
                      itemCount: toDoListPinned.length,
                    ),
                  ),
          ],
        ),
        floatingActionButton: toDoList.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () {
                  showDia();
                },
                child: Icon(Icons.add),
              ),
      ),
    );
  }
}
