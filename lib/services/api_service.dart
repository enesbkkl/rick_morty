import 'package:dio/dio.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/models/episode_model.dart';
import 'package:rick_morty/models/location_model.dart';

class ApiService {
  final _dio = Dio(BaseOptions(baseUrl: 'https://rickandmortyapi.com/api'));

  Future<CharactersModel> getCharacters({
    String? url,
    Map<String, dynamic>? args,
  }) async {
    try {
      //Tam url verilirse baseUrl görülmez. Kısa verilirse baseUrl sonuna eklenir.
      final response = await _dio.get(
        url ?? '/character',
        queryParameters: args, //url sonuna gerekli eşitleme işaretlerini ekler
      );
      return CharactersModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CharacterModel>> getMultipleCharacters(List<int> idList) async {
    if (idList.isEmpty) return [];

    try {
      final response = await _dio.get('/character/${idList.join(',')}');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => CharacterModel.fromJson(e))
            .toList();
      } else {
        // Eğer data List değilse (tekil obje ise), onu kendimiz bir listeye sarıyoruz.
        return [CharacterModel.fromJson(response.data)];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EpisodesModel> getAllEpisodes({String? url}) async {
    try {
      final response = await _dio.get(url ?? '/episode');
      return EpisodesModel.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<EpisodeModel>> getMultipleEpisodes(List<String> list) async {
    try {
      final List<String> episodeNumbers = list
          .map((e) => e.split('/').last)
          .toList();

      String episodes = episodeNumbers.join(',');
      if (list.length == 1) episodes = '$episodes,';

      final response = await _dio.get('/episode/$episodes');
      return (response.data as List)
          .map((e) => EpisodeModel.fromMap(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<LocationModel> getAllLocations({String? url}) async {
    try {
      final response = await _dio.get(url ?? '/location');
      return LocationModel.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CharacterModel>> getCharactersFromUrlList(
    List<String> residentsUrl,
  ) async {
    final List<int> idList = residentsUrl
        .map((e) => int.parse(e.split('/').last))
        .toList();

    try {
      return await getMultipleCharacters(idList);
    } catch (e) {
      rethrow;
    }
  }
}
