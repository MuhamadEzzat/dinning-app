import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../data/models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/providers/theme_provider.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.editProfile,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.userModel;
        if (user == null) {
          return const Center(child: Text('No user data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(user),
              const SizedBox(height: 24),

              // Theme Selection
              _buildThemeSection(),
              const SizedBox(height: 24),

              // Profile Information
              _buildProfileInfo(user),
              const SizedBox(height: 24),

              // Role-based Actions
              if (user.role.isAdmin) ...[
                _buildAdminSection(),
                const SizedBox(height: 24),
              ],

              // Settings
              _buildSettingsSection(),
              const SizedBox(height: 24),

              // Logout Button
              _buildLogoutButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isKidsMode ? 24 : 20),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: isKidsMode ? 50 : 40,
              backgroundColor: AppColors.getRoleColor(user.role.value),
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Icon(
                      Icons.person,
                      size: isKidsMode ? 50 : 40,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // Name and Role
            Text(
              user.displayName ?? 'No Name',
              style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isKidsMode ? 24 : 20,
                  ),
            ),
            const SizedBox(height: 4),

            // Role Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isKidsMode ? 16 : 12,
                vertical: isKidsMode ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.getRoleColor(user.role.value).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      AppColors.getRoleColor(user.role.value).withOpacity(0.3),
                ),
              ),
              child: Text(
                user.role.value.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: AppColors.getRoleColor(user.role.value),
                  fontWeight: FontWeight.bold,
                  fontSize: isKidsMode ? 16 : 14,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user.email,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(Get.context!).textTheme.bodySmall?.color,
                    fontSize: isKidsMode ? 16 : 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isKidsMode ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Theme',
              style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isKidsMode ? 20 : 18,
                  ),
            ),
            const SizedBox(height: 16),

            // Theme Options
            Obx(() => Column(
                  children: [
                    _buildThemeOption(
                      'Light',
                      AppThemeMode.light,
                      Icons.light_mode,
                      Colors.orange,
                    ),
                    _buildThemeOption(
                      'Dark',
                      AppThemeMode.dark,
                      Icons.dark_mode,
                      Colors.blue,
                    ),
                    _buildThemeOption(
                      'Kids',
                      AppThemeMode.kids,
                      Icons.child_care,
                      Colors.pink,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
      String name, AppThemeMode mode, IconData icon, Color color) {
    final themeProvider = Get.find<ThemeProvider>();
    final isSelected = themeProvider.currentTheme == mode;
    final isKidsMode = themeProvider.isKidsMode;

    return Obx(() => ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: isKidsMode ? 24 : 20),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: isKidsMode ? 18 : 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle,
                  color: color, size: isKidsMode ? 24 : 20)
              : Icon(Icons.radio_button_unchecked, size: isKidsMode ? 24 : 20),
          onTap: () => themeProvider.setTheme(mode),
        ));
  }

  Widget _buildProfileInfo(UserModel user) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isKidsMode ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isKidsMode ? 20 : 18,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Email Verified',
              user.isEmailVerified ? 'Yes' : 'No',
              user.isEmailVerified ? Icons.verified : Icons.warning,
              user.isEmailVerified ? Colors.green : Colors.orange,
            ),
            _buildInfoRow(
              'Account Status',
              user.isActive ? 'Active' : 'Inactive',
              user.isActive ? Icons.check_circle : Icons.cancel,
              user.isActive ? Colors.green : Colors.red,
            ),
            _buildInfoRow(
              'Member Since',
              _formatDate(user.createdAt),
              Icons.calendar_today,
              Colors.blue,
            ),
            _buildInfoRow(
              'Last Updated',
              _formatDate(user.updatedAt),
              Icons.update,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Padding(
      padding: EdgeInsets.only(bottom: isKidsMode ? 12 : 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: isKidsMode ? 24 : 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isKidsMode ? 14 : 12,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                        fontSize: isKidsMode ? 16 : 14,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSection() {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isKidsMode ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Panel',
              style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isKidsMode ? 20 : 18,
                  ),
            ),
            const SizedBox(height: 16),
            _buildAdminAction(
              'Manage Users',
              'View and manage user accounts',
              Icons.people,
              controller.manageUsers,
            ),
            _buildAdminAction(
              'Manage Restaurants',
              'Add, edit, or remove restaurants',
              Icons.restaurant_menu,
              controller.manageRestaurants,
            ),
            _buildAdminAction(
              'Send Notifications',
              'Send notifications to users',
              Icons.notifications,
              controller.sendNotifications,
            ),
            _buildAdminAction(
              'View Analytics',
              'View app usage and statistics',
              Icons.analytics,
              controller.viewAnalytics,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminAction(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            color: Theme.of(Get.context!).colorScheme.primary,
            size: isKidsMode ? 24 : 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isKidsMode ? 18 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: isKidsMode ? 16 : 14),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: isKidsMode ? 20 : 16),
      onTap: onTap,
    );
  }

  Widget _buildSettingsSection() {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isKidsMode ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isKidsMode ? 20 : 18,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              'Notifications',
              'Manage notification preferences',
              Icons.notifications,
              controller.manageNotifications,
            ),
            _buildSettingItem(
              'Privacy',
              'Privacy and security settings',
              Icons.privacy_tip,
              controller.managePrivacy,
            ),
            _buildSettingItem(
              'Help & Support',
              'Get help and contact support',
              Icons.help,
              controller.showHelp,
            ),
            _buildSettingItem(
              'About',
              'App version and information',
              Icons.info,
              controller.showAbout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return ListTile(
      leading: Icon(icon, size: isKidsMode ? 24 : 20),
      title: Text(
        title,
        style: TextStyle(fontSize: isKidsMode ? 18 : 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: isKidsMode ? 16 : 14),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: isKidsMode ? 20 : 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    final isKidsMode = Get.find<ThemeProvider>().isKidsMode;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(Icons.logout),
        label: Text(
          'Logout',
          style: TextStyle(fontSize: isKidsMode ? 18 : 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isKidsMode ? 16 : 12),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
