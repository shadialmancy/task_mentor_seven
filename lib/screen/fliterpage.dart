import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mentor_seven/controller/chair/chair_cubit.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';
import 'package:task_mentor_seven/shared%20themes/textstyle.dart';

import '../shared widgets/widgets.dart';

class FliterPage extends StatefulWidget {
  const FliterPage({super.key});

  @override
  State<FliterPage> createState() => _FliterPageState();
}

class _FliterPageState extends State<FliterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: BlocBuilder<ChairCubit, ChairState>(
          builder: (context, state) {
            var size = MediaQuery.of(context).size;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price:",
                  style: headerBoldText(30),
                ),
                buildPriceRangeRadio(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Sort Date:",
                  style: headerBoldText(30),
                ),
                buildDateSortRadio(),
                const SizedBox(
                  height: 10,
                ),
                // customTextButton(size, () {
                //   context.read<ChairCubit>().
                // })
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildPriceRangeRadio() {
    return Row(
        children: List.generate(
            context.read<ChairCubit>().priceRangeList.length, (index) {
      return Row(
        children: [
          Radio(
              activeColor: red,
              value: context.read<ChairCubit>().priceRangeList[index],
              groupValue: context.read<ChairCubit>().selectedPriceRange,
              onChanged: (value) {
                context.read<ChairCubit>().changePriceRange(value!);
              }),
          Text(context.read<ChairCubit>().priceRangeList[index])
        ],
      );
    }));
  }

  Widget buildDateSortRadio() {
    return Row(
        children: List.generate(context.read<ChairCubit>().dateSortList.length,
            (index) {
      return Row(
        children: [
          Radio(
              activeColor: red,
              value: context.read<ChairCubit>().dateSortList[index],
              groupValue: context.read<ChairCubit>().selectedDateSort,
              onChanged: (value) {
                context.read<ChairCubit>().changeDateSort(value!);
              }),
          Text(context.read<ChairCubit>().dateSortList[index])
        ],
      );
    }));
  }
}
