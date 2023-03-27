import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TASK",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "-KOO",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            )
          ],
        ),
        Text(
          "Management App",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
