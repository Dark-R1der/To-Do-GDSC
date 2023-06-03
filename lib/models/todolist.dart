import 'package:to_do_gdsc/models/category.dart';

class ToDoItem {
  ToDoItem({
    required this.title,
    required this.category,
    required this.dateTime,
  });
  final String title;
  final Category category;
  final DateTime dateTime;
}
