// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:service_provider/constants/color_constant.dart';
// import 'package:service_provider/models/user_model.dart';
// import 'package:service_provider/models/request_model.dart';
// import 'package:service_provider/repos/request_repo.dart';
// import 'package:service_provider/views/chat/chat_room/chat_room.dart';
// import 'package:service_provider/views/widgets/loader_button.dart';

// import '../../states/user_state.dart';
// import '../../utills/snippets.dart';

// class RequestWidget extends StatefulWidget {
//   final UserModel userModel;
//   final RequestModel requestModel;
//   const RequestWidget(
//       {super.key, required this.userModel, required this.requestModel});

//   @override
//   State<RequestWidget> createState() => _RequestWidgetState();
// }

// class _RequestWidgetState extends State<RequestWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             ListTile(
//               leading: CircleAvatar(
//                 radius: 34,
//                 backgroundImage: NetworkImage(widget.userModel.imageUrl),
//               ),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     widget.userModel.name,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontWeight: FontWeight.w500),
//                   ),
//                   context.watch<UserState>().userModel.type == 'User'
//                       ? InkWell(
//                           onTap: () async {
//                             await RequestRepo.instance
//                                 .deleteRequest(widget.requestModel.docId)
//                                 .then((value) {
//                               snack(context, 'Request Deleted Successfully',
//                                   info: true);
//                             });
//                           },
//                           child: const Icon(
//                             Icons.delete,
//                             size: 18,
//                             color: secondaryColor,
//                           ),
//                         )
//                       : InkWell(
//                           onTap: () {
//                             push(context, ChatRoom(uid: widget.userModel.uid));
//                           },
//                           child: const Icon(
//                             Icons.message,
//                             size: 18,
//                             color: secondaryColor,
//                           ),
//                         )
//                 ],
//               ),
//               subtitle: Text(
//                 widget.requestModel.discription,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleSmall
//                     ?.copyWith(color: Colors.blueGrey),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 timeUntil(
//                   DateTime.fromMillisecondsSinceEpoch(
//                       widget.requestModel.createdAt),
//                 ),
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleSmall
//                     ?.copyWith(fontSize: 12),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Consumer<UserState>(builder: (context, userState, child) {
//               return userState.userModel.type == 'User'
//                   ? const SizedBox.shrink()
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                           width: 100,
//                           child: LoaderButton(
//                             fontSize: 11,
//                             color: Colors.red,
//                             btnText: 'Decline',
//                             onTap: () async {
//                               await RequestRepo.instance.declineRequest(
//                                   model: widget.requestModel,
//                                   handymanId:
//                                       FirebaseAuth.instance.currentUser!.uid);
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 30,
//                           width: 80,
//                           child: LoaderButton(
//                             color: Colors.green,
//                             fontSize: 11,
//                             btnText: 'Accept',
//                             onTap: () async {},
//                           ),
//                         ),
//                         SizedBox(
//                           height: 30,
//                           width: 90,
//                           child: LoaderButton(
//                             color: Colors.yellow,
//                             textColor: Colors.black,
//                             btnText: 'Create',
//                             fontSize: 11,
//                             onTap: () async {},
//                           ),
//                         ),
//                       ],
//                     );
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
