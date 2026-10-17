import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty/app/router.dart';
import 'package:rick_morty/models/location_model.dart';

class LocationListview extends StatefulWidget {
  final LocationModel locationModel;
  final VoidCallback? onLoadMore;
  final bool loadMore;
  const LocationListview({
    super.key,
    required this.locationModel,
    this.onLoadMore,
    required this.loadMore,
  });

  @override
  State<LocationListview> createState() => _LocationListviewState();
}

class _LocationListviewState extends State<LocationListview> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _detectScrollBottom();
    super.initState();
  }

  void _detectScrollBottom() {
    if (widget.onLoadMore != null) {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentPosition = _scrollController.position.pixels;
        const int delta = 200; //En alta inmeden önce yeni sayfa yüklenmesi için

        if (maxScroll - currentPosition <= delta) {
          widget.onLoadMore!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: widget.locationModel.locations.length,
      itemBuilder: (context, index) {
        final LocationItem location = widget.locationModel.locations[index];
        return Column(
          children: [
            ListTile(
              onTap: () => context.push(AppRoutes.residents, extra: location),
              leading: Icon(Icons.location_on),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                location.name,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                children: [
                  _subtitleItem(text: 'Tür: ', value: location.type),
                  _subtitleItem(
                    text: 'Kişi Sayısı: ',
                    value: location.residents.length.toString(),
                  ),
                ],
              ),
            ),
            if (widget.loadMore &&
                index == widget.locationModel.locations.length - 1)
              CircularProgressIndicator.adaptive(),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Theme.of(context).colorScheme.tertiary,
        indent: 30,
        endIndent: 30,
        height: 0,
      ),
    );
  }

  Widget _subtitleItem({required String text, required String value}) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
        Text(value, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
