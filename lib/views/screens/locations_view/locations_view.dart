import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/views/screens/locations_view/location_listview.dart';
import 'package:rick_morty/views/screens/locations_view/location_viewmodel.dart';
import 'package:rick_morty/views/widgets/appbar_widget.dart';
import 'package:rick_morty/views/widgets/decorated_container.dart';

class LocationsView extends StatefulWidget {
  const LocationsView({super.key});

  @override
  State<LocationsView> createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView> {
  @override
  void initState() {
    context.read<LocationViewmodel>().getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(title: 'Konumlar', transparentBackground: true),
        extendBodyBehindAppBar: true,
        body: DecoratedContainer(
          topChild: SizedBox(height: 74),
          child: _locationListView(),
        ),
      ),
    );
  }

  Widget _locationListView() {
    return Consumer<LocationViewmodel>(
      builder: (context, viewModel, child) {
        if (viewModel.locationModel == null) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: LocationListview(
              locationModel: viewModel.locationModel!,
              onLoadMore: viewModel.getMoreLocations,
              loadMore: viewModel.loadMore,
            ),
          );
        }
      },
    );
  }
}
