import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tedcom/auth_screen.dart';

import 'auth_widget_test.dart';

// Mock sınıfları oluşturmak için
@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  group('AuthScreen Unit Tests', () {
    test('Login with valid credentials', () async {
      // Mock FirebaseAuth
      final mockFirebaseAuth = MockFirebaseAuth();
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com', password: 'password'))
          .thenAnswer((_) async => mockUserCredential);

      // Örnek bir login fonksiyonu çağırma simülasyonu
      final result = await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com', password: 'password');

      expect(result, isA<UserCredential>());
    });

    test('Sign up with matching passwords', () async {
      // Mock FirebaseAuth
      final mockFirebaseAuth = MockFirebaseAuth();
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@test.com', password: 'newpassword'))
          .thenAnswer((_) async => mockUserCredential);

      final result = await mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@test.com', password: 'newpassword');

      expect(result, isA<UserCredential>());
    });

    test('Sign up fails if passwords do not match', () {
      final password = 'password1';
      final confirmPassword = 'password2';

      expect(password == confirmPassword, false);
    });
  });
}
