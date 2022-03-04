import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../modules/ArchivedTasks/ArchivedTasks.dart';
import '../../modules/DoneTasks/DoneTasks.dart';
import '../../modules/NewTasks/NewTasks.dart';
import '../componentes/constant.dart';

class AppCubit extends Cubit<AppStates>
{
   AppCubit():super(AppInitialState());

   static AppCubit get(context) => BlocProvider.of(context);



   int CurrentIndex = 0;

   List<Widget> Screens = [
      NewTasks(),
      const DoneTasks(),
      const ArchivedTasks(),
   ];

   List<String> titel = [
      'New Tasks',
      'Done Tasks',
      'Archived Tasks',
   ];

   void changeIndex(int index){
      CurrentIndex = index;
      emit(AppChangeBottomNavBar());
   }


   Database? database;
   List<Map> tasks =[];

   void createDatabase()  {
      openDatabase(
         'todo.db',
         version: 1,
         onCreate: (database, version)  {
            print('database created');
             database.execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT ,time TEXT ,date TEXT ,status TEXT)')
                .then((value) {
               print('create table');
            }).catchError((error) {
               print('Error${error.toString()}');
            });
         },
         onOpen: (database) {
            GetDataFromDatabase(database).then((value) {
               tasks = value;
               print(tasks);
               emit(AppGetState());
            });
            print('database opened');
         },
      ).then((value) {
         database = value;
         emit(AppCreateState());
      });
   }

    insertToDatabase({
      required String title,
      required String time,
      required String date
   }) async {
       await database!.transaction((txn) async {
         txn.rawInsert('INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","New")',
         ).then((value) {
            print('$value Insert Tables');
            emit(AppInsertState());

            GetDataFromDatabase(database).then((value) {
               tasks = value;
               print(tasks);
               emit(AppGetState());
            });

         }).catchError((error) {
            print('Error when Inserting new Row ${error.toString()}');
         });
      });
   }

   Future<List<Map>> GetDataFromDatabase(database) async {
      emit(AppGetLoadingState());
      return await database!.rawQuery('SELECT * FROM tasks');
   }

   bool isBottomSheetShown = false;
   IconData FabIcon = Icons.edit;

   void changeBottomSheetState({
      required bool isShow,
      required IconData iconData,
    })
   {
      isBottomSheetShown =isShow;
      FabIcon =iconData;
      
      emit(AppChangeBottomSheet());

   }
}