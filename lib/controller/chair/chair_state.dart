// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chair_cubit.dart';

abstract class ChairState {}

class ChairInitial extends ChairState {}

class ChairLoading extends ChairState {}

class ChairLoaded extends ChairState {}

class ChairError extends ChairState {}

class AddChairToCart extends ChairState {}

class AlreadyAddedToCart extends ChairState {}

class ItemCartChecked extends ChairState {}

class IncreaseQuantity extends ChairState {}

class DecreaseQuantity extends ChairState {}

class AddToSumPrice extends ChairState {}

class SubractFromSumPrice extends ChairState {}

class RemoveItemFromCart extends ChairState {}

class FavouriteItem extends ChairState {}

class ChairFound extends ChairState {
  List itemlist;
  ChairFound({required this.itemlist});
}

class ChairNotFound extends ChairState {}

class ColorChanged extends ChairState {}

class PriceRangeChanged extends ChairState {}

class DateSortChanged extends ChairState {}
