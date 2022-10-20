import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mentor_seven/controller/chair/chair_cubit.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      appBar: buildCustomAppbar(),
    );
  }

  AppBar buildCustomAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
          )),
      title: Text(
        "Wishlist",
        style: headerBoldText(20),
      ),
    );
  }

  Widget getBody() {
    return BlocBuilder<ChairCubit, ChairState>(
      builder: (context, state) {
        return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              Wrap(
                runSpacing: 20,
                spacing: 20,
                children: List.generate(context.read<ChairCubit>().chair.length,
                    (index) {
                  if (context.read<ChairCubit>().isFavList[index] == true) {
                    return buildChairList(
                        context.read<ChairCubit>().chair[index].image,
                        context.read<ChairCubit>().chair[index].name,
                        context.read<ChairCubit>().chair[index].price,
                        index);
                  }
                  return Container();
                }),
              )
            ]);
      },
    );
  }

  Widget buildChairList(
      String image, String name, String price, int itemIndex) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: (size.width - 65) / 2,
      height: 340,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: primary,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: black.withOpacity(0.2),
                offset: const Offset(5, 5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !context.read<ChairCubit>().isFavList[itemIndex]
                        ? primary
                        : red),
                child: IconButton(
                    icon: const Icon(Icons.favorite),
                    color: !context.read<ChairCubit>().isFavList[itemIndex]
                        ? red
                        : primary,
                    onPressed: () {
                      context.read<ChairCubit>().storeFavouriteItem(
                          context.read<ChairCubit>().chair[itemIndex].key,
                          itemIndex);
                    }),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: headerBoldText(20),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Description",
            style: TextStyle(color: black.withOpacity(0.3), fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$$price",
                style: TextStyle(color: black.withOpacity(0.8), fontSize: 20),
              ),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration:
              //       BoxDecoration(shape: BoxShape.circle, color: secondary),
              //   child: IconButton(
              //     icon: Icon(
              //       Icons.add,
              //       color: primary,
              //     ),
              //     onPressed: () {
              //       context.read<ChairCubit>().addToCart(itemIndex);
              //     },
              //     iconSize: 20,
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }
}
