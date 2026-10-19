import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nacho_loko/features/home/presentation/providers/commerce_provider.dart';
import 'package:nacho_loko/features/home/presentation/states/commerce_state.dart';

class EditCommerceScreen extends ConsumerStatefulWidget {
  const EditCommerceScreen({super.key});

  @override
  ConsumerState<EditCommerceScreen> createState() =>
      _EditCommerceScreenState();
}

class _EditCommerceScreenState
    extends ConsumerState<EditCommerceScreen> {
  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedImage;
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Asignar datos del estado actual a los controladores al iniciar el widget
    final commerce = ref.read(commerceProvider).commerce;
    if (commerce != null) {
      nameController.text = commerce.name ?? '';
      descriptionController.text = commerce.description ?? '';
      phoneController.text = commerce.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aquí puedes acceder a tus providers mediante ref.watch() o ref.read()
    // Ej: final restaurantState = ref.watch(restaurantProvider);
    final state = ref.watch(commerceProvider);
    nameController.text = state.commerce?.name ?? '';
    descriptionController.text = state.commerce?.description ?? '';
    phoneController.text = state.commerce?.phone ?? '';

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 3. Opcional: Mostrar error si ocurrió alguno
    if (state.errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error: ${state.errorMessage}')));
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: dark),
        ),
        title: const Text(
          'Editar información',
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
                    // _buildIntro(),
                    // const SizedBox(height: 28),
                    _buildForm(state),
                    const SizedBox(height: 22),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
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
        await ref.read(commerceProvider.notifier).loadCommerce('1');
        context.go('/restaurant');
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

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: orange,
            size: 32,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Crea tu restaurante',
          style: TextStyle(
            color: dark,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Agrega la información principal de tu restaurante para '
              'presentarlo de forma atractiva a tus clientes.',
          style: TextStyle(
            color: muted,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(CommerceState state) {
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
          _buildLabel('Nombre del restaurante'),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre del restaurante';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Ej. Nacho Loko',
              icon: Icons.storefront_outlined,
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Celular'),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneController,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre del restaurante';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Nro de celular',
              icon: Icons.phone_android,
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Descripción'),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            maxLines: 5,
            maxLength: 250,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa una descripción';
              }
              return null;
            },
            decoration: _inputDecoration(
              hint:
              'Cuéntales a tus clientes qué hace especial a tu restaurante',
              icon: Icons.description_outlined,
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel('Imagen del restaurante'),
          const SizedBox(height: 8),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _selectImage,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: double.infinity,
        height: 210,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1EB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: orange.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: yellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: dark,
                size: 30,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Subir imagen',
              style: TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
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
                selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                onPressed: () {
                  setState(() => selectedImage = null);
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
  }

  Widget _buildActions() {
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
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : _saveRestaurant,
            icon: isSaving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.check_rounded),
            label: Text(isSaving ? 'Guardando...' : 'Crear restaurante'),
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

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
    );
  }

  void _selectImage() {
    setState(() {
      selectedImage =
      'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f'
          '?auto=format&fit=crop&w=1000&q=80';
    });
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    // Ejemplo de llamada a Riverpod durante la acción de guardado:
    // await ref.read(restaurantNotifierProvider.notifier).createRestaurant(
    //   name: nameController.text,
    //   description: descriptionController.text,
    //   imageUrl: selectedImage,
    // );

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() => isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restaurante creado correctamente'),
        backgroundColor: Color(0xFF3D7A68),
      ),
    );

    Navigator.pop(context);
  }
}