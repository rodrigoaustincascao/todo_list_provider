import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider_todolist.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

class HomerHeader extends StatelessWidget {
  const HomerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Selector<AuthProviderTodolist, String>(
            selector:
                (context, authProvider) =>
                    authProvider.user?.displayName ?? 'Não Informado',
            builder: (_, value, __) {
              return Text(
                'E aí, $value!',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
