import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mentor_seven/controller/chair/chair_cubit.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';
import 'package:task_mentor_seven/shared%20widgets/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double sumPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary.withOpacity(0.9),
      bottomNavigationBar: buildBottomNavigationButton(sumPrice),
      body: buildBody(),
    );
  }

  Widget buildCustomAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        Text(
          "Product",
          style: headerBoldText(20),
        ),
        Stack(
          children: [
            context.read<ChairCubit>().cart.isNotEmpty
                ? const Positioned(
                    top: 6,
                    right: 6,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  )
                : Container(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                )),
          ],
        ),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: ListView(
        children: [
          buildCustomAppbar(),
          const SizedBox(
            height: 50,
          ),
          BlocBuilder<ChairCubit, ChairState>(
            builder: (mainContext, state) {
              if (context.read<ChairCubit>().cart.isEmpty) {
                return const Center(
                    child: Text("Cart is Empty, Try adding new items."));
              }
              return Column(
                children: List.generate(context.read<ChairCubit>().cart.length,
                    (index) {
                  return BlocProvider(
                    create: (context) => ChairCubit(),
                    child: BlocBuilder<ChairCubit, ChairState>(
                      builder: (mainContext, state) {
                        return buildCartList(
                            context.read<ChairCubit>().cart[index].image,
                            context.read<ChairCubit>().cart[index].name,
                            context.read<ChairCubit>().cart[index].price,
                            mainContext,
                            index);
                      },
                    ),
                  );
                }),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildBottomNavigationButton(double price) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 250,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: black.withOpacity(0.3),
                offset: const Offset(-1, 0))
          ],
          color: primary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      child: Column(
        children: [
          BlocBuilder<ChairCubit, ChairState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Selected Price:", style: headerBoldText(15)),
                  Text(
                    "\$${context.read<ChairCubit>().sumOfPrice}",
                    style: TextStyle(
                      color: red,
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shipping Fee:", style: headerBoldText(15)),
              Text(
                "\$30.00",
                style: TextStyle(
                  color: red,
                ),
              )
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<ChairCubit, ChairState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal:",
                    style: headerBoldText(20),
                  ),
                  Text(
                    "\$${context.read<ChairCubit>().sumOfPrice + 30}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: red,
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          customTextButton(size, () {}, "Checkout")
        ],
      ),
    );
  }

  Widget buildCartList(String image, String name, String price,
      BuildContext cartContext, int index) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 100,
      width: size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              value: cartContext.read<ChairCubit>().isSelected,
              checkColor: primary,
              activeColor: red,
              onChanged: (value) {
                cartContext.read<ChairCubit>().checkItemCart();
                if (cartContext.read<ChairCubit>().isSelected == true) {
                  context.read<ChairCubit>().addToSumPrice(double.parse(price) *
                      cartContext.read<ChairCubit>().quantity);
                } else {
                  context.read<ChairCubit>().subtractFromSumPrice(
                      double.parse(price) *
                          cartContext.read<ChairCubit>().quantity);
                }
              }),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 190,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: headerBoldText(17),
                        maxLines: 2,
                      ),
                      IconButton(
                        onPressed: () {
                          if (cartContext.read<ChairCubit>().isSelected ==
                              true) {
                            cartContext.read<ChairCubit>().isSelected = false;
                            context.read<ChairCubit>().subtractFromSumPrice(
                                double.parse(price) *
                                    cartContext.read<ChairCubit>().quantity);
                          }
                          cartContext.read<ChairCubit>().quantity = 1;
                          context.read<ChairCubit>().removeItemFromCart(index);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${double.parse(price) * cartContext.read<ChairCubit>().quantity}",
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primary),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {
                                  cartContext
                                      .read<ChairCubit>()
                                      .decreaseQuantity();
                                  if (cartContext
                                          .read<ChairCubit>()
                                          .isSelected ==
                                      true) {
                                    context
                                        .read<ChairCubit>()
                                        .subtractFromSumPrice(
                                            double.parse(price));
                                  }
                                },
                                icon: const Icon(Icons.remove),
                                iconSize: 15,
                              ),
                            ),
                            const VerticalDivider(),
                            Text("${cartContext.read<ChairCubit>().quantity}"),
                            const VerticalDivider(),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                  onPressed: () {
                                    cartContext
                                        .read<ChairCubit>()
                                        .increaseQuantity();
                                    if (cartContext
                                            .read<ChairCubit>()
                                            .isSelected ==
                                        true) {
                                      context
                                          .read<ChairCubit>()
                                          .addToSumPrice(double.parse(price));
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  iconSize: 15),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
