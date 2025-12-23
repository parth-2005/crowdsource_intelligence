import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/i_card_repository.dart';
import 'data/repositories/mock_card_repository.dart';
import 'data/repositories/i_forms_repository.dart';
import 'data/repositories/mock_forms_repository.dart';
import 'data/repositories/i_rewards_repository.dart';
import 'data/repositories/mock_rewards_repository.dart';
import 'logic/feed/feed_bloc.dart';
import 'logic/user/user_bloc.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_state.dart';
import 'logic/forms/forms_bloc.dart';
import 'logic/rewards/rewards_bloc.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_wrapper_screen.dart';
import 'logic/auth/auth_event.dart';

// GetIt instance for Dependency Injection
final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Setup Dependency Injection
  setupDependencies();
  
  runApp(const CrowdPulseApp());
}

/// Setup all dependencies using GetIt
void setupDependencies() {
  // Register Repositories (Singletons)
  getIt.registerLazySingleton<ICardRepository>(
    () => MockCardRepository(),
  );
  
  getIt.registerLazySingleton<IFormsRepository>(
    () => MockFormsRepository(),
  );
  
  getIt.registerLazySingleton<IRewardsRepository>(
    () => MockRewardsRepository(),
  );
  
  // Register BLoCs (Factory - new instance each time)
  getIt.registerFactory<FeedBloc>(
    () => FeedBloc(repository: getIt<ICardRepository>()),
  );
  
  getIt.registerFactory<UserBloc>(
    () => UserBloc(),
  );
  
  getIt.registerFactory<FormsBloc>(
    () => FormsBloc(repository: getIt<IFormsRepository>()),
  );
  
  getIt.registerFactory<RewardsBloc>(
    () => RewardsBloc(repository: getIt<IRewardsRepository>()),
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
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
        BlocProvider<FormsBloc>(
          create: (context) => getIt<FormsBloc>(),
        ),
        BlocProvider<RewardsBloc>(
          create: (context) => getIt<RewardsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashOrAuthGate(),
      ),
    );
  }
}

class SplashOrAuthGate extends StatelessWidget {
  const SplashOrAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainWrapperScreen();
        }
        if (state is AuthLoading) {
          return const SplashScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
