import 'package:flutter/material.dart';
import '../components/components.dart';
import '../components/today_recipe_list_view.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 1
  final mockService = MockFooderlichService();
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      debugPrint('i am at the bottom!');
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      debugPrint('i am at the top!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1
    return FutureBuilder(
      // 2
      future: mockService.getExploreData(),
      // 3
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        // 4
        if (snapshot.connectionState == ConnectionState.done) {
          // 5
          return ListView(
            // 6
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: [
              // 7
              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              // 8
              const SizedBox(height: 16),
              // 9
              // TODO: Replace this with FriendPostListView
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
            ],
          );
        } else {
          // 10
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
