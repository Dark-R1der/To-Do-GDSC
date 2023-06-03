import 'package:flutter/material.dart';

enum Categories {
  personal,
  home,
  work,
  outside,
  other
}

class Category {
  const Category(this.title, this.color);
  final String title;
  final Color color;
}
