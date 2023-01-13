import 'package:clean_architecture_riverpod/core/app/app_extension.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import '../../../../common/cubit/generic_cubit.dart';
//import '../../../../common/cubit/generic_cubit_state.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/riverpod/generic_state.dart';
import '../../../../common/widget/text_input.dart';
import '../../../user/data/models/user.dart';
import '../../data/models/post.dart';

//import '../cubit/post_cubit.dart';
import '../provider/post_provider.dart';

enum PostMode { create, update }

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen(
      {Key? key, required this.user, this.mode = PostMode.create, this.post})
      : super(key: key);

  final User user;
  final Post? post;
  final PostMode mode;

  @override
  ConsumerState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  String postTitle = "";
  String postBody = "";
  int postId = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initializeValues();
    super.initState();
  }

  initializeValues() {
    //Update
    if (widget.post != null && widget.mode == PostMode.update) {
      postTitle = widget.post?.title ?? "";
      postBody = widget.post?.body ?? "";
      postId = widget.post?.id ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("${widget.mode.name.toCapital} post")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextInput(
                initialValue: postTitle,
                hint: "Title",
                validator: (String? value) {
                  if (value!.isNotEmpty) return null;
                  return "Title cannot be empty";
                },
                onChanged: (String input) {
                  postTitle = input;
                },
              ),
              const SizedBox(height: 15),
              TextInput(
                initialValue: postBody,
                hint: "body",
                maxLine: 6,
                validator: (String? value) {
                  if (value!.isNotEmpty) return null;
                  return "Body cannot be empty";
                },
                onChanged: (String input) {
                  postBody = input;
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    bool isValid = formKey.currentState?.validate() ?? false;
                    if (isValid) {
                      Post post = Post(
                          id: postId,
                          body: postBody,
                          title: postTitle,
                          userId: widget.user.id!);

                      if (widget.mode == PostMode.create) {
                        // context.read<PostCubit>().createPost(post);
                        ref
                            .read<PostNotifier>(postProvider.notifier)
                            .createPost(post);
                      } else {
                        //  context.read<PostCubit>().updatePost(post);
                        ref
                            .read<PostNotifier>(postProvider.notifier)
                            .updatePost(post);
                      }

                      showDialog(
                        context: context,
                        builder: (_) {
                          return Consumer(
                            builder: (BuildContext context, WidgetRef ref,
                                Widget? child) {
                              final state = ref.watch(postProvider);
                              switch (state.status) {
                                case Status.empty:
                                  return const SizedBox();
                                case Status.loading:
                                  return ProgressDialog(
                                    title: "${widget.mode.name}ing post...",
                                    isProgressed: true,
                                  );
                                case Status.failure:
                                  return RetryDialog(
                                    title: state.error ?? "Error",
                                    onRetryPressed: () {
                                      if (widget.mode == PostMode.create) {
                                        ref
                                            .read<PostNotifier>(
                                                postProvider.notifier)
                                            .createPost(post);
                                      } else {
                                        // context.read<PostCubit>().updatePost(post);
                                        ref
                                            .read<PostNotifier>(
                                                postProvider.notifier)
                                            .updatePost(post);
                                      }
                                    },
                                  );
                                case Status.success:
                                  return ProgressDialog(
                                    title: "Successfully ${widget.mode.name}ed",
                                    onPressed: () {
                                      if (widget.mode == PostMode.update) {
                                        pop(context, 3);
                                      } else {
                                        pop(context, 2);
                                      }
                                    },
                                    isProgressed: false,
                                  );
                              }
                            },
                          );

                          // return BlocBuilder<PostCubit,
                          //     GenericCubitState<List<Post>>>(
                          //   builder: (BuildContext context,
                          //       GenericCubitState<List<Post>> state) {
                          //     switch (state.status) {
                          //       case Status.empty:
                          //         return const SizedBox();
                          //       case Status.loading:
                          //         return ProgressDialog(
                          //           title: "${widget.mode.name}ing post...",
                          //           isProgressed: true,
                          //         );
                          //       case Status.failure:
                          //         return RetryDialog(
                          //           title: state.error ?? "Error",
                          //           onRetryPressed: () {
                          //             if (widget.mode == PostMode.create) {
                          //               context
                          //                   .read<PostCubit>()
                          //                   .createPost(post);
                          //             } else {
                          //               context
                          //                   .read<PostCubit>()
                          //                   .updatePost(post);
                          //             }
                          //           },
                          //         );
                          //       case Status.success:
                          //         return ProgressDialog(
                          //           title: "Successfully ${widget.mode.name}ed",
                          //           onPressed: () {
                          //             if (widget.mode == PostMode.update) {
                          //               pop(context, 3);
                          //             } else {
                          //               pop(context, 2);
                          //             }
                          //           },
                          //           isProgressed: false,
                          //         );
                          //     }
                          //   },
                          // );
                        },
                      );
                    }
                  },
                  child: Text(widget.mode.name.toCapital),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class CreatePostScreen extends StatefulWidget {
//   const CreatePostScreen(
//       {Key? key, required this.user, this.mode = PostMode.create, this.post})
//       : super(key: key);
//
//   final User user;
//   final Post? post;
//   final PostMode mode;
//
//   @override
//   State<CreatePostScreen> createState() => _CreatePostScreenState();
// }
//
// class _CreatePostScreenState extends State<CreatePostScreen> {
//   String postTitle = "";
//   String postBody = "";
//   int postId = 0;
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     initializeValues();
//     super.initState();
//   }
//
//   initializeValues() {
//     //Update
//     if (widget.post != null && widget.mode == PostMode.update) {
//       postTitle = widget.post?.title ?? "";
//       postBody = widget.post?.body ?? "";
//       postId = widget.post?.id ?? 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: Text("${widget.mode.name.toCapital} post")),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextInput(
//                 initialValue: postTitle,
//                 hint: "Title",
//                 validator: (String? value) {
//                   if (value!.isNotEmpty) return null;
//                   return "Title cannot be empty";
//                 },
//                 onChanged: (String input) {
//                   postTitle = input;
//                 },
//               ),
//               const SizedBox(height: 15),
//               TextInput(
//                 initialValue: postBody,
//                 hint: "body",
//                 maxLine: 6,
//                 validator: (String? value) {
//                   if (value!.isNotEmpty) return null;
//                   return "Body cannot be empty";
//                 },
//                 onChanged: (String input) {
//                   postBody = input;
//                 },
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: width * 0.4,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     bool isValid = formKey.currentState?.validate() ?? false;
//                     if (isValid) {
//                       Post post = Post(
//                           id: postId,
//                           body: postBody,
//                           title: postTitle,
//                           userId: widget.user.id!);
//
//                       if (widget.mode == PostMode.create) {
//                        // context.read<PostCubit>().createPost(post);
//                         ref.read<PostNotifier>(postProvider.notifier).createPost(post);
//
//                       } else {
//                       //  context.read<PostCubit>().updatePost(post);
//                         ref.read<PostNotifier>(postProvider.notifier).updatePost(post);
//
//                       }
//
//                       showDialog(
//                         context: context,
//                         builder: (_) {
//
//                          return Consumer(
//                               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                                 final state = ref.watch(postProvider);
//                                 switch (state.status) {
//                                   case Status.empty:
//                                     return const SizedBox();
//                                   case Status.loading:
//                                     return ProgressDialog(
//                                       title: "${widget.mode.name}ing post...",
//                                       isProgressed: true,
//                                     );
//                                   case Status.failure:
//                                     return RetryDialog(
//                                       title: state.error ?? "Error",
//                                       onRetryPressed: () {
//                                         if (widget.mode == PostMode.create) {
//                                           ref.read<PostNotifier>(postProvider.notifier).createPost(post);
//
//                                         } else {
//                                          // context.read<PostCubit>().updatePost(post);
//                                           ref.read<PostNotifier>(postProvider.notifier).updatePost(post);
//
//                                         }
//                                       },
//                                     );
//                                   case Status.success:
//                                     return ProgressDialog(
//                                       title: "Successfully ${widget.mode.name}ed",
//                                       onPressed: () {
//                                         if (widget.mode == PostMode.update) {
//                                           pop(context, 3);
//                                         } else {
//                                           pop(context, 2);
//                                         }
//                                       },
//                                       isProgressed: false,
//                                     );
//                                 }
//
//
//                               },);
//
//
//                           // return BlocBuilder<PostCubit,
//                           //     GenericCubitState<List<Post>>>(
//                           //   builder: (BuildContext context,
//                           //       GenericCubitState<List<Post>> state) {
//                           //     switch (state.status) {
//                           //       case Status.empty:
//                           //         return const SizedBox();
//                           //       case Status.loading:
//                           //         return ProgressDialog(
//                           //           title: "${widget.mode.name}ing post...",
//                           //           isProgressed: true,
//                           //         );
//                           //       case Status.failure:
//                           //         return RetryDialog(
//                           //           title: state.error ?? "Error",
//                           //           onRetryPressed: () {
//                           //             if (widget.mode == PostMode.create) {
//                           //               context
//                           //                   .read<PostCubit>()
//                           //                   .createPost(post);
//                           //             } else {
//                           //               context
//                           //                   .read<PostCubit>()
//                           //                   .updatePost(post);
//                           //             }
//                           //           },
//                           //         );
//                           //       case Status.success:
//                           //         return ProgressDialog(
//                           //           title: "Successfully ${widget.mode.name}ed",
//                           //           onPressed: () {
//                           //             if (widget.mode == PostMode.update) {
//                           //               pop(context, 3);
//                           //             } else {
//                           //               pop(context, 2);
//                           //             }
//                           //           },
//                           //           isProgressed: false,
//                           //         );
//                           //     }
//                           //   },
//                           // );
//                         },
//                       );
//                     }
//                   },
//                   child: Text(widget.mode.name.toCapital),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }