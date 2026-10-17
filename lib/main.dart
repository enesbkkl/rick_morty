import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/app/locator.dart';
import 'package:rick_morty/app/router.dart';
import 'package:rick_morty/app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //main async olursa eklenmeli
  await setupLocator();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppTheme())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, viewModel, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: viewModel.theme,
      ),
    );
  }
}
