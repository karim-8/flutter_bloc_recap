import 'package:flutter/material.dart';
import 'package:flutter_bloc_recap/app_router.dart';

void main() {
  runApp(BreakingBad(appRouter: AppRouter(),));
}

class BreakingBad extends StatelessWidget {

  final AppRouter appRouter;

  const BreakingBad({Key? key, required this.appRouter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
