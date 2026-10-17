import 'package:flutter/material.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/services/api_service.dart';

enum CharacterType { all, alive, dead, unknown }

class CharactersViewmodel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  CharacterType characterType = CharacterType.all;

  CharactersModel? _charactersModel;
  CharactersModel? get charactersModel => _charactersModel;

  void clearCharacters() {
    _charactersModel = null;
    currentPageIndex = 1; //Arama yapılınca yeni sayfa için pages başa sarılır.
    notifyListeners();
  }

  Future<void> getCharacters() async {
    _charactersModel = await _apiService.getCharacters();
    notifyListeners();
  }

  bool loadMore = false;
  int currentPageIndex = 1;

  void setLoadMore(bool value) {
    loadMore = value;
    notifyListeners(); // Değişimi yakalamak için ayrı bir fonksiyon gerekti.
  }

  void getCharactersMore() async {
    //Eğer zaten yükleniyor ise tekrar tekrar istek atma
    if (loadMore) return;

    //Eğer son sayfada ise yeni istek atma
    if (_charactersModel!.info.pages == currentPageIndex) return;

    setLoadMore(true);
    final data = await _apiService.getCharacters(
      url: _charactersModel?.info.next,
    );
    setLoadMore(false);

    currentPageIndex++; //max page sayısı 43'e ulaşma kontrolü için

    _charactersModel!.info = data.info;
    _charactersModel!.characters.addAll(data.characters);

    notifyListeners();
  }

  void getCharactersByName(String name) async {
    clearCharacters();
    _charactersModel = await _apiService.getCharacters(args: {'name': name});
    notifyListeners();
  }

  void onCharacterTypeChange(CharacterType type) async {
    characterType = type;
    clearCharacters();

    Map<String, dynamic>? args;

    if (type != CharacterType.all) {
      args = {'status': type.name};
    }
    _charactersModel = await _apiService.getCharacters(args: args);
    notifyListeners();
  }
}
