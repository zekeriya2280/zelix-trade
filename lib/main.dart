import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/authenticate/wrapper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://zyjdrykvislgcocgsucx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp5amRyeWt2aXNsZ2NvY2dzdWN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTMyMjc4OTEsImV4cCI6MjAwODgwMzg5MX0.22hLUWUvEnVud6G6nymJXbe43yga7Uv1tQl6iMgmIHo',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(218, 93, 4, 248)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zelix Trade'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Wrapper();
  }
}
