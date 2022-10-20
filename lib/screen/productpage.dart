import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_mentor_seven/shared%20themes/textstyle.dart';

import '../controller/chair/chair_cubit.dart';
import '../shared themes/colors.dart';
import 'cartpage.dart';

class ProductPage extends StatefulWidget {
  int indexList = 0;
  ProductPage({
    Key? key,
    required this.indexList,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
          height: 70,
          child: GestureDetector(
              onTap: () =>
                  context.read<ChairCubit>().addToCart(widget.indexList),
              child: bottomNavigationbutton())),
      backgroundColor: primary.withOpacity(0.9),
      body: getBody(),
    );
  }

  Widget getBody() {
    return BlocBuilder<ChairCubit, ChairState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            buildCustomAppbar(
                context.read<ChairCubit>().chair[widget.indexList].image),
            buildInfoItem(
              context.read<ChairCubit>().chair[widget.indexList].price,
              context.read<ChairCubit>().chair[widget.indexList].name,
              context.read<ChairCubit>().chair[widget.indexList].rating,
              context.read<ChairCubit>().chair[widget.indexList].description,
            )
          ],
        );
      },
    );
  }

  Widget buildCustomAppbar(String image) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 430,
      child: Stack(
        children: [
          Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    image,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(70))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartPage(),
                              ));
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 30,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Positioned(right: 20, bottom: 5, child: buildFavouriteButton())
        ],
      ),
    );
  }

  Widget buildFavouriteButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: !context.read<ChairCubit>().isFavList[widget.indexList]
              ? primary
              : red),
      child: IconButton(
        icon: const Icon(Icons.favorite),
        onPressed: () {
          context.read<ChairCubit>().storeFavouriteItem(
              context.read<ChairCubit>().chair[widget.indexList].key,
              widget.indexList);
        },
        color: !context.read<ChairCubit>().isFavList[widget.indexList]
            ? red
            : primary,
      ),
    );
  }

  Widget buildInfoItem(
      String price, String name, String rating, String description) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\$$price",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: red.withOpacity(0.8)),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        double.parse(rating).round() > index
                            ? Icons.star
                            : Icons.star_border,
                        size: 20,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Color Option",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          selectColor(),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: TextStyle(color: black.withOpacity(0.3), wordSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget selectColor() {
    return Row(
      children:
          List.generate(context.read<ChairCubit>().colorlist.length, (index) {
        return GestureDetector(
          onTap: () => context.read<ChairCubit>().changeColor(index),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: context.read<ChairCubit>().colorlist[index]
                  ["color"],
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: context.read<ChairCubit>().colorlist[index]
                                    ["isSelected"] ==
                                true
                            ? primary
                            : context.read<ChairCubit>().colorlist[index]
                                ["color"])),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget bottomNavigationbutton() {
    var size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: size.width * 0.5,
        height: 70,
        decoration: BoxDecoration(
            color: secondary,
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(70))),
        child: Center(
          child: Text(
            "     + Add to Cart",
            style: TextStyle(color: primary, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
