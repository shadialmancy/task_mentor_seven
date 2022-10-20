class ChairModel {
  String key;
  String name;
  String image;
  String description;
  String price;
  String rating;
  ChairModel({
    required this.key,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
  });

  factory ChairModel.fromMap(String key, Map<String, dynamic> map) {
    return ChairModel(
      key: key,
      rating: map['rating'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      price: map['price'],
    );
  }
}
