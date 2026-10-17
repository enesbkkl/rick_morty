import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/views/screens/character_view/character_viewmodel.dart';
import 'package:rick_morty/views/widgets/appbar_widget.dart';
import 'package:rick_morty/views/widgets/decorated_container.dart';
import 'package:rick_morty/views/widgets/episodes_listview.dart';

class CharacterView extends StatefulWidget {
  final CharacterModel characterModel;
  const CharacterView({super.key, required this.characterModel});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  @override
  void initState() {
    super.initState();
    context.read<CharacterViewmodel>().getEpisodes(
      widget.characterModel.episode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(title: 'Karakter', transparentBackground: true),
        body: DecoratedContainer(
          topChild: _characterAvatar(context),
          child: Column(
            children: [
              SizedBox(height: 13),
              _characterName(),
              SizedBox(height: 15),
              _labelsView(context),
              SizedBox(height: 38),
              _scenesTitle(),
              SizedBox(height: 15),
              _episodeListView(),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _episodeListView() {
    return Flexible(
      child: Consumer<CharacterViewmodel>(
        builder: (context, viewModel, child) {
          return EpisodesListview(episodes: viewModel.episodes);
        },
      ),
    );
  }

  Text _characterName() {
    return Text(
      widget.characterModel.name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Container _scenesTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        'Bölümler (${widget.characterModel.episode.length})',
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Padding _labelsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 14,
        spacing: 7,
        children: [
          _labelWidget(context, label: widget.characterModel.status),
          _labelWidget(context, label: widget.characterModel.origin.name),
          _labelWidget(context, label: widget.characterModel.gender),
          _labelWidget(context, label: widget.characterModel.species),
        ],
      ),
    );
  }

  Container _labelWidget(BuildContext context, {required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }

  Padding _characterAvatar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 90, bottom: 52),
      child: CircleAvatar(
        radius: 105,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Hero(
            tag: widget.characterModel.image,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.characterModel.image),
              radius: 95,
            ),
          ),
        ),
      ),
    );
  }
}
