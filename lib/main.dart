import 'package:bar_chart_app/controllers/deeds_controllers.dart';
import 'package:bar_chart_app/view/deed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Chart App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
class InitScreen extends ConsumerWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(deedsProvider.notifier).loadDeeds(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Init Screen'),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bar Chart App'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const DeedsView(),
          ));
        },
        label: const Text('View Deeds Screen'),
      ),
    );
  }
}
