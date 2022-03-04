
import 'package:flutter/material.dart';
import 'package:todoapp/shared/componentes/componentes.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class NewTasks extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){},
      builder:(context,state)
      {
        var tasks = AppCubit.get(context).tasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index]),
          separatorBuilder: (context ,index) =>
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[200],
              ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
