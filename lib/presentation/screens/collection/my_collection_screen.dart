import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants.dart';
import '../../../data/models/bottle.dart';
import '../../blocs/collection/collection_bloc.dart';
import '../../blocs/collection/collection_event.dart';
import '../../blocs/collection/collection_state.dart';
import '../../widgets/bottle_grid_item.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load bottles when screen initializes
    context.read<CollectionBloc>().add(LoadCollectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My collection', style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications not implemented in demo'),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
          if (state is CollectionInitial || state is CollectionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is CollectionLoaded) {
            return _buildCollectionGrid(state.bottles);
          } else if (state is CollectionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading collection',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CollectionBloc>().add(LoadCollectionEvent());
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          // Only Collection tab is implemented for this demo
          if (index != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Only Collection tab is implemented in this demo',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCollectionGrid(List<Bottle> bottles) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<CollectionBloc>().add(RefreshCollectionEvent());
        return Future.delayed(const Duration(milliseconds: 1000));
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.50,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: bottles.length,
        itemBuilder: (context, index) {
          final bottle = bottles[index];
          return BottleGridItem(
            bottle: bottle,
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.bottleDetails, arguments: bottle.id);
            },
          );
        },
      ),
    );
  }
}
