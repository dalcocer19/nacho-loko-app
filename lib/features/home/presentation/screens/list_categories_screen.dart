import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nacho_loko/features/home/presentation/states/category_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/category_entity.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';

// Asume la existencia del modelo Category
// class Category { final String id; final String name; const Category({required this.id, required this.name}); }

class DigitalMenuScreen extends ConsumerWidget {
  const DigitalMenuScreen({super.key});

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryProvider);

    if (categoriesState.isLoading) {
      return const Scaffold(
        backgroundColor: cream,
        body: Center(child: CircularProgressIndicator(color: orange)),
      );
    }

    if(categoriesState.categories!.isEmpty) {
      return const Scaffold(body: Center(child: Text('No hay categorías')));
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menú digital',
          style: TextStyle(color: dark, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Vista previa',
            icon: const Icon(Icons.visibility_outlined, color: dark),
            onPressed: () async {
              final Uri url = Uri.parse('https://nacho-loko.netlify.app/');
              if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 28),
              _buildCategoriesSection(
                context,
                ref,
                categoriesState.categories!,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: orange,
        color: Colors.white70,
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(title: 'Meseros', icon: Icons.supervisor_account_rounded),
          TabItem(title: 'Inicio', icon: Icons.home_rounded),
          TabItem(title: 'Contacto', icon: Icons.phone_rounded),
        ],
        initialActiveIndex: 1,
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADMINISTRACIÓN',
                style: TextStyle(
                  color: orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Organiza tu menú',
                style: TextStyle(
                  color: dark,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => context.push('/category'),
          icon: const Icon(Icons.create_new_folder_outlined),
          label: const Text('Categoría'),
          style: OutlinedButton.styleFrom(
            foregroundColor: orange,
            side: const BorderSide(color: orange),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CATEGORIES CONTAINER
  // ==========================================================

  Widget _buildCategoriesSection(
      BuildContext context,
      WidgetRef ref,
      List<CategoryEntity> categories,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 6, 10, 12),
            child: Text(
              'CATEGORÍAS',
              style: TextStyle(
                color: muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Lista de categorías provenientes de Supabase
          ...categories.map((category) {
            //final isSelected = selectedCategory?.id == category.id;

            return _CategoryTile(
              title: category.name,
              //selected: isSelected,
              isAll: false,
              onTap: () {
                ref.read(categoryProvider.notifier).loadCategory(category.id.toString());
                ref.read(productProvider.notifier).loadProductsByCategory(category.id.toString());
                context.push('/products');
                /*ref.read(selectedCategoryProvider.notifier).state =
              category;*/
              },
              onEdit: () => _showEditCategoryDialog(
                context,
                ref,
                category,
              ),
              onViewProducts: () => _showDeleteConfirmation(
                context,
                ref,
                category,
              )
            );
          }),
        ],
      ),
    );
  }

  // ==========================================================
  // EDIT CATEGORY DIALOG
  // ==========================================================

  void _showEditCategoryDialog(
      BuildContext context,
      WidgetRef ref,
      CategoryEntity category,
      ) {
    final nameController = TextEditingController(text: category.name);
    final descriptionController = TextEditingController(text: category.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Modificar categoría',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nombre de la categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Descripción (opcional)',
                  hintText: 'Ej. Entradas, bebidas, postres...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: orange),
              onPressed: () async {
                final newName = nameController.text.trim();
                final newDescription = descriptionController.text.trim();

                if (newName.isNotEmpty) {
                  // Llamada al notifier pasando nombre y descripción
                  /* await ref
                    .read(categoryProvider.notifier)
                    .updateCategory(
                      id: category.id,
                      name: newName,
                      description: newDescription,
                    ); */
                  final modify = CategoryEntity(
                    id: category.id,
                    name: newName,
                    description: newDescription,
                    commerceId: 1,
                  );
                  await ref.read(categoryProvider.notifier).updateCategory(modify);
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    CategoryEntity category,
    ) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              'Eliminar producto',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${category.name}"?\n\nEsta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.black, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              /*await ref
                    .read(productProvider.notifier)
                    .deleteProduct(product.id);*/
              await ref.read(productProvider.notifier).loadProductsByCategory(category.id.toString());
              final countProducts = ref.read(productProvider);
              if(countProducts.products.isEmpty) {
                await ref.read(categoryProvider.notifier).deleteCategory(category.id!);
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${category.name}" eliminado'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
                await ref.read(categoryProvider.notifier).loadCategories();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${category.name}" tiene productos asociados. No se puede eliminar'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }


              /*if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${category.name}" eliminado'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }*/
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

// ============================================================
// CATEGORY TILE WIDGET
// ============================================================

class _CategoryTile extends StatelessWidget {
  final String title;
  final bool isAll;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onViewProducts;

  const _CategoryTile({
    required this.title,
    required this.isAll,
    required this.onTap,
    this.onEdit,
    this.onViewProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5DC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isAll
                            ? Icons.grid_view_rounded
                            : Icons.folder_open_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            if (!isAll) ...[
              IconButton(
                tooltip: 'Ver productos',
                visualDensity: VisualDensity.compact,
                onPressed: onViewProducts,
                icon: const Icon(Icons.delete_outline_rounded, size: 19),
                color: DigitalMenuScreen.orange,
              ),
              IconButton(
                tooltip: 'Modificar categoría',
                visualDensity: VisualDensity.compact,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 19),
                color: DigitalMenuScreen.muted,
              ),
            ],
          ],
        ),
      ),
    );
  }


}