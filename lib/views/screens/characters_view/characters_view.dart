import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/views/screens/characters_view/characters_viewmodel.dart';
import 'package:rick_morty/views/widgets/appbar_widget.dart';
import 'package:rick_morty/views/widgets/character_card_listview.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  @override
  void initState() {
    super.initState();
    context.read<CharactersViewmodel>().getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CharactersViewmodel>();
    return Scaffold(
      appBar: AppBarWidget(title: 'Rick and Morty'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Column(
          children: [
            _searchInputWidget(context, viewModel: viewModel),
            viewModel.charactersModel == null
                ? const CircularProgressIndicator.adaptive()
                : CharacterCardListview(
                    characters: viewModel.charactersModel!.characters,
                    onLoadMore: () => viewModel.getCharactersMore(),
                    loadMore: viewModel.loadMore,
                  ),
          ],
        ),
      ),
    );
  }

  Padding _searchInputWidget(
    BuildContext context, {
    required CharactersViewmodel viewModel,
  }) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 12, bottom: 16),
      //Klavyeye arama ikonu eklemek için TextField yerine TextFormField tercihi
      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: viewModel.getCharactersByName,
        decoration: InputDecoration(
          hintText: 'Karakterlerde Ara',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          suffixIcon: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: viewModel.onCharacterTypeChange,
            itemBuilder: (context) {
              return CharacterType.values
                  .map(
                    (e) => PopupMenuItem<CharacterType>(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList();
            },
          ),
        ),
      ),
    );
  }
}
