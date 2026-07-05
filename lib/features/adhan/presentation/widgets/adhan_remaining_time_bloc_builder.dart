import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extentions/duration_formatter.dart';
import '../cubit/adhan_cubit/adhan_cubit.dart';

class AdhanRemainingTimeBlocBuilder extends StatelessWidget {
  const AdhanRemainingTimeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdhanCubit, AdhanState>(
      builder: (context, state) {
        if (state is AdhanSuccess) {
          return Column(
            children: [
              Text(
                'Current Prayer: ${state.adhanStatus.currentPrayer.displayName}',
              ),
              Text('Next Prayer: ${state.adhanStatus.nextPrayer.displayName}'),
              const SizedBox(height: 8),
              Text(
                'Remaining Time: ${state.adhanStatus.remainingTime.hhmmss}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        if (state is AdhanError) {
          return Text(state.message);
        }

        return const Center(
          child: CircularProgressIndicator(color: Colors.green),
        );
      },
    );
  }
}
