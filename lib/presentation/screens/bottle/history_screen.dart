// lib/presentation/screens/bottle/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constants.dart';
import '../../../data/models/bottle.dart';
import '../../blocs/bottle/bottle_bloc.dart';
import '../../blocs/bottle/bottle_event.dart';
import '../../blocs/bottle/bottle_state.dart';
import '../../widgets/custom_button.dart';

class HistoryScreen extends StatefulWidget {
  final String bottleId;

  const HistoryScreen({
    Key? key,
    required this.bottleId,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load bottle details
    context.read<BottleBloc>().add(LoadBottleEvent(widget.bottleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Genesis Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.expand_more, color: Colors.white),
            onPressed: () {
              // Dropdown menu would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dropdown not implemented in demo')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BottleBloc, BottleState>(
        builder: (context, state) {
          if (state is BottleLoaded) {
            final bottle = state.bottle;
            return _buildHistoryContent(bottle);
          } else if (state is BottleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is BottleError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return const Center(
            child: Text('Loading...', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildBottleHeader(Bottle bottle) {
    return Column(
      children: [
        // Genuine Bottle Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            children: [
              Icon(Icons.verified, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Genuine Bottle (Unopened)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),

        // Bottle Image
        Center(
          child: SizedBox(
            height: 300,
            child: Image.asset(
              bottle.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Bottle Number
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Bottle ${bottle.bottleNumber}/${bottle.totalBottles}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),

        // Bottle Name and ID
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bottle.name} ${bottle.ageStatement}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    Text(
                      '#${bottle.caskNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '£${bottle.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ),

        // Tab buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.bottleDetails,
                      arguments: bottle.id,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.tastingNotes,
                      arguments: bottle.id,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Tasting notes',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Already on history tab
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryContent(Bottle bottle) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBottleHeader(bottle),

          // History content (demo with empty sections and image placeholders)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First history entry
                _buildHistoryEntry(
                  label: 'Label',
                  title: 'Title',
                  description: 'Description\nDescription\nDescription',
                ),

                const SizedBox(height: 16),

                // Attachments
                const Text(
                  'Attachments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 70,
                        height: 70,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Second history entry
                _buildHistoryEntry(
                  label: 'Label',
                  title: 'Title',
                  description: 'Description\nDescription\nDescription',
                ),

                const SizedBox(height: 16),

                // Attachments for second entry
                const Text(
                  'Attachments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 70,
                        height: 70,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Add to collection button
                CustomButton(
                  text: 'Add to my collection',
                  onPressed: () {
                    // Add to collection functionality would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item is already in your collection'),
                      ),
                    );
                  },
                  isOutlined: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryEntry({
    required String label,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            width: 2,
            height: 120,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}