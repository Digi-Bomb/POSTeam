import 'package:flutter_test/flutter_test.dart';
import 'package:point_of_sale_2/main.dart'; 

void main() {
  testWidgets('Customer POS screen loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Customer POS'), findsOneWidget);
  });
}
