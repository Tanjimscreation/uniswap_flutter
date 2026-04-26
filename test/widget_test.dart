import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniswap_flutter/main.dart';
import 'package:uniswap_flutter/providers/auth_provider.dart';

void main() {
  test('UTM email regex accepts utm.my and graduate.utm.my only', () {
    final auth = AuthProvider();
    expect(auth.isValidUTMEmail('siti@utm.my'), isTrue);
    expect(auth.isValidUTMEmail('siti@graduate.utm.my'), isTrue);
    expect(auth.isValidUTMEmail('siti@gmail.com'), isFalse);
    expect(auth.isValidUTMEmail('siti@student.utm.my'), isFalse);
  });

  testWidgets('UniSwapApp boots', (tester) async {
    await tester.pumpWidget(const UniSwapApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
