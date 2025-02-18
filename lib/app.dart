import 'package:contacts_app/blocs/contatct_bloc.dart';
import 'package:contacts_app/repositories/contact_repository.dart';
import 'package:contacts_app/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      home: BlocProvider(
        create: (context) {
          return ContactBloc(ContactRepositoryImpl());
        },
        child: HomePage(),
      ),
    );
  }
}
