import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
 @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(authViewmodelProvider.notifier).getUser(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewmodelProvider, (previous, next) {
      if (next == null) return;
      next.whenOrNull(
     data: (user) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  user != null ? const HomePage() : const LoginPage(),
            ),
          );
        },
        error: (e, st) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      );
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
