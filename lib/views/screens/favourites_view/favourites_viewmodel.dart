import 'package:flutter/material.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/services/api_service.dart';
import 'package:rick_morty/services/preferences_service.dart';

class FavouritesViewmodel extends ChangeNotifier {
  final _preferencesService = locator<PreferencesService>();
  final _apiService = locator<ApiService>();

  List<int> _favourites = [];

  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void getFavourites() async {
    _isLoading = true;
    notifyListeners();
    _favourites = _preferencesService.getSavedCharacters();

    if (_favourites.isEmpty) {
      _characters = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _getCharacters();
  }

  void _getCharacters() async {
    try {
      _characters = await _apiService.getMultipleCharacters(_favourites);
    } catch (e) {
      _characters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
