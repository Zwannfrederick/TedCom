import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tedcom/auth_screen.dart';

void main() {
  group('AuthScreen Widget Tests', () {
    testWidgets('Initial screen shows Log In form', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthScreen()));

      // Log In butonu kontrolü
      expect(find.text('Log In'), findsOneWidget);

      // Log In formunun e-posta ve şifre alanlarını kontrol et
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
    });

    testWidgets('Switching to Sign Up form works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthScreen()));

      // Sign Up butonuna tıkla
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Sign Up formunu kontrol et
      expect(find.text('İsim Soyİsim'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
      expect(find.text('Şifre Tekrar'), findsOneWidget);
    });

    testWidgets('Sign Up button performs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthScreen()));

      // Sign Up butonuna tıkla
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // TextField değerlerini değiştir
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');

      // Sign Up düğmesine bas
      await tester.tap(find.text('Sign Up'));
      await tester.pump();
    });
  });
}
