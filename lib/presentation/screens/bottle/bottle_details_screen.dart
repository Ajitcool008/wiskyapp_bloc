import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants.dart';
import '../../../data/models/bottle.dart';
import '../../../data/models/tasting_note.dart';
import '../../blocs/bottle/bottle_bloc.dart';
import '../../blocs/bottle/bottle_event.dart';
import '../../blocs/bottle/bottle_state.dart';

class BottleDetailsScreen extends StatefulWidget {
  final String bottleId;

  const BottleDetailsScreen({super.key, required this.bottleId});

  @override
  State<BottleDetailsScreen> createState() => _BottleDetailsScreenState();
}

class _BottleDetailsScreenState extends State<BottleDetailsScreen> {
  int _currentTab = 0; // 0: Details, 1: Tasting Notes, 2: History

  @override
  void initState() {
    super.initState();
    // Load bottle details and tasting notes when screen initializes
    context.read<BottleBloc>().add(LoadBottleEvent(widget.bottleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              image: DecorationImage(
                image: AssetImage('assets/images/background_pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildCustomAppBar(context),
                // Rest of the content
                Expanded(
                  child: BlocBuilder<BottleBloc, BottleState>(
                    builder: (context, state) {
                      if (state is BottleLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (state is BottleLoaded ||
                          state is TastingNotesLoading ||
                          state is TastingNotesLoaded ||
                          state is TastingNotesError) {
                        Bottle bottle;
                        List<TastingNote> tastingNotes = [];

                        if (state is BottleLoaded) {
                          bottle = state.bottle;
                          if (_currentTab == 1) {
                            // Only request tasting notes if we don't already have them loading
                            context.read<BottleBloc>().add(
                              LoadTastingNotesEvent(widget.bottleId),
                            );
                          }
                        } else if (state is TastingNotesLoading) {
                          bottle = state.bottle;
                        } else if (state is TastingNotesLoaded) {
                          bottle = state.bottle;
                          tastingNotes = state.tastingNotes;
                        } else if (state is TastingNotesError) {
                          bottle = state.bottle;
                        } else {
                          // This shouldn't happen with our state setup, but handle it anyway
                          return const Center(
                            child: Text(
                              'Something went wrong',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return _buildBottleDetails(bottle, tastingNotes, state);
                      } else if (state is BottleError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<BottleBloc>().add(
                                    LoadBottleEvent(widget.bottleId),
                                  );
                                },
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Genesis Collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'EBGaramond',
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(width: 1.5),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleDetails(
    Bottle bottle,
    List<TastingNote> tastingNotes,
    BottleState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Genuine Bottle Status with dropdown icon
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black.withOpacity(0.4),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Genuine Bottle (Unopened)',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),

          // Bottle Image with transparent background
          Center(
            child: SizedBox(
              height: 320,
              child: Image.asset(bottle.imageUrl, fit: BoxFit.contain),
            ),
          ),

          // Details area with dark background
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black.withOpacity(0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bottle Number
                Text(
                  'Bottle ${bottle.bottleNumber}/${bottle.totalBottles}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${bottle.name} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'EBGaramond',
                        ),
                      ),
                      TextSpan(
                        text: bottle.ageStatement,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'EBGaramond',
                        ),
                      ),
                    ],
                  ),
                ),

                // Cask number
                Text(
                  '#${bottle.caskNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'EBGaramond',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('Details', 0),
                      _buildTabButton('Tasting notes', 1),
                      _buildTabButton('History', 2),
                    ],
                  ),
                ),

                // Tab content
                _buildTabContent(bottle, tastingNotes, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int tabIndex) {
    final isSelected = _currentTab == tabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = tabIndex;
          });

          // If switching to tasting notes tab, load tasting notes
          if (tabIndex == 1) {
            context.read<BottleBloc>().add(
              LoadTastingNotesEvent(widget.bottleId),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius:
                isSelected ? BorderRadius.all(Radius.circular(8)) : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    Bottle bottle,
    List<TastingNote> tastingNotes,
    BottleState state,
  ) {
    switch (_currentTab) {
      case 0:
        return _buildDetailsTab(bottle);
      case 1:
        if (state is TastingNotesLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        return _buildTastingNotesTab(bottle, tastingNotes);
      case 2:
        return _buildHistoryTab(bottle);
      default:
        return _buildDetailsTab(bottle);
    }
  }

  Widget _buildDetailsTab(Bottle bottle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem('Distillery', 'Text'),
        _buildDetailItem('Region', 'Text'),
        _buildDetailItem('Country', 'Text'),
        _buildDetailItem('Type', 'Text'),
        _buildDetailItem('Age statement', 'Text'),
        _buildDetailItem('Filled', 'Text'),
        _buildDetailItem('Bottled', 'Text'),
        _buildDetailItem('Cask number', 'Text'),
        _buildDetailItem('ABV', 'Text'),
        _buildDetailItem('Size', 'Text'),
        _buildDetailItem('Finish', 'Text'),

        // Add to collection button
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: CustomDetailButton(
            text: 'Add to my collection',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item is already in your collection'),
                ),
              );
            },
            isOutlined: false,
            icon: Icons.add,
          ),
        ),
      ],
    );
  }

  Widget _buildTastingNotesTab(Bottle bottle, List<TastingNote> tastingNotes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Play button for video
        Center(
          child: Container(
            width: 200,
            height: 120,
            color: Colors.black26,
            child: const Center(
              child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Tasting notes header
        const Text(
          'Tasting notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'by Charles MacLean MBE',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Nose section
        _buildTastingSection('Nose', [
          'Description',
          'Description',
          'Description',
        ]),
        const SizedBox(height: 16),

        // Palate section
        _buildTastingSection('Palate', [
          'Description',
          'Description',
          'Description',
        ]),
        const SizedBox(height: 16),

        // Finish section
        _buildTastingSection('Finish', [
          'Description',
          'Description',
          'Description',
        ]),

        const SizedBox(height: 24),

        // Your notes section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your notes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),

        // User's nose section
        _buildTastingSection('Nose', [
          'Description',
          'Description',
          'Description',
        ]),
        const SizedBox(height: 16),

        // User's palate section
        _buildTastingSection('Palate', [
          'Description',
          'Description',
          'Description',
        ]),
        const SizedBox(height: 16),

        // User's finish section
        _buildTastingSection('Finish', [
          'Description',
          'Description',
          'Description',
        ]),

        // Add to collection button
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: CustomDetailButton(
            text: 'Add to my collection',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item is already in your collection'),
                ),
              );
            },
            isOutlined: false,
            icon: Icons.add,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(Bottle bottle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First history item
        _buildHistoryItem('Label', 'Title', [
          'Description',
          'Description',
        ], hasAttachments: true),

        const SizedBox(height: 32),

        // Second history item
        _buildHistoryItem('Label', 'Title', [
          'Description',
          'Description',
        ], hasAttachments: true),

        // Add to collection button
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: CustomDetailButton(
            text: 'Add to my collection',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item is already in your collection'),
                ),
              );
            },
            isOutlined: false,
            icon: Icons.add,
          ),
        ),
      ],
    );
  }

  Widget _buildTastingSection(String title, List<String> descriptions) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black26,
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
          const SizedBox(height: 4),
          ...descriptions.map(
            (desc) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                desc,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String label,
    String title,
    List<String> descriptions, {
    bool hasAttachments = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline elements
        Column(
          children: [
            // Circle indicator
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            // Vertical line
            Container(
              width: 2,
              height: hasAttachments ? 150 : 80,
              color: Colors.white38,
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Descriptions
              ...descriptions
                  .map(
                    (desc) => Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  )
                  .toList(),

              // Attachments if needed
              if (hasAttachments) ...[
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.attach_file, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Attachments',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildAttachmentPreview(),
                    const SizedBox(width: 8),
                    _buildAttachmentPreview(),
                    const SizedBox(width: 8),
                    _buildAttachmentPreview(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CustomDetailButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomDetailButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
          foregroundColor: isOutlined ? AppColors.primary : Colors.black,
          side:
              isOutlined
                  ? const BorderSide(color: AppColors.primary)
                  : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
