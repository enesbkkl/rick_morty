import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/models/episode_model.dart';
import 'package:rick_morty/models/location_model.dart';
import 'package:rick_morty/views/app_view.dart';
import 'package:rick_morty/views/screens/character_view/character_view.dart';
import 'package:rick_morty/views/screens/character_view/character_viewmodel.dart';
import 'package:rick_morty/views/screens/characters_view/characters_view.dart';
import 'package:rick_morty/views/screens/characters_view/characters_viewmodel.dart';
import 'package:rick_morty/views/screens/favourites_view/favourites_view.dart';
import 'package:rick_morty/views/screens/favourites_view/favourites_viewmodel.dart';
import 'package:rick_morty/views/screens/locations_view/location_viewmodel.dart';
import 'package:rick_morty/views/screens/locations_view/locations_view.dart';
import 'package:rick_morty/views/screens/residents_view.dart/resident_view.dart';
import 'package:rick_morty/views/screens/residents_view.dart/resident_viewmodel.dart';
import 'package:rick_morty/views/screens/section_characters_view/section_characters_view.dart';
import 'package:rick_morty/views/screens/section_characters_view/section_characters_viewmodel.dart';
import 'package:rick_morty/views/screens/sections_view/sections_view.dart';
import 'package:rick_morty/views/screens/sections_view/sections_viewmodel.dart';
import 'package:rick_morty/views/screens/settings_view/settings_view.dart';
import 'package:rick_morty/views/screens/settings_view/settings_viewmodel.dart';

final _routerKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();
  static const String characters = '/';
  static const String favourites = '/favourites';
  static const String locations = '/locations';
  static const String sections = '/sections';
  static const String settings = '/settings';

  //İlişkili sayfalarda sayfa altına tanımlamada / olmaz.
  // / olmadan da sayfa geçişi olmaz.
  static const String characterRoute = 'character';
  static const String character = '/character';

  static const String residentsRoute = 'residents';
  static const String residents = '/locations/residents';

  static const String sectionCharactersRoute = 'characters';
  static const String sectionCharacters = '/sections/characters';
}

final router = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoutes.characters,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.characters,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => CharactersViewmodel(),
                child: const CharactersView(),
              ),
              routes: [
                GoRoute(
                  path: AppRoutes.characterRoute,
                  builder: (context, state) => ChangeNotifierProvider(
                    create: (context) => CharacterViewmodel(),
                    child: CharacterView(
                      characterModel: state.extra as CharacterModel,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favourites,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => FavouritesViewmodel(),
                child: const FavouritesView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.locations,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => LocationViewmodel(),
                child: LocationsView(),
              ),
              routes: [
                GoRoute(
                  path: AppRoutes.residentsRoute,
                  builder: (context, state) => ChangeNotifierProvider(
                    create: (context) => ResidentViewmodel(),
                    child: ResidentsView(
                      locationItem: state.extra as LocationItem,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.sections,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => SectionsViewmodel(),
                child: SectionsView(),
              ),
              routes: [
                GoRoute(
                  path: AppRoutes.sectionCharactersRoute,
                  builder: (context, state) => ChangeNotifierProvider(
                    create: (context) => SectionCharactersViewmodel(),
                    child: SectionCharactersView(
                      episodeModel: state.extra as EpisodeModel,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => SettingsViewmodel(),
        child: SettingsView(),
      ),
    ),
  ],
);
