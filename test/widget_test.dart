import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mi_primera_app/main.dart';

void main() {
  testWidgets('Ejercicio 1 muestra el saludo', (tester) async {
    await tester.pumpWidget(const MiApp());
    await tester.tap(find.text('Ejercicio 1'));
    await tester.pumpAndSettle();
    expect(find.text('¡Hola, Flutter!'), findsOneWidget);
  });

  testWidgets('Ejercicio 2 muestra la tarjeta de perfil', (tester) async {
    await tester.pumpWidget(const MiApp());
    await tester.tap(find.text('Ejercicio 2'));
    await tester.pumpAndSettle();
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Proyectos'), findsOneWidget);
  });

  testWidgets('Ejercicio 3: incrementar, decrementar y reiniciar',
      (tester) async {
    await tester.pumpWidget(const MiApp());
    await tester.tap(find.text('Ejercicio 3'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);

    // No baja de cero
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
