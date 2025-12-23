import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/user/user_bloc.dart';
import '../../logic/user/user_state.dart';
import '../widgets/karma_badge.dart';
import 'forms_screen.dart';
import 'home_screen.dart';
import 'marketplace_screen.dart';
import 'profile_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 1; // Default: Home

  final _pages = const [
    FormsScreen(),
    HomeScreen(),
    MarketplaceScreen(),
    ProfileScreen(),
  ];

  String _titleForIndex(int i) {
    switch (i) {
      case 0:
        return 'Opportunities';
      case 1:
        return 'CrowdPulse';
      case 2:
        return 'Rewards Store';
      case 3:
        return 'Profile';
      default:
        return 'CrowdPulse';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titleForIndex(_currentIndex),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                return KarmaBadge(karmaPoints: userState.karmaPoints);
              },
            ),
          ),
        ],
        toolbarHeight: 48,
        centerTitle: true,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_outlined,
              color: _currentIndex == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            label: 'Forms',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront_outlined,
              color: _currentIndex == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: _currentIndex == 3
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
