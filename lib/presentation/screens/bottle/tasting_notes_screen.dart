
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constants.dart';
import '../../../data/models/bottle.dart';
import '../../../data/models/tasting_note.dart';
import '../../blocs/bottle/bottle_bloc.dart';
import '../../blocs/bottle/bottle_event.dart';
import '../../blocs/bottle/bottle_state.dart';
import '../../widgets/custom_button.dart';

class TastingNotesScreen extends StatefulWidget {
  final String bottleId;

  const TastingNotesScreen({
    Key? key,
    required this.bottleId,
  }) : super(key: key);

  @override
  State<TastingNotesScreen> createState() => _TastingNotesScreenState();
}

class _TastingNotesScreenState extends State<TastingNotesScreen> {
  @override
  void initState() {
    super.initState();
    // Load bottle and tasting notes
    context.read<BottleBloc>().add(LoadBottleEvent(widget.bottleId));
    context.read<BottleBloc>().add(LoadTastingNotesEvent(widget.bottleId));
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
            // Get the bottle data
            final bottle = state.bottle;

            // Check if we have tasting notes loaded
            if (state is TastingNotesLoaded) {
              return _buildTastingNotesContent(bottle, (state as TastingNotesLoaded).tastingNotes);
            } else if (state is TastingNotesLoading) {
              return Column(
                children: [
                  _buildBottleHeader(bottle),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ],
              );
            } else {
              // Load tasting notes if not already loading
              if (!(state is TastingNotesLoading)) {
                context.read<BottleBloc>().add(LoadTastingNotesEvent(widget.bottleId));
              }

              return Column(
                children: [
                  _buildBottleHeader(bottle),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No tasting notes available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
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
          } else if (state is TastingNotesLoaded) {
            // If we have tasting notes but no bottle (unlikely scenario)
            context.read<BottleBloc>().add(LoadBottleEvent(widget.bottleId));
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                    // Already on tasting notes
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
                    'Tasting notes',
                    style: TextStyle(
                      color: Colors.black,
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
                      AppRoutes.history,
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
                    'History',
                    style: TextStyle(
                      color: AppColors.primary,
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

  Widget _buildTastingNotesContent(Bottle bottle, List<TastingNote> tastingNotes) {
    // If no tasting notes, show empty state
    if (tastingNotes.isEmpty) {
      return Column(
        children: [
          _buildBottleHeader(bottle),
          const Expanded(
            child: Center(
              child: Text(
                'No tasting notes available',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    // Use the first tasting note
    final tastingNote = tastingNotes.first;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBottleHeader(bottle),

          // Tasting notes content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Play button for video (mock)
                const Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tasting notes title
                const Text(
                  'Tasting notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                Text(
                  'by ${tastingNote.author}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                // Nose section
                const Text(
                  'Nose',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tastingNote.nose,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Palate section
                const Text(
                  'Palate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tastingNote.palate,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Finish section
                const Text(
                  'Finish',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tastingNote.finish,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Your notes section (divider)
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Colors.white30),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Your notes',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Colors.white30),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Empty user notes sections
                // Nose
                const Text(
                  'Nose',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description\nDescription\nDescription',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Palate
                const Text(
                  'Palate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description\nDescription\nDescription',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Finish
                const Text(
                  'Finish',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description\nDescription\nDescription',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    height: 1.5,
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
}