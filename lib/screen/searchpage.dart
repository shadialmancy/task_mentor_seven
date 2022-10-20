import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mentor_seven/controller/chair/chair_cubit.dart';
import 'package:task_mentor_seven/screen/fliterpage.dart';
import 'package:task_mentor_seven/screen/productpage.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';

import '../shared themes/colors.dart';
import '../shared widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary.withOpacity(0.9),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 30,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 25,
          color: black,
        ),
        onPressed: (() => Navigator.pop(context)),
      ),
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: customSearchTextField(
            hint: "Search",
            onSubmitted: (text) {
              context.read<ChairCubit>().findChair(text);
            }),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FliterPage(),
                ));
          },
          icon: const Icon(Icons.filter_list),
          color: black,
        )
      ],
    );
  }

  Widget buildBody() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20, right: 20),
      child: BlocBuilder<ChairCubit, ChairState>(
        builder: (context, state) {
          if (state is ChairFound) {
            return ListView(
              children: [
                Column(
                  children: List.generate(state.itemlist.length, (index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                                indexList: state.itemlist[index]["index"]),
                          )),
                      child: SizedBox(
                        width: size.width,
                        height: 50,
                        child: Text(state.itemlist[index]["name"]),
                      ),
                    );
                  }),
                )
              ],
            );
          } else if (state is ChairNotFound) {
            return Center(
                child: Text(
              "Not Found",
              style: headerBoldText(40),
            ));
          }
          return Container();
        },
      ),
    );
  }
}
