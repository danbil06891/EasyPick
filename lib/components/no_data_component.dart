import 'package:easy_pick/constants/color_constant.dart';
import 'package:flutter/material.dart';

class NoDataComponent extends StatelessWidget {
  const NoDataComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(backgroundColor, BlendMode.multiply),
            child: Image.asset(
              'assets/images/nodatafound.gif',
              colorBlendMode: BlendMode.overlay,
              height: 180,
              width: 180,
            ),
          ),
          // const SizedBox(height: 20),
          const Text(
            'No Data Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
