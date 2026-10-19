import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nacho_loko/features/home/presentation/providers/category_provider.dart';
import 'package:nacho_loko/features/home/presentation/states/product_state.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

// Asume la existencia del modelo Product
// class Product { final String id; final String name; final double price; final String description; final String? imageUrl; final bool isAvailable; ... }

class EditProductScreen extends ConsumerStatefulWidget {
  const EditProductScreen({super.key});

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // ==========================================================
  // Controladores y notifiers: se crean UNA sola vez (initState),
  // NO en build(), para que no se reinicien con cada rebuild
  // provocado por ref.watch(productProvider).
  // ==========================================================
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final ValueNotifier<String?> selectedImage;
  late final ValueNotifier<bool> isAvailable;
  final ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  bool _initialized = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    selectedImage.dispose();
    isAvailable.dispose();
    isSaving.dispose();
    super.dispose();
  }

  void _initControllers(productState) {
    if (_initialized) return;
    nameController = TextEditingController(text: productState.product?.name);
    priceController = TextEditingController(
      text: productState.product?.price.toStringAsFixed(2),
    );
    descriptionController =
        TextEditingController(text: productState.product?.description);
    selectedImage = ValueNotifier<String?>(productState.product?.imageUrl);
    isAvailable = ValueNotifier<bool>(productState.product?.isAvailable ?? true);
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    // Mientras carga por primera vez (antes de tener el producto), mostramos loader.
    if (productState.isLoading && !_initialized) {
      return const Scaffold(
        backgroundColor: EditProductScreen.cream,
        body: Center(
          child: CircularProgressIndicator(color: EditProductScreen.orange),
        ),
      );
    }

    // Inicializamos los controladores una sola vez, con los datos
    // que llegaron la PRIMERA vez que hay producto disponible.
    _initControllers(productState);

    return Scaffold(
      backgroundColor: EditProductScreen.cream,
      appBar: AppBar(
        backgroundColor: EditProductScreen.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: EditProductScreen.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar producto',
          style: TextStyle(
            color: EditProductScreen.dark,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormCard(productState),
                    const SizedBox(height: 22),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: EditProductScreen.orange,
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
  // FORM CARD
  // ==========================================================

  Widget _buildFormCard(productState) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: EditProductScreen.dark.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Nombre del producto'),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre del producto';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Ej. Hamburguesa Clásica',
              icon: Icons.restaurant_menu_rounded,
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Precio'),
          const SizedBox(height: 8),
          TextFormField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa un precio';
              }
              final price = double.tryParse(value.replaceAll(',', '.'));
              if (price == null || price < 0) {
                return 'Ingresa un precio válido';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: '0.00',
              icon: Icons.attach_money_rounded,
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Disponibilidad'),
          const SizedBox(height: 8),
          _buildAvailabilitySwitch(),
          const SizedBox(height: 20),
          _buildLabel('Descripción (opcional)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            maxLines: 3,
            maxLength: 180,
            decoration: _inputDecoration(
              hint: 'Describe los ingredientes o características del platillo',
              icon: Icons.notes_rounded,
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel('Imagen del producto'),
          const SizedBox(height: 8),
          _buildImagePicker(),
        ],
      ),
    );
  }

  // ==========================================================
  // AVAILABILITY SWITCH
  // ==========================================================

  Widget _buildAvailabilitySwitch() {
    return ValueListenableBuilder<bool>(
      valueListenable: isAvailable,
      builder: (context, available, _) {
        return InkWell(
          onTap: () => isAvailable.value = !available,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: available ? const Color(0xFFEAF7EF) : const Color(0xFFFAFAF9),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: available
                    ? Colors.green.withValues(alpha: 0.4)
                    : EditProductScreen.dark.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  available ? Icons.check_circle_rounded : Icons.remove_circle_outline,
                  color: available ? Colors.green : EditProductScreen.muted,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        available ? 'Disponible' : 'No disponible',
                        style: TextStyle(
                          color: available ? Colors.green.shade800 : EditProductScreen.dark,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        available
                            ? 'El producto aparecerá visible en el menú digital'
                            : 'El producto se ocultará a los clientes',
                        style: const TextStyle(color: EditProductScreen.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: available,
                  activeColor: Colors.green,
                  onChanged: (value) => isAvailable.value = value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // IMAGE PICKER
  // ==========================================================

  Widget _buildImagePicker() {
    final ImagePicker picker = ImagePicker();

    Future<void> pickImageFromGallery() async {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = pickedFile.path;
      }
    }

    return ValueListenableBuilder<String?>(
      valueListenable: selectedImage,
      builder: (context, imagePath, _) {
        final bool hasSelectedPath = imagePath != null && imagePath.isNotEmpty;
        final bool isLocalFile = hasSelectedPath && !imagePath.startsWith('http');
        final bool hasAnyImage = hasSelectedPath;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: pickImageFromGallery,
          child: Ink(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EB),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: EditProductScreen.orange.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: !hasAnyImage
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: EditProductScreen.yellow.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: EditProductScreen.dark,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cambiar imagen',
                  style: TextStyle(
                    color: EditProductScreen.dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'JPG o PNG · Recomendado 1200 × 800 px',
                  style: TextStyle(color: EditProductScreen.muted, fontSize: 12),
                ),
              ],
            )
                : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: isLocalFile
                      ? Image.file(File(imagePath), fit: BoxFit.cover)
                      : Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_rounded,
                          color: EditProductScreen.muted, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => selectedImage.value = null,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: EditProductScreen.orange,
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // ACTIONS BUTTONS
  // ==========================================================

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: EditProductScreen.dark,
              side: BorderSide(color: EditProductScreen.dark.withValues(alpha: 0.18)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: isSaving,
            builder: (context, saving, _) {
              return ElevatedButton.icon(
                onPressed: saving ? null : () => _updateProduct(context),
                icon: saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.save_rounded),
                label: Text(saving ? 'Guardando...' : 'Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EditProductScreen.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HELPER METHODS
  // ==========================================================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: EditProductScreen.dark,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFA8A29E)),
      prefixIcon: Icon(icon, color: EditProductScreen.orange),
      filled: true,
      fillColor: const Color(0xFFFAFAF9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: EditProductScreen.dark.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: EditProductScreen.orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  // ==========================================================
  // UPDATE ACTION
  // ==========================================================
  Future<void> _updateProduct(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final name = nameController.text.trim();
      final price = double.parse(priceController.text.replaceAll(',', '.'));
      final description = descriptionController.text.trim();
      final imageUrl = selectedImage.value;
      final available = isAvailable.value;

      final currentProductState = ref.read(productProvider);
      final currentProduct = currentProductState.product;

      if (currentProduct == null || currentProduct.id == null) {
        isSaving.value = false;
        return;
      }

      final updatedProduct = Product(
        id: currentProduct.id,
        name: name,
        price: price,
        description: description,
        // FIX: usar el valor nuevo (imageUrl) en vez de currentProduct.imageUrl,
        // que era el bug que ignoraba la imagen recién seleccionada.
        imageUrl: imageUrl,
        categoryId: currentProduct.categoryId,
        isAvailable: available,
      );

      await ref.read(productProvider.notifier).updateProduct(
        updatedProduct,
        imagePath: imageUrl,
      );

      isSaving.value = false;

      if (context.mounted) {
        _showUpdateConfirmation(context, updatedProduct);
      }
    } catch (e) {
      isSaving.value = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el producto: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showUpdateConfirmation(BuildContext context, Product currentProduct) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF3D7A68), size: 28),
              SizedBox(width: 10),
              Text('¡Actualización exitosa!',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          content: Text(
            'El producto "${currentProduct.name}" se actualizó correctamente.',
            style: const TextStyle(color: EditProductScreen.muted, height: 1.4),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: EditProductScreen.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await ref
                    .read(productProvider.notifier)
                    .loadProductsByCategory(currentProduct.categoryId.toString());

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}