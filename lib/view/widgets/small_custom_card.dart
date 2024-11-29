// import 'package:flutter/material.dart';
// import 'package:service_provider/utills/snippets.dart';

// import '../../models/user_model.dart';
// import '../chat/chat_room/chat_room.dart';

// class SmallCustomCard extends StatefulWidget {
//   final UserModel model;
//   const SmallCustomCard({
//     Key? key,
//     required this.model,
//   }) : super(key: key);

//   @override
//   State<SmallCustomCard> createState() => _SmallCustomCardState();
// }

// class _SmallCustomCardState extends State<SmallCustomCard> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         push(context, ChatRoom(uid: widget.model.uid));
//       },
//       child: SizedBox(
//         width: 120,
//         child: Card(
//           elevation: 5,
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundImage: NetworkImage(widget.model.imageUrl),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   widget.model.name,
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.titleSmall,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
