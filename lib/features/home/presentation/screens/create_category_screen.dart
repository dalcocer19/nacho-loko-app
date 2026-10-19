import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../../domain/entities/category_entity.dart';
import '../providers/category_provider.dart';

class CreateCategoryScreen extends ConsumerWidget {
  const CreateCategoryScreen({super.key});

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controladores del formulario.
    //
    // Se mantienen como variables locales del build para que el widget
    // pueda utilizarse como ConsumerWidget sin necesidad de StatefulWidget.
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    // Estados dinámicos.
    final isSaving = ValueNotifier<bool>(false);
    final selectedImage = ValueNotifier<String?>(null);

    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: dark,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Nueva categoría',
          style: TextStyle(
            color: dark,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 720,
              ),

              child: Form(
                key: formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildFormCard(
                      nameController,
                      descriptionController,
                      selectedImage,
                    ),

                    const SizedBox(height: 22),

                    _buildActions(
                      context,
                      formKey,
                      nameController,
                      descriptionController,
                      selectedImage,
                      isSaving,
                      ref
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
          TabItem(
            title: 'Meseros',
            icon: Icons.supervisor_account_rounded,
          ),
          TabItem(
            title: 'Inicio',
            icon: Icons.home_rounded,
          ),
          TabItem(
            title: 'Contacto',
            icon: Icons.phone_rounded,
          ),
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
          const SizedBox(height: 22),

          _buildLabel(
            'Nombre de la categoría',
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: nameController,

            textCapitalization: TextCapitalization.words,

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa un nombre para la categoría';
              }

              return null;
            },

            decoration: _inputDecoration(
              hint: 'Ej. Tacos, Bebidas o Postres',
              icon: Icons.title_rounded,
            ),
          ),

          const SizedBox(height: 20),

          _buildLabel(
            'Descripción (opcional)',
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: descriptionController,

            maxLines: 4,
            maxLength: 180,

            decoration: _inputDecoration(
              hint: 'Describe brevemente los productos de esta categoría',
              icon: Icons.notes_rounded,
            ),
          ),

          /*const SizedBox(height: 10),

          _buildLabel(
            'Imagen de portada',
          ),

          const SizedBox(height: 8),

          _buildImagePicker(
            selectedImage,
          ),*/
        ],
      ),
    );
  }

  // ==========================================================
  // IMAGE PICKER
  // ==========================================================

  Widget _buildImagePicker(
      ValueNotifier<String?> selectedImage,
      ) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedImage,

      builder: (
          context,
          imagePath,
          _,
          ) {
        return InkWell(
          borderRadius: BorderRadius.circular(18),

          onTap: () => _selectImage(
            selectedImage,
          ),

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

            child: imagePath == null
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
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            )

                : Stack(
              fit: StackFit.expand,

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),

                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: muted,
                          size: 40,
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

                    icon: const Icon(
                      Icons.delete_outline_rounded,
                    ),
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
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ValueNotifier<bool> isSaving, WidgetRef ref,
      ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),

            style: OutlinedButton.styleFrom(
              foregroundColor: dark,

              side: BorderSide(
                color: dark.withValues(alpha: 0.18),
              ),

              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: isSaving,

            builder: (
                context,
                saving,
                _,
                ) {
              return ElevatedButton.icon(
                onPressed: saving
                    ? null
                    : () {
                  _saveCategory(
                    context,
                    formKey,
                    nameController,
                    descriptionController,
                    selectedImage,
                    isSaving,
                    ref
                  );
                },

                icon: saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.check_rounded,
                ),

                label: Text(
                  saving
                      ? 'Guardando...'
                      : 'Crear categoría',
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

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
  // LABEL
  // ==========================================================

  Widget _buildLabel(
      String text,
      ) {
    return Text(
      text,

      style: const TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        color: Color(0xFFA8A29E),
      ),

      prefixIcon: Icon(
        icon,
        color: orange,
      ),

      filled: true,

      fillColor: const Color(0xFFFAFAF9),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: BorderSide(
          color: dark.withValues(alpha: 0.08),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: const BorderSide(
          color: orange,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  // ==========================================================
  // SELECT IMAGE
  // ==========================================================

  void _selectImage(
      ValueNotifier<String?> selectedImage,
      ) {
    // Conecta aquí image_picker, cámara o tu servicio
    // de almacenamiento cuando lo implementes.

    selectedImage.value =
    'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85'
        '?auto=format&fit=crop&w=900&q=80';
  }

  // ==========================================================
  // SAVE CATEGORY
  // ==========================================================

  Future<void> _saveCategory(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController descriptionController,
      ValueNotifier<String?> selectedImage,
      ValueNotifier<bool> isSaving, WidgetRef ref,
      ) async {
    // 1. Validar formulario
    if (!formKey.currentState!.validate()) {
      return;
    }

    // 2. Activar estado de guardado
    isSaving.value = true;

    try {
      // 3. Obtener datos del formulario
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final imageUrl = selectedImage.value;

      CategoryEntity category = CategoryEntity(
        name: name,
        description: description, commerceId: 1,
      );

      await ref.read(categoryProvider.notifier).createCategory(category);

      isSaving.value = false;

      if (!context.mounted) {
        return;
      }

      // 4. Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Categoría creada correctamente',
          ),

          backgroundColor: Color(0xFF3D7A68),
        ),
      );
      await ref.read(categoryProvider.notifier).loadCategories();
      // 5. Volver a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      isSaving.value = false;

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al crear la categoría: $e',
          ),

          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}