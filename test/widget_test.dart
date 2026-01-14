import 'package:flutter_test/flutter_test.dart';
import 'package:family_emergency_hub/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FamilyEmergencyHub());

    // Verify the app loads
    await tester.pumpAndSettle();
  });
}
