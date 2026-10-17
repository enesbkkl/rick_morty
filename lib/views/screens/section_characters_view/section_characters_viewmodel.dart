import 'package:flutter/material.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/models/episode_model.dart';
import 'package:rick_morty/services/api_service.dart';

class SectionCharactersViewmodel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  void getCharacters(EpisodeModel episodeModel) async {
    _characters = await _apiService.getCharactersFromUrlList(
      episodeModel.characters,
    );
    notifyListeners();
  }
}
