import 'package:flutter/foundation.dart';

class ShowSettings with ChangeNotifier {

  bool _showSettings = false;

  bool get showSettings => _showSettings;

  set showSettings(bool show){

    _showSettings = show;
    notifyListeners();

  }

}