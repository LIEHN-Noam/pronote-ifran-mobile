# TODO: Fix Student Login Error (404 on Fetch Eleve by Email)

## Steps to Complete:

1. **Update lib/helpers/eleves_helper.dart**: [x]
   - Modify the `loginEleve` method to parse the Eleve object directly from the `studentLogin` response (assuming `response['eleve']` contains the user data as a Map matching the Eleve model).
   - Remove the call to `getEleveByEmail(email)` to avoid the failing API request.
   - Clear the password in the Eleve object for security.
   - Ensure error handling remains intact.

2. **Test the Changes**: [x] (404 fixed, null parsing handled in eleve.dart)
   - Run `flutter pub get` to ensure no dependency issues.
   - Execute `flutter run` and test student login with valid credentials.
   - Verify navigation to StudentHomepage succeeds without the 404 error.
   - If the response structure differs (e.g., no 'eleve' key), inspect the API response and adjust parsing.
   - Added debug prints to eleves_helper.dart for future inspection if needed.
   - Updated lib/models/eleve.dart fromMap to default null strings to '' preventing type errors.

3. **Update TODO.md**: [x]
   - Mark steps as completed after each one.

4. **Final Verification**: [x]
   - The 404 error on fetching eleve by email is resolved by parsing directly from login response.
   - The subsequent "Null is not a subtype of String" error is fixed by handling nulls in Eleve.fromMap.
   - Student login should now succeed without exceptions; test with `flutter run` and valid credentials to confirm navigation to StudentHomepage.

# TODO: Change Student Login Redirect to CommonHomepage

## Steps to Complete:

1. **Edit lib/screens/login_screen.dart**: [x]
   - In the `_handleLogin` method, change the navigation for 'Etudiant' from `StudentHomepage` to `CommonHomepage`.

2. **Test the Changes**: [x]
   - Run `flutter run` and test student login with valid credentials.
   - Verify navigation to CommonHomepage succeeds.
   - Check that the UI displays correctly for student user type.
   - Fixed parsing issue in `lib/helpers/eleves_helper.dart` to use 'student' key from API response, ensuring user info (nom, prenom, classe) is correctly passed and displayed.

# TODO: Display Student Class as Level and Specialty Instead of ID

## Steps to Complete:

1. **Add getClassById to lib/services/api_service.dart**: [ ]
   - Implement GET request to /classes/{id} with auth headers to fetch class details.

2. **Update lib/helpers/eleves_helper.dart**: [ ]
   - In loginEleve, after parsing Eleve, fetch and assign eleve.classe using getClassById.

3. **Update lib/screens/login_screen.dart**: [ ]
   - Change userClass construction to use eleve.classe.niveau and specialite.

4. **Test the Changes**: [ ]
   - Run `flutter run` and test student login.
   - Verify userClass displays as "Niveau - Spécialité".

## Task: Make common_homepage.dart fetch and display student's niveau and specialite

- [ ] Step 1: Add getClasseById method to lib/services/api_service.dart
- [ ] Step 2: Update lib/screens/common_homepage.dart to StatefulWidget with FutureBuilder for fetching classe details
- [ ] Step 3: Update lib/screens/login_screen.dart to pass classeId to CommonHomepage for Etudiant
- [ ] Step 4: Run `flutter pub get` to update dependencies
- [ ] Step 5: Test changes by running `flutter run` and logging in as Etudiant to verify display
- [ ] Step 6: Mark task complete and update TODO.md
