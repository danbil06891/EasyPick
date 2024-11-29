import 'package:easy_pick/models/product_request_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/color_constant.dart';
import '../../../../models/user_model.dart';
import '../../../../utills/snippets.dart';
import '../offer_list_view.dart';

class UserRequestWidget extends StatefulWidget {
  final ProductRequestModel requestModel;
  final UserModel userModel;
  const UserRequestWidget(
      {super.key, required this.requestModel, required this.userModel});

  @override
  State<UserRequestWidget> createState() => _UserRequestWidgetState();
}

class _UserRequestWidgetState extends State<UserRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          push(
              context,
              UserRequestOfferList(
                requestModel: widget.requestModel,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.abc, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.requestModel.discription,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // const SizedBox(width: 10),
                  // const Text(
                  //   '2x',
                  //   style: TextStyle(color: Colors.green),
                  // ),
                ],
              ),
              const Divider(color: greyColor, indent: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  Row(
                    children: [
                      Text(
                        'Product: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.requestModel.selectedCategory,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Text(
                        'Type: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.requestModel.selectedSubCategory,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: greyColor, indent: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Text(
                        'Price: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.requestModel.price} Rs.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Radius: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.requestModel.radius} KM',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Date: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        parseDate(DateTime.fromMillisecondsSinceEpoch(
                            widget.requestModel.createdAt)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
