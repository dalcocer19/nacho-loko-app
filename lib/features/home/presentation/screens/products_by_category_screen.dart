import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nacho_loko/features/home/presentation/states/category_state.dart';

import '../../domain/entities/product.dart';
import '../providers/category_provider.dart';
import '../providers/commerce_provider.dart';
import '../providers/product_provider.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Asume la existencia del modelo Product y el provider productProvider
// class Product { final String id; String name; double price; String description; String? imageUrl; bool isAvailable; ... }

class ProductsByCategoryScreen extends ConsumerWidget {
  const ProductsByCategoryScreen({super.key});

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productProvider);
    final categoryState = ref.watch(categoryProvider);

    if (productsState.isLoading) {
      return const Scaffold(
        backgroundColor: cream,
        body: Center(child: CircularProgressIndicator(color: orange)),
      );
    }

    final products = productsState.products;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back_rounded, color: dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Productos',
          style: TextStyle(color: dark, fontWeight: FontWeight.w900),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;
          final paddingHorizontal = isDesktop ? 44.0 : 20.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              paddingHorizontal,
              20,
              paddingHorizontal,
              40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(products.length, categoryState),
                const SizedBox(height: 28),
                if (products.isEmpty)
                  _buildEmptyState()
                else
                  _buildProductsList(context, ref, products, isDesktop),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        elevation: 4,
        tooltip: 'Agregar producto',
        onPressed: () {
          context.push('/createProduct');
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: const Color(0xFFE4572E),
          color: Colors.white70,
          //activeColor: const Color(0xFFFFC857),
          style: TabStyle.fixedCircle,
          items: _buildBottomBarItems(),
          initialActiveIndex: 1,
          onTap: (int index) => _handleTabSelection(context, index, ref)
      ),
    );
  }
  Future<void> _handleTabSelection(BuildContext context, int index, WidgetRef ref) async {
    final items = _buildBottomBarItems();

    // Asegurarnos que el índice es válido
    if (index < 0 || index >= items.length) return;

    // Navegación basada en el ítem seleccionado
    switch (items[index].title) {
      case 'Meseros':
        context.go('/userProfile');
        break;
      case 'Inicio':
        context.go('/home');
        break;
      case 'Contacto':
      // Carga todos los comercios antes de ir a la pantalla
        ref.read(commerceProvider.notifier).loadCommerce('1');
        context.push('/restaurant');
        break;
    }
  }

  List<TabItem> _buildBottomBarItems() {
    return [
      TabItem(title: 'Meseros', icon: Icons.supervisor_account_rounded),
      TabItem(title: 'Inicio', icon: Icons.home_rounded),
      TabItem(title: 'Contacto', icon: Icons.phone_rounded),
    ];
  }
  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(int productCount, CategoryState categoryState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5DC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              color: orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATEGORÍA',
                  style: TextStyle(
                    color: orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  categoryState.category!.name,
                  style: TextStyle(
                    color: dark,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$productCount producto${productCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '$productCount',
                  style: const TextStyle(
                    color: orange,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'PRODUCTOS',
                  style: TextStyle(
                    color: muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCTS LIST
  // ==========================================================

  Widget _buildProductsList(
      BuildContext context,
      WidgetRef ref,
      List<Product> products,
      bool isDesktop,
      ) {
    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 520,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1.65,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(
            product: product,
            //onEdit: () => _showEditProductDialog(context, ref, product),
              onEdit: () {
                print('holaaaa');
                //context.push('/editProduct');
              },
            onDelete: () => _showDeleteConfirmation(context, ref, product),
            onToggleAvailability: () => ref
                /*.read(productProvider.notifier)
                .toggleAvailability(product),*/
          );
        },
      );
    }

    return Column(
      children: products.map((product) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ProductCard(
            product: product,
            //onEdit: () => _showEditProductDialog(context, ref, product),
              onEdit: () {
                ref.read(productProvider.notifier).loadProductById(product.id.toString());
                context.push('/editProduct');
              },
            onDelete: () => _showDeleteConfirmation(context, ref, product),
            onToggleAvailability: () {
              /*ref.read(productProvider.notifier)
                  .toggleAvailability(product),*/
            }

          ),
        );
      }).toList(),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.restaurant_menu_outlined, size: 52, color: muted),
          SizedBox(height: 18),
          Text(
            'No hay productos en esta categoría',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Los productos que agregues a esta categoría aparecerán aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EDIT PRODUCT DIALOG
  // ==========================================================

  void _showEditProductDialog(
      BuildContext context,
      WidgetRef ref,
      Product product,
      ) {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: product.price.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_outlined, color: orange),
              SizedBox(width: 10),
              Text(
                'Editar producto',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: const Icon(Icons.restaurant_menu_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                final newPrice = double.tryParse(
                  priceController.text.replaceAll(',', '.'),
                );

                if (newName.isEmpty || newPrice == null || newPrice < 0) {
                  return;
                }

                /*await ref.read(productProvider.notifier).updateProduct(
                  product.id,
                  name: newName,
                  price: newPrice,
                );*/

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

  // ==========================================================
  // DELETE CONFIRMATION DIALOG
  // ==========================================================

  void _showDeleteConfirmation(
      BuildContext context,
      WidgetRef ref,
      Product product,
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
            '¿Estás seguro de que quieres eliminar "${product.name}"?\n\nEsta acción no se puede deshacer.',
            style: const TextStyle(color: muted, height: 1.4),
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
                await ref.read(productProvider.notifier).deleteProduct(product.id.toString());

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${product.name}" eliminado'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// PRODUCT CARD WIDGET
// ============================================================

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  static const orange = Color(0xFFE4572E);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  Image.network(
                    product.imageUrl!,
                    width: 115,
                    height: 115,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                  )
                else
                  _buildPlaceholderImage(),
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.45),
                      alignment: Alignment.center,
                      child: const Text(
                        'NO DISPONIBLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: orange,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: onToggleAvailability,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: product.isAvailable
                          ? const Color(0xFFEAF7EF)
                          : const Color(0xFFF5F5F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.isAvailable
                              ? Icons.check_circle_rounded
                              : Icons.remove_circle_outline,
                          size: 14,
                          color: product.isAvailable ? Colors.green : muted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          product.isAvailable ? 'Disponible' : 'No disponible',
                          style: TextStyle(
                            color: product.isAvailable ? Colors.green : muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Acciones (Editar / Eliminar)
          Column(
            children: [
              IconButton(
                tooltip: 'Editar producto',
                onPressed: onEdit,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF1EC),
                  foregroundColor: orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, size: 20),
              ),
              const SizedBox(height: 8),
              IconButton(
                tooltip: 'Eliminar producto',
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEEEE),
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 115,
      height: 115,
      color: const Color(0xFFFFE5DC),
      child: const Icon(Icons.restaurant, color: orange, size: 34),
    );
  }
}