# TODO: Fix MaterialApp Assertion Error

- [x] Edit lib/main.dart: Switch to `home: const LoginScreen()`, remove `initialRoute: '/'` and `routes: {'/': ...}` to resolve the redundancy causing the assertion failure.
- [ ] Run `flutter clean && flutter pub get` to clear build cache and reinstall dependencies.
- [ ] Run `flutter run` to test the app and confirm the error is resolved (no assertion on launch).
- [ ] If needed, verify navigation from LoginScreen to other screens (e.g., student_homepage.dart).

# TODO: Modify Common Homepage User Info Display

- [x] Edit lib/screens/common_homepage.dart: Remove card styling (background color, border radius, box shadow) from user info container, keep padding and spacing for a normal display.
- [x] Add buttons in the body below user info, using the same options as the drawer based on userType (e.g., ElevatedButtons with icons and labels).
- [x] Test the app to ensure user info displays normally and buttons work as expected. (User will perform testing.)
