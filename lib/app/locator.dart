import 'package:get_it/get_it.dart';
import 'package:rick_morty/services/api_service.dart';
import 'package:rick_morty/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

//Sırası önemli olması ile beraber birden fazla yerde kullanılacak servisler locatorda tanımlanır
Future<void> setupLocator() async {
  //Servis başlatılmadan önce SP nesnesi üretilsin diye Future yapıldı ve main.dart'ta bekletildi
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<PreferencesService>(
    () => PreferencesService(prefs: prefs),
  );
  locator.registerLazySingleton<ApiService>(() => ApiService());
}
