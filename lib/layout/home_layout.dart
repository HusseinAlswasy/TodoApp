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
  late Database database;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {
          // try{
          //   var name =await getName();
          //   print(name);
          //   throw('some error');
          // }catch(error){
          //   print('Error ${error.toString()}');
          //
          // }
          getName().then((value) {
            print(value);
            print('osama');
            //throw('New error');
          }).catchError((error) {
            print(' Error ${error.toString()}');
          });
        },
        child: const Icon(
            Icons.add
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
      onCreate: (database, version) {
        print('database created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , data TEXT ,date TEXT ,status TEXT)')
            .then((value) {
          print('Create table');
        }).catchError((error) {
          print('Error when creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }

  void insertToDatabase(){

  }
}
