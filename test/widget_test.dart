import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/utils/validators.dart';

void main() {
  test('Validators reject empty email', () {
    expect(Validators.validateEmail(''), isNotNull);
  });

  test('Validators accept a valid email', () {
    expect(Validators.validateEmail('test@example.com'), isNull);
  });
}
