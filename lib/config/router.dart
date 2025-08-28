import 'package:go_router/go_router.dart';
import 'package:super_youth/screens/home_screen.dart';
import 'package:super_youth/screens/learning_screen.dart';
import 'package:super_youth/screens/login_screen.dart';
import 'package:super_youth/screens/profile_screen.dart';
import 'package:super_youth/screens/sign_up_screen.dart';
import 'package:super_youth/screens/splash_screen.dart';
import 'package:super_youth/screens/unit_screen.dart';

import '../screens/feedback_screen.dart';
import '../screens/try_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/learn', builder: (context, state) => LearningScreen()),

    GoRoute(
      path: '/unit/:unitNumber',
      builder: (context, state) {
        if (state.pathParameters['unitNumber'] == null) {
          return HomeScreen();
        } else {
          return UnitScreen(
            unitNumber: int.parse(state.pathParameters['unitNumber']!),
          );
        }
      },
      routes: [
        GoRoute(
          path: '/try/:scenarioNumber',
          builder:
              (context, state) => TryScreen(
                unitNumber: int.parse(state.pathParameters['unitNumber']!),
                scenarioNumber: int.parse(
                  state.pathParameters['scenarioNumber']!,
                ),
              ),
        ),
        GoRoute(
          path: '/feedback/:scenarioNumber',
          builder: (context, state) {
            final Map<String, dynamic> data =
                state.extra! as Map<String, dynamic>;
            return FeedbackScreen(
              scenario: data['scenario'],
              userResponse: data['userResponse'],
              unitNumber: int.parse(state.pathParameters['unitNumber']!),
              scenarioNumber: int.parse(
                state.pathParameters['scenarioNumber']!,
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
  ],
);
