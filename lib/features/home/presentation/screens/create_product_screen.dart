import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/product.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';

class CreateProductScreen extends ConsumerWidget {
  const CreateProductScreen({super.key});

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  // Clave del formulario
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controladores de texto
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    // Notifier locales para manejar el estado de la UI (imagen y estado de guardado)
    final selectedImage = ValueNotifier<String?>(null);
    final isSaving = ValueNotifier<bool>(false);

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
          'Nuevo producto',
          style: TextStyle(
            color: dark,
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
                    _buildFormCard(
                      nameController,
                      priceController,
                      descriptionController,
                      selectedImage,
                    ),
                    const SizedBox(height: 22),
                    _buildActions(
                      context,
                      ref,
                      _formKey,
                      nameController,
                      priceController,
                      descriptionController,
                      selectedImage,
                      isSaving,
                    ),
                  ],
                ),
              ),
            ),
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
  // FORM CARD
  // ==========================================================

  Widget _buildFormCard(
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: dark.withValues(alpha: 0.06),
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
              hint: 'Ej. Hamburguesa Clásica, Taco al Pastor',
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
          _buildImagePicker(selectedImage),
        ],
      ),
    );
  }

  // ==========================================================
  // IMAGE PICKER
  // ==========================================================

  /*Widget _buildImagePicker(ValueNotifier<String?> selectedImage) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedImage,
      builder: (context, image, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // Ejemplo de asignación de imagen
            selectedImage.value =
            'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85'
                '?auto=format&fit=crop&w=900&q=80';
          },
          child: Ink(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EB),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: orange.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: image == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: yellow.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: dark,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Agregar imagen',
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'JPG o PNG · Recomendado 1200 × 800 px',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            )
                : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.network(image, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => selectedImage.value = null,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: orange,
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
  }*/

  Widget _buildImagePicker(
      ValueNotifier<String?> selectedImage, {
        String? initialNetworkUrl,
      }) {
    final ImagePicker picker = ImagePicker();

    Future<void> pickImageFromGallery() async {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Guardamos la ruta local en el ValueNotifier<String?>
        selectedImage.value = pickedFile.path;
      }
    }

    return ValueListenableBuilder<String?>(
      valueListenable: selectedImage,
      builder: (context, imagePath, _) {
        // Si la ruta local empieza por 'http', es una URL remota.
        // Si no, verificamos si hay una imagen seleccionada o una imagen inicial de la red.
        final bool hasSelectedPath = imagePath != null && imagePath.isNotEmpty;
        final bool isLocalFile = hasSelectedPath && !imagePath.startsWith('http');
        final bool hasNetworkImage = initialNetworkUrl != null && initialNetworkUrl.isNotEmpty;

        final bool hasAnyImage = hasSelectedPath || hasNetworkImage;

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
                color: orange.withValues(alpha: 0.35),
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
                    color: yellow.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: dark,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cambiar imagen',
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'JPG o PNG · Recomendado 1200 × 800 px',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            )
                : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Builder(
                    builder: (_) {
                      if (isLocalFile) {
                        return Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        );
                      }

                      // Si la imagen seleccionada es una URL de red o se usa la de initialNetworkUrl
                      final String url = hasSelectedPath ? imagePath : initialNetworkUrl!;
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image_rounded, color: muted, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      selectedImage.value = null;
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: orange,
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

  Widget _buildActions(
      BuildContext context,
      WidgetRef ref,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ValueNotifier<bool> isSaving,
      ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: dark,
              side: BorderSide(color: dark.withValues(alpha: 0.18)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: isSaving,
            builder: (context, saving, _) {
              return ElevatedButton.icon(
                onPressed: saving
                    ? null
                    : () => _saveProduct(
                  context,
                  ref,
                  formKey,
                  nameController,
                  priceController,
                  descriptionController,
                  selectedImage,
                  isSaving,
                ),
                icon: saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.check_rounded),
                label: Text(saving ? 'Guardando...' : 'Crear producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFA8A29E)),
      prefixIcon: Icon(icon, color: orange),
      filled: true,
      fillColor: const Color(0xFFFAFAF9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: dark.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  // ==========================================================
  // SAVE ACTION
  // ==========================================================

  /*Future<void> _saveProduct(
      BuildContext context,
      WidgetRef ref,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ValueNotifier<bool> isSaving,
      ) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    final name = nameController.text.trim();
    final price = double.parse(priceController.text.replaceAll(',', '.'));
    final description = descriptionController.text.trim();
    final imageUrl = selectedImage.value;

    // Llamada al notifier de Riverpod para insertar en Supabase
    // await ref.read(productProvider.notifier).addProduct(
    //   name: name,
    //   price: price,
    //   description: description,
    //   imageUrl: imageUrl,
    // );
    final categoryState = ref.watch(categoryProvider);
    print("id de la categoria ${categoryState.category!.id}");
    Product prod = Product(
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text.replaceAll(',', '.')),
      imageUrl: null,
      categoryId: categoryState.category!.id!,
      isAvailable: true,
    );
    print("producto que quiero guardar: ${prod.name}, ${prod.description}, ${prod.price}, ${prod.imageUrl}, ${prod.categoryId}, ${prod.isAvailable}");
    ref.read(productProvider.notifier).createProduct(prod);

    isSaving.value = false;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto creado correctamente'),
          backgroundColor: Color(0xFF3D7A68),
        ),
      );
      Navigator.pop(context);
    }
  }*/

  Future<void> _saveProduct(
      BuildContext context,
      WidgetRef ref,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ValueNotifier<bool> isSaving,
      ) async {
    print('holaaaaaa');
    // 1. Validar el formulario
    if (!formKey.currentState!.validate()) {
      print('no valido');
    }

    isSaving.value = true;

    try {
      print('dentro del try');
      // 2. Extraer los valores de los controladores
      final name = nameController.text.trim();
      final price = double.parse(priceController.text.replaceAll(',', '.'));
      final description = descriptionController.text.trim();
      final imageUrl = selectedImage.value; // Puede ser ruta local o URL

      final currentCategory = ref.read(categoryProvider);

      // 4. Construir la entidad/modelo del producto con los datos actualizados
      final updatedProd = Product(
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl, // Se conserva la imagen base del estado
        categoryId: currentCategory.category!.id!,
        isAvailable: true,
      );
      print("producto que quiero guardar: ${updatedProd.name}, ${updatedProd.description}, ${updatedProd.price}, ${updatedProd.imageUrl}, ${updatedProd.categoryId}, ${updatedProd.isAvailable}");
      // 5. Invocación al Notifier de Riverpod para actualizar (enviando la ruta de la imagen)
      await ref.read(productProvider.notifier).createProduct(updatedProd);

      isSaving.value = false;

      // 6. Notificar al usuario y cerrar la pantalla
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto actualizado correctamente'),
            backgroundColor: Color(0xFF3D7A68),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('erro en pantalla de creacion $e');
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
}