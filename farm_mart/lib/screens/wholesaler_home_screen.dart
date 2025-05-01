import 'package:flutter/material.dart';
import '../constants/colors.dart';

class WholesalerHomeScreen extends StatefulWidget {
  const WholesalerHomeScreen({Key? key}) : super(key: key);

  @override
  _WholesalerHomeScreenState createState() => _WholesalerHomeScreenState();
}

class _WholesalerHomeScreenState extends State<WholesalerHomeScreen> {
  int _selectedIndex = 0;

  // Dummy data for product display
  final List<Map<String, dynamic>> _products = [
    {
      'image': 'assets/images/tomato.jpg',
      'name': 'Tomato',
      'group': 'Vegetables',
      'location': 'Pune, Maharashtra',
      'price': 25.0,
    },
    {
      'image': 'assets/images/potato.jpg',
      'name': 'Potato',
      'group': 'Vegetables',
      'location': 'Nashik, Maharashtra',
      'price': 15.0,
    },
    {
      'image': 'assets/images/apple.jpg',
      'name': 'Apple',
      'group': 'Fruits',
      'location': 'Shimla, Himachal Pradesh',
      'price': 80.0,
    },
    {
      'image': 'assets/images/rice.jpg',
      'name': 'Rice',
      'group': 'Grains',
      'location': 'West Bengal',
      'price': 45.0,
    },
    {
      'image': 'assets/images/wheat.jpg',
      'name': 'Wheat',
      'group': 'Grains',
      'location': 'Punjab',
      'price': 30.0,
    },
    {
      'image': 'assets/images/mango.jpg',
      'name': 'Mango',
      'group': 'Fruits',
      'location': 'Ratnagiri, Maharashtra',
      'price': 120.0,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCart() {
    // Navigate to cart page
    Navigator.pushNamed(context, '/cart');
  }

  void _navigateToProfile() {
    // Navigate to profile page
    Navigator.pushNamed(context, '/profile');
  }
  
  void _navigateToProductDetails(Map<String, dynamic> product) {
    // Navigate to product details page with product data
    Navigator.pushNamed(
      context, 
      '/product_details',
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            // App Logo
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "A",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Search Bar
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            
            // Cart Icon
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: _navigateToCart,
              color: AppColors.textDark,
              iconSize: isSmallScreen ? 20 : 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            
            // Profile Icon
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: _navigateToProfile,
              color: AppColors.textDark,
              iconSize: isSmallScreen ? 20 : 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate appropriate cross axis count based on screen width
            final double width = constraints.maxWidth;
            int crossAxisCount = 2;
            
            if (width > 600) {
              crossAxisCount = 3;
            } else if (width < 350) {
              crossAxisCount = 1;
            }
            
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: isSmallScreen ? 0.8 : 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_products[index]);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 22,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return InkWell(
      onTap: () => _navigateToProductDetails(product),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(product['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Product Group
                    Text(
                      product['group'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            product['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product['price']}/kg',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppColors.accent,
                          ),
                          onPressed: () {
                            // Add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product['name']} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}