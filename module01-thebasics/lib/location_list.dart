import 'dart:async';
import 'package:flutter/material.dart';
import 'components/banner_image.dart';
import 'components/default_app_bar.dart';
import 'components/location_tile.dart';
import 'location_detail.dart';
import 'styles.dart';
import 'models/location.dart';

const ListItemHeight = 245.0;

class LocationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> locations = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: Column(
          children: [
            renderProgressBar(context),
            Expanded(child: renderListView(context)),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    if (this.mounted) {
      setState(() => this.loading = true);
      final locations = await Location.fetchAll();
      setState(() {
        this.locations = locations;
        this.loading = false;
      });
    }
  }

  Widget renderProgressBar(BuildContext context) {
    return (this.loading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container());
  }

  Widget renderListView(BuildContext context) {
    return ListView.builder(
        itemCount: this.locations.length, itemBuilder: _listViewItemBuilder);
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final location = this.locations[index];
    return GestureDetector(
      onTap: () => _navigationToLocationDetail(context, location.id),
      child: Container(
        height: ListItemHeight,
        child: Stack(
          children: [
            BannerImage(url: location.url, height: 300.0),
            _tileFooter(location),
          ],
        ),
      ),
    );
  }

  void _navigationToLocationDetail(BuildContext context, int locationID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationID)));
  }

  Widget _tileFooter(Location location) {
    final info = LocationTile(location: location, darkTheme: true);
    final overlay = Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: info,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [overlay],
    );
  }

  Widget _itemTitle(Location location) {
    return Text(
      location.name,
      style: Styles.textDefault,
    );
  }
}
