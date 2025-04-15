import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({super.key});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  final Zxing zx = Zxing(); // Initialize the Zxing instance
  String lastDetectedBarcode = ''; // Track the last detected barcode
  DateTime lastDetectedTime = DateTime.now(); // Track the last detection time
  bool detected = false; // Track if a barcode was detected

  @override
  void dispose() {
    zx.stopCameraProcessing(); // Stop camera processing when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProductApiProvider>(
      create: (_) => ProductApiProvider(),
      builder: (context, child){
    final productProvider = Provider.of<ProductApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Barcode Scanner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Instruction Label
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scan the barcode inside the square frame to search for items.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Barcode Scanner Section
          Expanded(
            child: ReaderWidget(
              onScan: (result) async {
                // Ignore duplicate scans within 5 seconds
                if (result.text == lastDetectedBarcode &&
                    DateTime.now().difference(lastDetectedTime) <
                        const Duration(seconds: 5)) {
                  return result;
                }

                if(result.isValid){
                  debugPrint('Scanned barcode: ${result.text}');
                }
                lastDetectedBarcode = result.text.toString();
                lastDetectedTime = DateTime.now();

                // Fetch product information using the scanned barcode
                productProvider.barcode = result.text.toString();
                debugPrint('Scanned Barcode Provider Saved: ${productProvider.barcode}');
                await productProvider.fetchProductInfo();

                // Display product information
                if (productProvider.product != null) {
                  detected = false;
                  final product = productProvider.product!;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Product Info'),
                      content: Text(
                        'Name: ${product.productName ?? 'N/A'}\n'
                        'Total Calories (kJ): ${product.nutriments?.energy ?? 'N/A'}\n'
                        'Calories Per Serving (kJ): ${product.nutriments?.energyServe ?? 'N/A'}\n'
                        'Salt (g): ${product.nutriments?.salt ?? 'N/A'}\n'
                        'Sugars (g): ${product.nutriments?.sugars ?? 'N/A'}\n'
                        'Protein per 100g (g): ${product.nutriments?.proteinsServe ?? 'N/A'}\n'
                        'Fat (g): ${product.nutriments?.fat ?? 'N/A'}\n'
                        'Saturated Fat (g): ${product.nutriments?.saturatedFat ?? 'N/A'}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () { 
                            Navigator.pop(context);
                          setState(() {
                            detected = true;
                          });
                          },
                          child: const Text('OK'),
                        
                          
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found!')),
                  );
                }

                detected = true;
              },
            ),
          ),
          const SizedBox(height: 20),

          // Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Information Button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pressing Scan Barcode will allow the camera to scan for barcodes for 5 seconds.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context); // Navigate back to the home page
              },
            ),
            // Settings Button
            IconButton(
              icon: const Icon(Icons.settings, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/settingsPage'); // Navigate to settings page
              },
            ),
          ],
        ),
      ),
    );
      }
    );
  }
}