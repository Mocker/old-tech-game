import 'package:flutter_test/flutter_test.dart';
import 'package:analog_quest/main.dart';

void main() {
  testWidgets('AnalogQuestApp title screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AnalogQuestApp());

    expect(find.text('ANALOG QUEST'), findsOneWidget);
    expect(find.text('START ADVENTURE'), findsOneWidget);
    expect(find.text('HOW TO PLAY'), findsOneWidget);
  });
}
