import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'package:get/get.dart';
import 'dining_controller.dart';
import '../../data/models/dining_model.dart';
import '../../data/providers/theme_provider.dart';

class DiningPage extends GetView<DiningController> {
  const DiningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dining'),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: controller.showSearch,
          ),
          // Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: controller.showFilters,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Category Filter
            _buildCategoryFilter(),

            // Restaurant List
            Expanded(
              child: _buildRestaurantList(),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        // Show add restaurant button only for admins
        if (controller.userModel?.role.canManageContent == true) {
          return FloatingActionButton(
            onPressed: controller.addRestaurant,
            child: const Icon(Icons.add),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory == category;

          return Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectCategory(selected ? category : null);
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget _buildRestaurantList() {
    return Obx(() {
      final restaurants = controller.filteredRestaurants;

      if (restaurants.isEmpty) {
        return const Center(
          child: Text('No restaurants found'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return _buildRestaurantCard(restaurant);
        },
      );
    });
  }

  Widget _buildRestaurantCard(DiningModel restaurant) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => controller.viewRestaurant(restaurant),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isKidsMode ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image and Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: isKidsMode ? 100 : 80,
                      height: isKidsMode ? 100 : 80,
                      color: Colors.grey[300],
                      child: restaurant.imageUrl != null
                          ? Image.network(
                              restaurant.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.restaurant,
                                  size: isKidsMode ? 40 : 32,
                                  color: Colors.grey[600],
                                );
                              },
                            )
                          : Icon(
                              Icons.restaurant,
                              size: isKidsMode ? 40 : 32,
                              color: Colors.grey[600],
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Restaurant Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isKidsMode ? 20 : 18,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.category,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(Get.context!).colorScheme.primary,
                                fontSize: isKidsMode ? 16 : 14,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          restaurant.description,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: isKidsMode ? 16 : 12,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Rating and Reviews
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: isKidsMode ? 20 : 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isKidsMode ? 16 : 14,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${restaurant.reviewCount} reviews)',
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: isKidsMode ? 14 : 12,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Address and Phone
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: isKidsMode ? 20 : 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      restaurant.address,
                      style:
                          Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                                fontSize: isKidsMode ? 14 : 12,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: isKidsMode ? 20 : 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.phone,
                    style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                          fontSize: isKidsMode ? 14 : 12,
                        ),
                  ),
                ],
              ),

              // Kids Friendly Badge
              if (restaurant.isKidsFriendly) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.child_care,
                        size: isKidsMode ? 18 : 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kids Friendly',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: isKidsMode ? 14 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
