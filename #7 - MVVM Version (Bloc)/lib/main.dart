import 'package:mvvm_bloc/viewmodel/comment/bloc/comment_bloc.dart';
import 'package:mvvm_bloc/view/user/screen/user_list_screen.dart';
import 'package:mvvm_bloc/viewmodel/post/bloc/post_bloc.dart';
import 'package:mvvm_bloc/viewmodel/todo/bloc/todo_bloc.dart';
import 'package:mvvm_bloc/viewmodel/user/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';

import 'di.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => getIt<UserBloc>()),
        BlocProvider<TodoBloc>(create: (context) => getIt<TodoBloc>()),
        BlocProvider<PostBloc>(create: (context) => getIt<PostBloc>()),
        BlocProvider<CommentBloc>(create: (context) => getIt<CommentBloc>()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: const UserListScreen(),
      ),
    );
  }
}
