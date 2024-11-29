import 'package:easy_pick/components/no_data_component.dart';
import 'package:easy_pick/states/cart_state.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/widgets/custom_app_bar.dart';
import 'package:easy_pick/view/widgets/loader_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../constants/color_constant.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(
        title: 'Cart',
        showLeading: true,
      ),
      body: Consumer<CartState>(builder: (context, cartState, child) {
        if (cartState.cartItemCount == 0) {
          return const NoDataComponent();
        }
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemCount: cartState.cartItemCount,
              itemBuilder: (context, index) {
                final item = cartState.cartItems.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: backgroundColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 21,
                        backgroundImage: NetworkImage(
                          item.image,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.price} Rs x ${item.quantity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color.fromARGB(255, 122, 14, 7),
                            ),
                            onPressed: () {
                              cartState.removeFromCart(item);
                            },
                          ),
                          Text(
                            item.quantity.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: secondaryColor,
                            ),
                            onPressed: () {
                              cartState.addToCart(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payable Amount:',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${cartState.totalAmount.toStringAsFixed(2)} Rs',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoaderButton(
                  btnText: "Place Order",
                  onTap: () async {
                    try {
                      await cartState.placeOrder(cartState.cartItems);
                      if (!mounted) return;
                      snack(context, 'Order Placed Successfully');
                    } catch (e) {
                      snack(context, e.toString());
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      }),
    );
  }
}
