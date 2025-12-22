import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/i_card_repository.dart';
import 'data/repositories/mock_card_repository.dart';
import 'logic/feed/feed_bloc.dart';
import 'logic/user/user_bloc.dart';
import 'presentation/screens/splash_screen.dart';

// GetIt instance for Dependency Injection
final getIt = GetIt.instance;

void main() {
  // Setup Dependency Injection
  setupDependencies();
  
  runApp(const CrowdPulseApp());
}

/// Setup all dependencies using GetIt
void setupDependencies() {
  // Register Repository (Singleton)
  getIt.registerLazySingleton<ICardRepository>(
    () => MockCardRepository(),
  );
  
  // Register BLoCs (Factory - new instance each time)
  getIt.registerFactory<FeedBloc>(
    () => FeedBloc(repository: getIt<ICardRepository>()),
  );
  
  getIt.registerFactory<UserBloc>(
    () => UserBloc(),
  );
}

class CrowdPulseApp extends StatelessWidget {
  const CrowdPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedBloc>(
          create: (context) => getIt<FeedBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
