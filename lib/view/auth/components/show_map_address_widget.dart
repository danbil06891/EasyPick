import 'package:easy_pick/constants/color_constant.dart';
import 'package:flutter/material.dart';

class ShowMapAddressWidget extends StatefulWidget {
  final String address;
  const ShowMapAddressWidget({super.key, required this.address});

  @override
  State<ShowMapAddressWidget> createState() => _ShowMapAddressWidgetState();
}

class _ShowMapAddressWidgetState extends State<ShowMapAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Column(children: [
        const SizedBox(height: 10),
        Text(
          'Selected Address',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 16, fontWeight: FontWeight.w800, color: secondaryColor),
        ),
        const SizedBox(height: 5),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.address,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, widget.address);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Confirm Address')),
      ]),
    );
  }
}
