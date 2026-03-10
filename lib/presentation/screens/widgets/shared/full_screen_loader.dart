import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessges() {
    final messages = <String>[
      'Cargando películas',
      'Cargando palomitas de máiz',
      'Cargando populares',
      'Lllamando a mi novia',
      'Ya mero...',
      'Esto está tardando más de lo esperado :c',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessges(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('Cargando...');
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
