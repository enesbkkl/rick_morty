import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/views/screens/favourites_view/favourites_viewmodel.dart';
import 'package:rick_morty/views/widgets/appbar_widget.dart';
import 'package:rick_morty/views/widgets/character_card_listview.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavouritesViewmodel>().getFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavouritesViewmodel>();

    return Scaffold(
      appBar: AppBarWidget(title: 'Favorilerim'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: viewModel.isLoading
              ? const CircularProgressIndicator.adaptive()
              : viewModel.characters.isEmpty
              ? const Text('Henüz Bir Favori Karakter Eklemediniz')
              : Column(
                  children: [
                    CharacterCardListview(characters: viewModel.characters),
                  ],
                ),
        ),
      ),
    );
  }
}
