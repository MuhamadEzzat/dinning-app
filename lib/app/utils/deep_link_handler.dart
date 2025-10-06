import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import '../routes/app_pages.dart';

class DeepLinkHandler extends GetxService {
  static DeepLinkHandler get to => Get.find();

  final RxString _pendingLink = ''.obs;
  String get pendingLink => _pendingLink.value;

  @override
  void onInit() {
    super.onInit();
    _initializeAppLinks();
  }

  void _initializeAppLinks() {
    final appLinks = AppLinks();

    // Handle app links when app is opened from terminated state
    appLinks.getInitialAppLink().then((Uri? initialLink) {
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      }
    });

    // Handle app links when app is opened from background
    appLinks.uriLinkStream.listen((Uri link) {
      _handleDeepLink(link.toString());
    }, onError: (err) {
      print('App links error: $err');
    });
  }

  void _handleDeepLink(String link) {
    print('Handling deep link: $link');

    try {
      final uri = Uri.parse(link);

      // Handle different deep link patterns
      if (uri.scheme == 'fluttertask') {
        // Custom app scheme: fluttertask://dining?id=123
        _handleCustomSchemeLink(uri);
      } else if (uri.scheme == 'https' &&
          uri.host.contains('ezzat-flutter-task')) {
        // HTTPS deep links for your domain
        _handleHttpsLink(uri);
      } else {
        // Generic deep link
        _handleGenericDeepLink(uri);
      }
    } catch (e) {
      print('Error parsing deep link: $e');
    }
  }

  void _handleCustomSchemeLink(Uri uri) {
    // Handle custom scheme: fluttertask://dining?id=123
    final path = uri.path;
    final queryParams = uri.queryParameters;

    _navigateToRoute(path, queryParams);
  }

  void _handleHttpsLink(Uri uri) {
    // Handle HTTPS deep links
    final path = uri.path;
    final queryParams = uri.queryParameters;

    _navigateToRoute(path, queryParams);
  }

  void _handleGenericDeepLink(Uri uri) {
    // Handle generic deep links
    final path = uri.path;
    final queryParams = uri.queryParameters;

    _navigateToRoute(path, queryParams);
  }

  void _navigateToRoute(String path, Map<String, String> queryParams) {
    // Map deep link paths to app routes
    String route = '';
    Map<String, dynamic> arguments = {};

    switch (path) {
      case '/home':
        route = Routes.HOME;
        break;
      case '/dining':
        route = Routes.DINING;
        if (queryParams.containsKey('id')) {
          arguments['restaurantId'] = queryParams['id'];
        }
        break;
      case '/profile':
        route = Routes.PROFILE;
        break;
      case '/auth':
        route = Routes.AUTH;
        break;
      default:
        // Default to home if path is not recognized
        route = Routes.HOME;
        break;
    }

    // Navigate to the route
    if (Get.currentRoute != route) {
      Get.toNamed(route, arguments: arguments);
    } else {
      // If already on the route, update with new arguments
      Get.offNamed(route, arguments: arguments);
    }
  }

  // Public method to handle deep links from notifications
  void handleDeepLink(String link) {
    _handleDeepLink(link);
  }

  // Create custom scheme deep link
  String createCustomSchemeLink({
    required String path,
    Map<String, String>? queryParams,
  }) {
    final uri = Uri(
      scheme: 'fluttertask',
      path: path,
      queryParameters: queryParams,
    );
    return uri.toString();
  }

  // Create HTTPS deep link
  String createHttpsLink({
    required String path,
    Map<String, String>? queryParams,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: 'ezzat-flutter-task.web.app', // Your Firebase hosting domain
      path: path,
      queryParameters: queryParams,
    );
    return uri.toString();
  }

  // Create deep link for dining restaurant
  String createDiningDeepLink(String restaurantId) {
    return createCustomSchemeLink(
      path: '/dining',
      queryParams: {'id': restaurantId},
    );
  }

  // Create deep link for home
  String createHomeDeepLink() {
    return createCustomSchemeLink(path: '/home');
  }

  // Create deep link for profile
  String createProfileDeepLink() {
    return createCustomSchemeLink(path: '/profile');
  }

  // Set pending link (for when user is not authenticated)
  void setPendingLink(String link) {
    _pendingLink.value = link;
  }

  // Clear pending link
  void clearPendingLink() {
    _pendingLink.value = '';
  }

  // Handle pending link after authentication
  void handlePendingLink() {
    if (_pendingLink.value.isNotEmpty) {
      _handleDeepLink(_pendingLink.value);
      clearPendingLink();
    }
  }
}
