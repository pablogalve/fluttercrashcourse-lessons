import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:lesson08/mocks/mock_location.dart';
import 'package:lesson08/app.dart';
import 'package:network_image_mock/network_image_mock.dart';

Widget makeTestableWidget() => MaterialApp(home: Image.network(''));

void main() {
  testWidgets(
    'test app startup',
    (WidgetTester tester) async {
      mockNetworkImagesFor(
        () async {
          await tester.pumpWidget(App());

          //final mockLocation = MockLocation.fetchAny();

          //expect(find.text(mockLocation.name), findsOneWidget);
          //expect(find.text('${mockLocation.name}blah'), findsNothing);
        },
      );
    },
  );
}
