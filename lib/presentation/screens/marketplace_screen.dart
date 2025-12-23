import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/rewards/rewards_bloc.dart';
import '../../logic/rewards/rewards_event.dart';
import '../../logic/rewards/rewards_state.dart';
import '../../logic/user/user_bloc.dart';
import '../../logic/user/user_state.dart';
import '../../logic/user/user_event.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../../data/models/reward_model.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(LoadRewards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // If not authenticated, show login prompt
          if (authState is! Authenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sign In Required',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sign in to save your rewards and redeem them!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          // If authenticated, show rewards
          return BlocBuilder<RewardsBloc, RewardsState>(
            builder: (context, state) {
              if (state is RewardsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is RewardsLoaded) {
                if (state.rewards.isEmpty) {
                  return const Center(
                    child: Text('No rewards available'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = state.rewards[index];
                    return _RewardCard(
                      reward: reward,
                      onTap: () => _showCheckoutDialog(context, reward),
                    );
                  },
                );
              }

              if (state is RewardsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<RewardsBloc>().add(LoadRewards());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: Text('No rewards available'),
              );
            },
          );
        },
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, RewardItemModel reward) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocConsumer<RewardsBloc, RewardsState>(
        listener: (listenerContext, state) {
          if (state is InsufficientPoints) {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'You need ${state.pointsNeeded} more points (You have ${state.pointsAvailable})',
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is RedemptionSuccess) {
            // Deduct points from user
            context.read<UserBloc>().add(
              DeductKarmaPoints(state.pointsDeducted),
            );

            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✓ Redeemed! ${state.reward.title} will be delivered to your email',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is RewardsError) {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (builderContext, state) => AlertDialog(
          title: Text(reward.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reward.description),
              const SizedBox(height: 16),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  final userPoints = userState.karmaPoints;
                  final canRedeem = userPoints >= reward.cost;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cost: ${reward.cost} points',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your points: $userPoints',
                        style: TextStyle(
                          color: canRedeem ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (btnContext, userState) {
                final canRedeem = userState.karmaPoints >= reward.cost;
                return BlocBuilder<RewardsBloc, RewardsState>(
                  builder: (btnContext2, rewardState) {
                    return ElevatedButton(
                      onPressed: canRedeem &&
                          rewardState is! RedemptionChecking
                          ? () {
                        context.read<RewardsBloc>().add(
                          RedeemReward(
                            userId: 'user_123',
                            rewardId: reward.id,
                            reward: reward,
                            userCurrentPoints: userState.karmaPoints,
                          ),
                        );
                      }
                          : null,
                      child: rewardState is RedemptionChecking
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            canRedeem ? 'Redeem' : 'Insufficient Points',
                          ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardItemModel reward;
  final VoidCallback onTap;

  const _RewardCard({
    required this.reward,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.title,
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${reward.cost} pts',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  reward.category,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
