part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const AUTH = _Paths.AUTH;
  static const HOME = _Paths.HOME;
  static const DINING = _Paths.DINING;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
  static const DINING = '/dining';
  static const PROFILE = '/profile';
}

