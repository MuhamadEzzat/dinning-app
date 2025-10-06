import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/models/dining_model.dart';
import '../../data/models/user_model.dart';
import '../../utils/deep_link_handler.dart';

class DiningController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final DeepLinkHandler _deepLinkHandler = Get.find<DeepLinkHandler>();

  final RxList<DiningModel> _restaurants = <DiningModel>[].obs;
  final RxList<String> _categories = <String>[].obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  List<DiningModel> get restaurants => _restaurants;
  List<String> get categories => _categories;
  String? get selectedCategory =>
      _selectedCategory.value.isEmpty ? null : _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoading => _isLoading.value;
  UserModel? get userModel => _authProvider.userModel;

  List<DiningModel> get filteredRestaurants {
    var filtered = _restaurants.where((restaurant) {
      // Check if user can access this restaurant
      if (!restaurant.canUserAccess(userModel?.role.value ?? 'user')) {
        return false;
      }

      // Filter by category
      if (selectedCategory != null && restaurant.category != selectedCategory) {
        return false;
      }

      // Filter by search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return restaurant.name.toLowerCase().contains(query) ||
            restaurant.description.toLowerCase().contains(query) ||
            restaurant.category.toLowerCase().contains(query) ||
            restaurant.tags.any((tag) => tag.toLowerCase().contains(query));
      }

      return true;
    }).toList();

    // Sort by rating (highest first)
    filtered.sort((a, b) => b.rating.compareTo(a.rating));

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    _loadRestaurants();
    _loadCategories();
  }

  Future<void> _loadRestaurants() async {
    _isLoading.value = true;
    try {
      // Simulate loading restaurants from API/Firestore
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API call
      _restaurants.value = [
        DiningModel(
          id: '1',
          name: 'Pizza Palace',
          description:
              'Authentic Italian pizza with fresh ingredients and traditional recipes.',
          category: 'Italian',
          rating: 4.5,
          reviewCount: 128,
          address: '123 Main Street, Downtown',
          phone: '+1 (555) 123-4567',
          website: 'https://pizzapalace.com',
          tags: ['pizza', 'italian', 'family-friendly'],
          isKidsFriendly: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        DiningModel(
          id: '2',
          name: 'Burger King',
          description:
              'Fast food chain serving flame-grilled burgers and crispy fries.',
          category: 'Fast Food',
          rating: 4.2,
          reviewCount: 89,
          address: '456 Oak Avenue, Midtown',
          phone: '+1 (555) 987-6543',
          tags: ['burgers', 'fast-food', 'quick-service'],
          isKidsFriendly: true,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        DiningModel(
          id: '3',
          name: 'Sushi Master',
          description:
              'Premium sushi and Japanese cuisine with fresh fish and traditional techniques.',
          category: 'Japanese',
          rating: 4.8,
          reviewCount: 203,
          address: '789 Pine Street, Uptown',
          phone: '+1 (555) 456-7890',
          website: 'https://sushimaster.com',
          tags: ['sushi', 'japanese', 'fine-dining'],
          isKidsFriendly: false,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
        DiningModel(
          id: '4',
          name: 'Taco Fiesta',
          description:
              'Authentic Mexican tacos, burritos, and traditional dishes.',
          category: 'Mexican',
          rating: 4.3,
          reviewCount: 156,
          address: '321 Elm Street, Eastside',
          phone: '+1 (555) 321-0987',
          tags: ['mexican', 'tacos', 'spicy'],
          isKidsFriendly: true,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now(),
        ),
        DiningModel(
          id: '5',
          name: 'Steakhouse Prime',
          description:
              'Premium steaks and fine dining experience with wine selection.',
          category: 'Steakhouse',
          rating: 4.7,
          reviewCount: 92,
          address: '654 Maple Drive, Westside',
          phone: '+1 (555) 654-3210',
          website: 'https://steakhouseprime.com',
          tags: ['steak', 'fine-dining', 'wine'],
          isKidsFriendly: false,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
      ];
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadCategories() {
    // Extract unique categories from restaurants
    final categorySet = <String>{};
    for (final restaurant in _restaurants) {
      categorySet.add(restaurant.category);
    }
    _categories.value = categorySet.toList()..sort();
  }

  void selectCategory(String? category) {
    _selectedCategory.value = category ?? '';
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void showSearch() {
    Get.dialog(
      AlertDialog(
        title: const Text('Search Restaurants'),
        content: TextField(
          onChanged: setSearchQuery,
          decoration: const InputDecoration(
            hintText: 'Search by name, category, or tags...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setSearchQuery('');
              Get.back();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showFilters() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Category Filter
            Text(
              'Category',
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) selectCategory(null);
                  },
                ),
                ...categories.map((category) => FilterChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        selectCategory(selected ? category : null);
                      },
                    )),
              ],
            ),

            const SizedBox(height: 16),

            // Kids Friendly Filter
            Obx(() => CheckboxListTile(
                  title: const Text('Kids Friendly Only'),
                  value: _showKidsFriendlyOnly.value,
                  onChanged: (value) {
                    _showKidsFriendlyOnly.value = value ?? false;
                  },
                )),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      selectCategory(null);
                      _showKidsFriendlyOnly.value = false;
                      setSearchQuery('');
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final RxBool _showKidsFriendlyOnly = false.obs;

  void viewRestaurant(DiningModel restaurant) {
    // Create deep link for this restaurant
    final deepLink = _deepLinkHandler.createDiningDeepLink(restaurant.id);
    print('Deep link created: $deepLink');

    // Show restaurant details
    Get.dialog(
      AlertDialog(
        title: Text(restaurant.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (restaurant.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    restaurant.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 50),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                restaurant.description,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.star, 'Rating',
                  '${restaurant.rating} (${restaurant.reviewCount} reviews)'),
              _buildInfoRow(Icons.location_on, 'Address', restaurant.address),
              _buildInfoRow(Icons.phone, 'Phone', restaurant.phone),
              if (restaurant.website != null)
                _buildInfoRow(Icons.web, 'Website', restaurant.website!),
              if (restaurant.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Tags',
                  style: Theme.of(Get.context!).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: restaurant.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Theme.of(Get.context!)
                                .colorScheme
                                .primaryContainer,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to restaurant details or booking
              Get.snackbar(
                'Restaurant',
                'Booking feature coming soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Book Table'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addRestaurant() {
    Get.snackbar(
      'Admin Feature',
      'Add restaurant feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
