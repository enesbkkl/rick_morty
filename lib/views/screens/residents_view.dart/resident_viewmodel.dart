import 'package:flutter/material.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/services/api_service.dart';

class ResidentViewmodel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  List<CharacterModel> _residents = [];
  List<CharacterModel> get residents => _residents;

  void getResidents(List residentUrlList) async {
    _residents = await _apiService.getCharactersFromUrlList(
      residentUrlList.map((e) => e.toString()).toList(),
    );
    notifyListeners();
  }
}
