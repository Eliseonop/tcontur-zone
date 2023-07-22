import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  DrawerSections _currentPage = DrawerSections.location;

  DrawerSections get currentPage => _currentPage;

  void setCurrentPage(DrawerSections page) {
    _currentPage = page;
    notifyListeners();
  }
}

enum DrawerSections {
  location,
  web,
}
