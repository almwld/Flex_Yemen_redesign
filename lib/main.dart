import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flex_yemen_redesign/screens/home_screen.dart';
import 'package:flex_yemen_redesign/screens/store_screen.dart';
import 'package:flex_yemen_redesign/screens/profile_screen.dart';
import 'package:flex_yemen_redesign/screens/map_screen.dart';
import 'package:flex_yemen_redesign/widgets/custom_app_bar.dart';
import 'package:flex_yemen_redesign/widgets/bottom_nav_bar.dart';
import 'package:flex_yemen_redesign/providers/category_provider.dart';
import 'package:flex_yemen_redesign/providers/home_provider.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const FlexYemenApp());
}

class FlexYemenApp extends StatefulWidget {
  const FlexYemenApp({super.key});

  @override
  State<FlexYemenApp> createState() => _FlexYemenAppState();
}

class _FlexYemenAppState extends State<FlexYemenApp> {
  bool isDarkMode = true;
  int cartCount = 0;
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const MapScreen(),
      StoreScreen(onAdd: _addToCart),
      const Center(child: Text("إضافة إعلان جديد")),
      const Center(child: Text("المحفظة المالية")),
      const Center(child: Text("الدردشة والوساطة")),
      const ProfileScreen(),
    ];
  }

  void _addToCart() {
    setState(() => cartCount++);
  }

  void _toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          brightness: Brightness.light,
          primaryColor: AppColors.primaryGold,
          scaffoldBackgroundColor: AppColors.lightBackground,
        ),
        darkTheme: ThemeData(
          fontFamily: 'Cairo',
          brightness: Brightness.dark,
          primaryColor: AppColors.primaryGold,
          scaffoldBackgroundColor: AppColors.darkBackground,
        ),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          appBar: CustomAppBar(
            isDarkMode: isDarkMode,
            cartCount: cartCount,
            onThemeToggle: _toggleTheme,
            onSettingsPressed: () => _onNavItemTapped(6),
            onCartPressed: () {},
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            isDarkMode: isDarkMode,
            onItemTapped: _onNavItemTapped,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onNavItemTapped(3),
            backgroundColor: AppColors.primaryGold,
            elevation: 10,
            child: const Icon(Icons.add_rounded, color: Colors.black, size: 35),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
