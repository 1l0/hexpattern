import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hex', () {
    const hex =
        '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e';
    int carry = 0;
    for (var n = 0; n < hex.length; n += 2) {
      final sub = hex.substring(n, n + 2);
      final deci = int.parse(sub, radix: 16);
      carry = (deci + carry) % 255;
      final show = deci <= 128;
      print('sub $sub deci $deci carry $carry show $show');
    }
  });
}
