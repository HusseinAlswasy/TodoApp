import 'package:flutter/material.dart';

// Reusable componentes

Widget deafultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required String text,
  required Function function,
}) =>
    Container(
      color: background,
      width: width,
      height: 50,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );

Widget deafultTextFromFeiled({
  required TextEditingController controller,
  required TextInputType keyboard,
  Function? onSubmit,
  Function? OnTap,
  required Function validate,
  required String label,
  required String hint,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  bool visibilty = true,
  Function? SuffixPressed,


}) => TextFormField(

      controller: controller,
      keyboardType: keyboard,
      onFieldSubmitted: (v){
            onSubmit!(v);
      },
      validator: (value){
        return validate(value);
      },
      onTap:(){
        OnTap!();
      },
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: (){
            SuffixPressed!();
          },
          icon: Icon(
            suffix,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model) => Padding(      //*
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children:[
       CircleAvatar(
        radius: 40.0,
        child: Text(
          '${model['title']}',
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text(
            '${model['time']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
           const SizedBox(height: 5,),
           Text(
            '${model['date']}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

        ],
      ),
    ],
  ),
);