import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences prefs;

  PreferencesService({required this.prefs});

  static const String _characterKey = 'characters';

  Future<void> storeCharacters(List<String> characters) async {
    await prefs.setStringList(_characterKey, characters);
  }

  Future<void> saveCharacter(int id) async {
    final charactersList = prefs.getStringList(_characterKey) ?? [];
    if (!charactersList.contains(id.toString())) {
      charactersList.add(id.toString());
    }
    await storeCharacters(charactersList);
  }

  Future<void> removeCharacter(int id) async {
    final charactersList = prefs.getStringList(_characterKey) ?? [];
    charactersList.remove(id.toString());
    await storeCharacters(charactersList);
  }

  List<int> getSavedCharacters() {
    final charactersList = prefs.getStringList(_characterKey) ?? [];
    return charactersList.map((e) => int.parse(e)).toList();
  }
}
