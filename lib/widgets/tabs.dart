// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class HomeTabsView extends StatefulWidget {
  Widget chatTabs;
  Widget appBarContent;
  HomeTabsView(
      {super.key, required this.appBarContent, required this.chatTabs});

  @override
  State<HomeTabsView> createState() => _HomeTabsViewState();
}

class _HomeTabsViewState extends State<HomeTabsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Example'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Status'),
              Tab(text: 'Calls'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Contents of Tab 1
            Center(
              child: Text('Tab 1 Content'),
            ),

            // Contents of Tab 2
            Center(
              child: Text('Tab 2 Content'),
            ),

            // Contents of Tab 3
            Center(
              child: Text('Tab 3 Content'),
            ),
          ],
        ),
      ),
    );
  }
}
