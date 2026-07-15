import 'package:azan_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/permission_setup/permission_setup_cubit.dart';
import 'widgets/permission_tiles_section.dart';

class PermissionSetupScreen extends StatelessWidget {
  const PermissionSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermissionSetupCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Prayer Notification Setup")),
      body: SafeArea(
        child: BlocBuilder<PermissionSetupCubit, PermissionSetupState>(
          builder: (context, state) {
            if (state is! PermissionSetupLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PermissionTilesSection(cubit: cubit, state: state),
                  const SizedBox(height: 30),
                  Spacer(),
                  FilledButton(
                    onPressed: state.allCompleted
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool("firstLaunch", false);

                            if (!context.mounted) return;

                            context.go(AppRouter.azan);
                          }
                        : null,
                    child: const Text("Continue"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
