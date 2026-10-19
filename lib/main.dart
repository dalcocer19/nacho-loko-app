import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_router.dart';
import 'core/injection_container.dart' as di;

void main() async {

  await dotenv.load(fileName: ".env");
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseKey
  );

  await di.initInjection();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CommerceApp()));
}

class CommerceApp extends ConsumerWidget {
  const CommerceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Lectura de medidores',
        theme: ThemeData.light(),
        darkTheme: ThemeData.light(),
        //themeMode: themeMode,
        routerConfig: router);
  }
}

