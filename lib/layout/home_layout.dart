
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/ArchivedTasks/ArchivedTasks.dart';
import 'package:todoapp/modules/DoneTasks/DoneTasks.dart';
import 'package:todoapp/modules/NewTasks/NewTasks.dart';


class HomeLayout extends StatefulWidget {
   const HomeLayout({Key? key}) : super(key: key);


  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int CurrentIndex = 0;


  List<Widget> Screens =
  [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  List<String> titel =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

   Database? database;
   var scaffoldKey = GlobalKey<ScaffoldState>();
   bool isBottomSheetShown =false;
   IconData FabIcon = Icons.edit;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child:
          Text(
            titel[CurrentIndex],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Screens[CurrentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if(isBottomSheetShown)
            {
              Navigator.pop(context);
              isBottomSheetShown=false;
              setState(() {
                FabIcon = Icons.edit;
              });
            }else{
            scaffoldKey.currentState!.showBottomSheet(
                  (context)=> Container(
                width: double.infinity,
                height: 180,
                color: Colors.deepPurple,
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              FabIcon= Icons.add;
            });
          }
        },
        child:Icon(
            FabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: CurrentIndex,
        onTap: (index) {
          setState(() {
            CurrentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.menu
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Ahmed Ali';
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT ,time TEXT ,date TEXT ,status TEXT ,time TEXT )')
            .then((value) {
          print('create table');
        }).catchError((error) {
          print('Error${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    database!.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks(title,time,date,status) VALUES("First Row","02/22/2022","10","New")',
      )
          .then((value) {
        print('$value Insert Tables');
      }).catchError((error) {
        print('Error when Inserting new Row ${error.toString()}');
      });
      return null!;
    });
  }
}