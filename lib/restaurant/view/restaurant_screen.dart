import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/resaurant_card.dart';
import '../model/restaurant_model.dart';
import '../repository/restaurant_repository.dart';

import 'restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
            future: repository.getRestaurantList().then((res) => res.data),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return _restaurantCardListView(snapshot.data!);
            }),
      ),
    );
  }

  Widget _restaurantCardListView(List<RestaurantModel> items) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final post = items[index];

        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: post.id)));
            },
            child: RestaurantCard.fromModel(model: post));
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 15.0);
      },
      itemCount: items.length,
    );
  }
}
