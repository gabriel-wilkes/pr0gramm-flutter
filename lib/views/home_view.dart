import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/feed_details.dart';

import 'package:pr0gramm/views/overview_view.dart';
import 'package:pr0gramm/views/widgets/drawer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: buildProfile(),
      ),
    );
  }

  Widget buildProfile() {
    final feedDetails = new FeedDetails(FeedType.TOP);
    final feed = new Feed(feedDetails: feedDetails);
    return FeedInherited(
      feed: feed,
      child: OverviewView(),
    );
  }
}