import 'package:flutter/cupertino.dart';

import '../data/repositories/bills_repository.dart';
import '../data/repositories/payments_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../screens/history/history_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_dimensions.dart';
import 'theme/app_scale.dart';
import 'theme/app_text_styles.dart';

/// Root Cupertino application. Inject repositories to swap mock → API later.
class CommunalApp extends StatefulWidget {
  const CommunalApp({
    super.key,
    this.billsRepository,
    this.paymentsRepository,
    this.profileRepository,
  });

  final BillsRepository? billsRepository;
  final PaymentsRepository? paymentsRepository;
  final ProfileRepository? profileRepository;

  @override
  State<CommunalApp> createState() => _CommunalAppState();
}

class _CommunalAppState extends State<CommunalApp> {
  late final BillsRepository _billsRepository;
  late final PaymentsRepository _paymentsRepository;
  late final ProfileRepository _profileRepository;

  @override
  void initState() {
    super.initState();
    _billsRepository = widget.billsRepository ?? const MockBillsRepository();
    _paymentsRepository =
        widget.paymentsRepository ?? MockPaymentsRepository();
    _profileRepository =
        widget.profileRepository ?? const MockProfileRepository();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Communal',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.card,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.primary,
          textStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          navTitleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          navLargeTitleTextStyle: AppTextStyles.screenTitle,
          tabLabelTextStyle: AppTextStyles.tabLabel,
        ),
      ),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: AppScale.textScalerOf(context)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: MainTabShell(
        billsRepository: _billsRepository,
        paymentsRepository: _paymentsRepository,
        profileRepository: _profileRepository,
      ),
    );
  }
}

class MainTabShell extends StatelessWidget {
  const MainTabShell({
    super.key,
    required this.billsRepository,
    required this.paymentsRepository,
    required this.profileRepository,
  });

  final BillsRepository billsRepository;
  final PaymentsRepository paymentsRepository;
  final ProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: AppColors.background,
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.card,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.tabInactive,
        height: AppDimensions.tabBarHeight,
        iconSize: AppDimensions.tabIconSize,
        border: const Border(
          top: BorderSide(color: Color(0x14000000), width: 0.5),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house, size: AppDimensions.tabIconSize),
            activeIcon: Icon(
              CupertinoIcons.house_fill,
              size: AppDimensions.tabIconSize,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock, size: AppDimensions.tabIconSize),
            activeIcon: Icon(
              CupertinoIcons.clock_fill,
              size: AppDimensions.tabIconSize,
            ),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person, size: AppDimensions.tabIconSize),
            activeIcon: Icon(
              CupertinoIcons.person_fill,
              size: AppDimensions.tabIconSize,
            ),
            label: 'Профиль',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => HomeScreen(
                billsRepository: billsRepository,
                paymentsRepository: paymentsRepository,
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => HistoryScreen(
                paymentsRepository: paymentsRepository,
              ),
            );
          case 2:
          default:
            return CupertinoTabView(
              builder: (context) => ProfileScreen(
                profileRepository: profileRepository,
              ),
            );
        }
      },
    );
  }
}
