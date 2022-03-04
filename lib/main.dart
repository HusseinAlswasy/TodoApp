import 'package:flutter/material.dart';
import 'package:todoapp/layout/home_layout.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/shared/bloc_observer.dart';


void main(){
  BlocOverrides.runZoned(
        () {
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return  MaterialApp(
     debugShowCheckedModeBanner: false,
     home: HomeLayout(),
   );
  }
}