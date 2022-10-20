import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';
import '../../model/chair.dart';
part 'chair_state.dart';

String domainName = "https://mentor-seven-task-default-rtdb.firebaseio.com";

class ChairCubit extends Cubit<ChairState> {
  List<ChairModel> chair = [];
  List<ChairModel> cart = [];
  bool isSelected = false;
  List<bool> isFavList = [];
  int quantity = 1;
  double sumOfPrice = 0;
  String selectedPriceRange = "All";
  List<String> priceRangeList = [
    "All",
    ">100",
    ">200",
  ];
  List<String> dateSortList = ["Newest to latest", "Latest to newest"];
  String selectedDateSort = "Newest to latest";

  List<Map<String, dynamic>> colorlist = [
    {"color": red, "isSelected": true},
    {"color": Colors.blueGrey[200], "isSelected": false},
    {"color": black, "isSelected": false}
  ];
  ChairCubit() : super(ChairInitial()) {
    fetchData().then((value) {
      initFavouriteItem();
      getAllFavouriteItem();
    });
  }

  Future initFavouriteItem() async {
    final prefs = await SharedPreferences.getInstance();
    for (var element in chair) {
      prefs.setBool(element.key, false);
    }
  }

  Future getAllFavouriteItem() async {
    final prefs = await SharedPreferences.getInstance();
    for (var element in chair) {
      isFavList.add(prefs.getBool(element.key) ?? false);
    }
  }

  Future storeFavouriteItem(String key, int index) async {
    final prefs = await SharedPreferences.getInstance();
    isFavList[index] = !isFavList[index];
    await prefs.setBool(key, isFavList[index]);
    emit(FavouriteItem());
  }

  Future<void> fetchData() async {
    emit(ChairLoading());
    try {
      http.Response response =
          await http.get(Uri.parse("$domainName/chair.json"));
      Map data = json.decode(response.body);

      if (response.statusCode == 200) {
        data.forEach((key, value) {
          chair.add(ChairModel.fromMap(key, value));
        });
      }
      emit(ChairLoaded());
    } catch (e) {
      emit(ChairError());
    }
  }

  void addToCart(int index) {
    if (cart.contains(chair[index])) {
      emit(AlreadyAddedToCart());
    } else {
      cart.add(chair[index]);
      emit(AddChairToCart());
    }
  }

  void checkItemCart() {
    isSelected = !isSelected;
    emit(ItemCartChecked());
  }

  void addToSumPrice(double value) {
    sumOfPrice += value;
    emit(AddToSumPrice());
  }

  void subtractFromSumPrice(double value) {
    sumOfPrice -= value;
    emit(SubractFromSumPrice());
  }

  void increaseQuantity() {
    quantity++;
    emit(IncreaseQuantity());
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      emit(DecreaseQuantity());
    }
  }

  void removeItemFromCart(int value) {
    cart.removeAt(value);
    emit(RemoveItemFromCart());
  }

  // void fliterFindChair(){
  //   switch()
  // }

  void findChair(String itemName) {
    if (itemName != " ") {
      // chair.sort()
      List<Map<String, dynamic>> itemFound = [];
      for (var element in chair) {
        if (element.name.toLowerCase().contains(itemName.toLowerCase())) {
          itemFound
              .add({"name": element.name, "index": chair.indexOf(element)});
        }
      }
      if (itemFound.isNotEmpty) {
        emit(ChairFound(itemlist: itemFound));
      } else {
        emit(ChairNotFound());
      }
    } else {
      emit(ChairNotFound());
    }
  }

  void changeColor(int index) {
    for (var element in colorlist) {
      element["isSelected"] = false;
    }
    colorlist[index]["isSelected"] = true;
    emit(ColorChanged());
  }

  void changePriceRange(String value) {
    selectedPriceRange = value;
    emit(PriceRangeChanged());
  }

  void changeDateSort(String value) {
    selectedDateSort = value;
    emit(PriceRangeChanged());
  }
}
