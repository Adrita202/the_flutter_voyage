class Product {
  final String id;
  final String name;
  final String pricePerKg;
  final String location;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.pricePerKg,
    required this.location,
    required this.imageUrl,
  });

  // Dummy data factory constructor (For now we will just use this)
  static List<Product> dummyProducts() {
    return [
      Product(
        id: '1',
        name: 'Fresh Tomatoes',
        pricePerKg: '30',
        location: "Farmer's Market, Kolkata",
        imageUrl: 'https://via.placeholder.com/200',
      ),
      Product(
        id: '2',
        name: 'Organic Carrots',
        pricePerKg: '40',
        location: 'Farm in Bihar',
        imageUrl: 'https://via.placeholder.com/200',
      ),
      Product(
        id: '3',
        name: 'Green Beans',
        pricePerKg: '50',
        location: 'Farm in Jaipur',
        imageUrl: 'https://via.placeholder.com/200',
      ),
      Product(
        id: '4',
        name: 'Fresh Potatoes',
        pricePerKg: '25',
        location: 'Pune Farm',
        imageUrl: 'https://via.placeholder.com/200',
      ),
    ];
  }
}
