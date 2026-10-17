import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/app/router.dart';
import 'package:rick_morty/models/characters_model.dart';
import 'package:rick_morty/services/preferences_service.dart';

class CharacterCardview extends StatefulWidget {
  final CharacterModel characterModel;
  final bool isFavorited;

  const CharacterCardview({
    super.key,
    required this.characterModel,
    this.isFavorited = false,
  });

  @override
  State<CharacterCardview> createState() => _CharacterCardviewState();
}

class _CharacterCardviewState extends State<CharacterCardview> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = _readFavoriteState();
  }

  bool _readFavoriteState() {
    final savedIds = locator<PreferencesService>().getSavedCharacters();
    return savedIds.contains(widget.characterModel.id);
  }

  Future<void> _favoriteCharacter() async {
    final prefs = locator<PreferencesService>();

    if (_isFavorited) {
      await prefs.removeCharacter(widget.characterModel.id);
    } else {
      await prefs.saveCharacter(widget.characterModel.id);
    }

    if (!mounted) return;
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.character, extra: widget.characterModel),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Stack(
          alignment: AlignmentGeometry.topRight,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(6),
                    child: Hero(
                      tag: widget.characterModel.image,
                      child: Image.network(
                        widget.characterModel.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 6, 50, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.characterModel.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          _infoWidget(
                            type: 'Köken',
                            value: widget.characterModel.origin.name,
                          ),
                          SizedBox(height: 4),
                          _infoWidget(
                            type: 'Durum',
                            value:
                                '${widget.characterModel.status} - ${widget.characterModel.species}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _favoriteCharacter,
              icon: Icon(_isFavorited ? Icons.bookmark : Icons.bookmark_border),
            ),
          ],
        ),
      ),
    );
  }

  Column _infoWidget({required String type, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
