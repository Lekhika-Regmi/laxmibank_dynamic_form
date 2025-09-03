import 'package:dynamic_form/routes/router.dart';
import 'package:dynamic_form/screens/form_screen.dart';
import 'package:dynamic_form/widgets/service_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../models/merchant_groups.dart';
import '../models/merchant.dart';
import '../services/api_service.dart'; // Your API service

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> logoEntranceAnimation;

  List<MerchantGroup> merchantGroups = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    logoEntranceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.forward();
    _loadMerchantGroups();
  }

  Future<void> _loadMerchantGroups() async {
    try {
      final groups = await fetchMerchantGroups();
      setState(() {
        merchantGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _onMerchantTap(Merchant merchant) {
    context.push('/form', extra: merchant);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xffEF7D17),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white], // Customize colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          //   color: Colors.white70,
        ),
        child: Column(
          children: [
            // SizedBox(height: 60),
            Stack(
              children: [
                Lottie.asset("assets/animations/Banner.json"),

                Align(
                  alignment:
                      Alignment.centerLeft, // This places it at the center-left
                  child: Hero(
                    tag: 'logoHero',
                    child: FadeTransition(
                      opacity: logoEntranceAnimation,
                      child: Container(
                        width: 200,
                        height: 250,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/laxmiLogo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffEF7D17),
                      Color.fromARGB(255, 248, 153, 70),
                    ], // Customize colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _loadMerchantGroups,
                child: Text('Retry'),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: merchantGroups.length,
      itemBuilder: (context, index) {
        final group = merchantGroups[index];
        if (group.isEmpty) return SizedBox.shrink();

        return ServiceSection(
          merchantGroup: group,
          onMerchantTap: _onMerchantTap,
          onViewAll: () => _showAllMerchants(group),
        );
      },
    );
  }

  void _showAllMerchants(MerchantGroup group) {
    // TODO: Navigate to show all merchants in this group
    print('Show all merchants for: ${group.name}');
  }
}
