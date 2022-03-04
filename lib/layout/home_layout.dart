import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/ArchivedTasks/ArchivedTasks.dart';
import 'package:todoapp/modules/DoneTasks/DoneTasks.dart';
import 'package:todoapp/modules/NewTasks/NewTasks.dart';
import 'package:todoapp/shared/componentes/componentes.dart';
import 'package:todoapp/shared/componentes/constant.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

   HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Center(
                child: Text(
                  cubit.titel[cubit.CurrentIndex],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: ConditionalBuilder(
              fallback: (context) => const Center(child: CircularProgressIndicator()),
              condition: state is! AppGetLoadingState,
              builder: (BuildContext context) => cubit.Screens[cubit.CurrentIndex],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );

                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                deafultTextFromFeiled(
                                  controller: titleController,
                                  keyboard: TextInputType.text,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be  empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  hint: 'Task Title',
                                  prefix: Icons.title,
                                  OnTap: () {},
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                deafultTextFromFeiled(
                                  controller: timeController,
                                  keyboard: TextInputType.datetime,
                                  OnTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be  empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  hint: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                deafultTextFromFeiled(
                                  controller: dateController,
                                  keyboard: TextInputType.datetime,
                                  OnTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-03-27'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be  empty';
                                    }
                                    return null;
                                  },
                                  label: 'Date Time',
                                  hint: 'Date Time',
                                  prefix: Icons.date_range_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,

                      ).closed.then((value) {
                        cubit.changeBottomSheetState(isShow:false,iconData:Icons.edit );
                  });
                      cubit.changeBottomSheetState(isShow: true, iconData: Icons.add);
                }
              },
              child: Icon(
                cubit.FabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).CurrentIndex,
              onTap: (index) {
                 AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
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
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'Ahmed Ali';
  // }

}
