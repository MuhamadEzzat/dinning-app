import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../dining/dining_page.dart';
import '../profile/profile_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex,
            children: const [
              HomeTab(),
              DiningPage(),
              ProfilePage(),
            ],
          )),
      bottomNavigationBar: Obx(() => _buildBottomNavigationBar(context)),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return BottomNavigationBar(
      currentIndex: controller.currentIndex,
      onTap: controller.changeTab,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: isKidsMode ? 20 : 16,
      unselectedFontSize: isKidsMode ? 18 : 14,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: isKidsMode ? 28 : 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant, size: isKidsMode ? 28 : 24),
          label: 'Dining',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: isKidsMode ? 28 : 24),
          label: 'Profile',
        ),
      ],
    );
  }
}

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text('Welcome ${controller.userModel?.displayName ?? 'User'}!')),
        actions: [
          // Notification Bell
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: controller.showNotifications,
                  ),
                  if (controller.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${controller.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildWelcomeCard(context),
              const SizedBox(height: 20),

              // Theme Buttons
              _buildThemeButtons(context),
              const SizedBox(height: 20),

              // Role-based Content
              if (controller.userModel?.role.isAdmin == true) ...[
                _buildAdminSection(context),
                const SizedBox(height: 20),
              ],

              // Quick Actions
              _buildQuickActions(context),
              const SizedBox(height: 20),

              // Recent Activities
              _buildRecentActivities(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isKidsMode ? 24 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: isKidsMode ? 24 : 20,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to explore amazing dining options?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isKidsMode ? 18 : 14,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.changeTab(1), // Go to Dining
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Explore Dining',
                style: TextStyle(
                  fontSize: isKidsMode ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButtons(BuildContext context) {
    final themeProvider = Get.find<ThemeProvider>();
    final isKidsMode = themeProvider.isKidsMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Theme',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isKidsMode ? 22 : 18,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildThemeButton(
                context: context,
                themeMode: AppThemeMode.light,
                icon: Icons.light_mode,
                label: 'Light',
                isSelected: themeProvider.isLightMode,
                onTap: () => themeProvider.setTheme(AppThemeMode.light),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeButton(
                context: context,
                themeMode: AppThemeMode.dark,
                icon: Icons.dark_mode,
                label: 'Dark',
                isSelected: themeProvider.isDarkMode,
                onTap: () => themeProvider.setTheme(AppThemeMode.dark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeButton(
                context: context,
                themeMode: AppThemeMode.kids,
                icon: Icons.child_care,
                label: 'Kids',
                isSelected: themeProvider.isKidsMode,
                onTap: () => themeProvider.setTheme(AppThemeMode.kids),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required AppThemeMode themeMode,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    Color getButtonColor() {
      switch (themeMode) {
        case AppThemeMode.light:
          return const Color(0xFFFFF8E1); // Light cream
        case AppThemeMode.dark:
          return const Color(0xFF2C2C2C); // Dark gray
        case AppThemeMode.kids:
          return const Color(0xFFFF6B6B); // Kids red
      }
    }

    Color getTextColor() {
      switch (themeMode) {
        case AppThemeMode.light:
          return const Color(0xFF212121); // Dark text
        case AppThemeMode.dark:
          return const Color(0xFFFFFFFF); // White text
        case AppThemeMode.kids:
          return const Color(0xFFFFFFFF); // White text
      }
    }

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: isSelected ? 3 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
        child: Container(
          padding: EdgeInsets.all(isKidsMode ? 16 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      getButtonColor(),
                      getButtonColor().withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : getButtonColor().withOpacity(0.3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isKidsMode ? 32 : 28,
                color: isSelected
                    ? getTextColor()
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isKidsMode ? 16 : 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? getTextColor()
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle,
                    size: isKidsMode ? 20 : 16,
                    color: getTextColor(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Panel',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.manageUsers,
                    icon: const Icon(Icons.people),
                    label: const Text('Manage Users'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.manageRestaurants,
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Manage Restaurants'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isKidsMode ? 22 : 18,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isKidsMode ? 1.2 : 1.5,
          children: [
            _buildActionCard(
              context,
              icon: Icons.search,
              title: 'Find Restaurants',
              onTap: () => controller.changeTab(1),
            ),
            _buildActionCard(
              context,
              icon: Icons.favorite,
              title: 'Favorites',
              onTap: controller.showFavorites,
            ),
            _buildActionCard(
              context,
              icon: Icons.history,
              title: 'Order History',
              onTap: controller.showOrderHistory,
            ),
            _buildActionCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => controller.changeTab(2),
            ),
            _buildActionCard(
              context,
              icon: Icons.notifications_active,
              title: 'Test Notification',
              onTap: controller.testInAppNotification,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isKidsMode ? 20 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isKidsMode ? 40 : 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: isKidsMode ? 16 : 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isKidsMode ? 22 : 18,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(isKidsMode ? 20 : 16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.restaurant, size: isKidsMode ? 28 : 24),
                  title: Text(
                    'Pizza Palace',
                    style: TextStyle(fontSize: isKidsMode ? 18 : 16),
                  ),
                  subtitle: Text(
                    'Ordered 2 hours ago',
                    style: TextStyle(fontSize: isKidsMode ? 16 : 14),
                  ),
                  trailing:
                      Icon(Icons.arrow_forward_ios, size: isKidsMode ? 20 : 16),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.star, size: isKidsMode ? 28 : 24),
                  title: Text(
                    'Rated Burger King',
                    style: TextStyle(fontSize: isKidsMode ? 18 : 16),
                  ),
                  subtitle: Text(
                    '5 stars - Great food!',
                    style: TextStyle(fontSize: isKidsMode ? 16 : 14),
                  ),
                  trailing:
                      Icon(Icons.arrow_forward_ios, size: isKidsMode ? 20 : 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
