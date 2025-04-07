class Bottle {
  final String id;
  final String name;
  final String distillery;
  final String region;
  final String country;
  final String type;
  final String ageStatement;
  final String filled;
  final String bottled;
  final String caskNumber;
  final String abv;
  final String size;
  final String finish;
  final String imageUrl;
  final String bottleNumber;
  final String totalBottles;
  final String year;
  final double price;

  Bottle({
    required this.id,
    required this.name,
    required this.distillery,
    required this.region,
    required this.country,
    required this.type,
    required this.ageStatement,
    required this.filled,
    required this.bottled,
    required this.caskNumber,
    required this.abv,
    required this.size,
    required this.finish,
    required this.imageUrl,
    required this.bottleNumber,
    required this.totalBottles,
    required this.year,
    required this.price,
  });

  factory Bottle.fromJson(Map<String, dynamic> json) {
    return Bottle(
      id: json['id'] as String,
      name: json['name'] as String,
      distillery: json['distillery'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      type: json['type'] as String,
      ageStatement: json['age_statement'] as String,
      filled: json['filled'] as String,
      bottled: json['bottled'] as String,
      caskNumber: json['cask_number'] as String,
      abv: json['abv'] as String,
      size: json['size'] as String,
      finish: json['finish'] as String,
      imageUrl: json['image_url'] as String,
      bottleNumber: json['bottle_number'] as String,
      totalBottles: json['total_bottles'] as String,
      year: json['year'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distillery': distillery,
      'region': region,
      'country': country,
      'type': type,
      'age_statement': ageStatement,
      'filled': filled,
      'bottled': bottled,
      'cask_number': caskNumber,
      'abv': abv,
      'size': size,
      'finish': finish,
      'image_url': imageUrl,
      'bottle_number': bottleNumber,
      'total_bottles': totalBottles,
      'year': year,
      'price': price,
    };
  }
}
