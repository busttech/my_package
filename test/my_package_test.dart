import 'package:flutter_test/flutter_test.dart';

import 'package:busttech_utils/busttech_utils.dart';

void main() {
  group('MyPackage', () {
    test('sayHello returns correct greeting', () {
      final myPackage = MyPackage();
      final result = myPackage.sayHello('World');
      expect(result, 'Hello, World!');
    });
  });
}
