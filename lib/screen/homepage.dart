import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mentor_seven/screen/cartpage.dart';
import 'package:task_mentor_seven/screen/productpage.dart';
import 'package:task_mentor_seven/screen/searchpage.dart';
import 'package:task_mentor_seven/shared%20themes/customdrawer.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';
import 'package:task_mentor_seven/shared%20widgets/widgets.dart';
import '../controller/chair/chair_cubit.dart';
import '../shared themes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawPage(),
      key: scaffoldKey,
      backgroundColor: primary.withOpacity(0.9),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView(
      padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20, right: 20),
      children: [
        buildCustomAppbar(),
        const SizedBox(
          height: 30,
        ),
        BlocConsumer<ChairCubit, ChairState>(
          listener: (context, state) {
            if (state is AddChairToCart) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  content: Text("The item has been added to the cart!")));
            } else if (state is AlreadyAddedToCart) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  content: Text("The item has already been add to the cart!")));
            }
          },
          builder: (context, state) {
            if (state is ChairLoading) {
              return SizedBox(
                width: 600,
                height: 600,
                child: Center(
                    child: SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    color: secondary,
                  ),
                )),
              );
            } else if (state is ChairError) {
              return Center(
                child: Text(
                  "Something went wrong!",
                  style: headerBoldText(30),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchTextFieldWithIcon(),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Explore",
                    style: headerBoldText(30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            context.read<ChairCubit>().chair.length, (index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    indexList: index,
                                  ),
                                )),
                            child: buildChairList(
                                context.read<ChairCubit>().chair[index].image,
                                context.read<ChairCubit>().chair[index].name,
                                context.read<ChairCubit>().chair[index].price,
                                index),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Best Selling",
                    style: headerBoldText(30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildBestSelling(
                      context.read<ChairCubit>().chair[2].image,
                      context.read<ChairCubit>().chair[2].name,
                      context.read<ChairCubit>().chair[2].price)
                ],
              );
            }
          },
        )
      ],
    );
  }

  Widget buildCustomAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: secondary,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.person,
              size: 20,
            ),
            color: primary,
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget searchTextFieldWithIcon() {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ));
          },
          child: Container(
              width: size.width * 0.7,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  color: black.withOpacity(0.20),
                )
              ]),
              child: customSearchTextField(hint: "Search", enabled: false)),
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
        )
      ],
    );
  }

  Widget buildChairList(
      String image, String name, String price, int itemIndex) {
    return Container(
      width: 220,
      height: 340,
      margin: const EdgeInsets.all(10),
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
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: secondary),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: primary,
                  ),
                  onPressed: () {
                    context.read<ChairCubit>().addToCart(itemIndex);
                  },
                  iconSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildBestSelling(String image, String name, String price) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: black.withOpacity(0.1),
                offset: const Offset(5, 5))
          ]),
      width: size.width,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: headerBoldText(20),
              ),
              Text(
                "Description",
                style: TextStyle(color: black.withOpacity(0.3), fontSize: 15),
              ),
              Text(
                "\$$price",
                style: TextStyle(color: black.withOpacity(0.8), fontSize: 15),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: secondary),
              child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: primary,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(indexList: 2),
                        ));
                  }),
            ),
          )
        ],
      ),
    );
  }
}
