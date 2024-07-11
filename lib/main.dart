import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:cataract_detector1/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  // var auth = FirebaseAuth.instance;
  // var isLogin = false;

  // checkIfLogin() async{
  //       auth.authStateChanges().listen((User? user){
  //         if(user!= null && mounted){
  //           setState((){
  //             isLogin = true;
  //           });
  //         }
  //       });
  // }
@override
  void initState() {
    // TODO: implement initState
    // checkIfLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // auth.signOut();
    return MaterialApp(
      title: 'Siddhi Cataract',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: isLogin ? Home() : const LandingPage(),
      home:SplashScreen(),
      routes: {
        '/login': (context) => LogIn(),
      },
    );
  }
}
