import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/custom_drawer.dart';
import '../providers/category_provider.dart';
import 'list_categories_screen.dart';
import '../providers/commerce_provider.dart';

/*
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nacho Loko'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Error: CustomDrawer no está definido
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/nacho_loko.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ]
        )
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.pink,
        color: Colors.white70,
        activeColor: Colors.white,
        style: TabStyle.fixedCircle,
        items: [
          TabItem(title: 'Tab A', icon: Icons.add),
          TabItem(title: 'Tab B', icon: Icons.near_me),
          TabItem(title: 'Tab C', icon: Icons.web),
        ],
        initialActiveIndex: 1,
        //onTap: (int index) => _handleTabSelection(context, index, notificationState.unreadCount, ref),
      ),
    );
  }
}*/

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ==========================================================
  // COLORS
  // ==========================================================

  static const orange = Color(0xFFE4572E);
  static const yellow = Color(0xFFFFC857);
  static const cream = Color(0xFFFFF8EA);
  static const dark = Color(0xFF292524);
  static const muted = Color(0xFF78716C);
  static const lightBackground = Color(0xFFF8F7F5);

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EA),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,

        scrolledUnderElevation: 0,

        automaticallyImplyLeading: false,

        titleSpacing: 20,

        title: Row(
          children: [
            // Logo
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.circular(13),

                boxShadow: [
                  BoxShadow(
                    color: orange.withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: const Icon(
                Icons.restaurant_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Nacho Loko',
                  style: TextStyle(
                    color: dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  'Panel del restaurante',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          // Botón de menú
          Builder(
            builder: (context) {
              return Container(
                margin: const EdgeInsets.only(
                  right: 16,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),

                  border: Border.all(
                    color: dark.withValues(alpha: 0.06),
                  ),
                ),

                child: IconButton(
                  tooltip: 'Menú',
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: dark,
                  ),

                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            },
          ),
        ],
      ),

      // ======================================================
      // DRAWER
      // ======================================================

      drawer: const CustomDrawer(),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        top: false,

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 850,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // WELCOME SECTION
                  // ==================================================

                  _buildWelcomeSection(),

                  const SizedBox(height: 22),

                  // ==================================================
                  // HERO IMAGE
                  // ==================================================

                  _buildHeroCard(),

                  const SizedBox(height: 28),

                  // ==================================================
                  // SECTION TITLE
                  // ==================================================

                  _buildSectionHeader(),

                  const SizedBox(height: 14),

                  // ==================================================
                  // MAIN ACTIONS
                  // ==================================================

                  _buildMainActions(
                    context,
                    ref,
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // QUICK INFO
                  // ==================================================

                  _buildQuickInfo(),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: ConvexAppBar(
        backgroundColor: orange,

        color: Colors.white70,

        activeColor: Colors.white,

        style: TabStyle.fixedCircle,

        items: _buildBottomBarItems(),

        initialActiveIndex: 1,

        onTap: (int index) {
          _handleTabSelection(
            context,
            index,
            ref,
          );
        },
      ),
    );
  }

  // ==========================================================
  // WELCOME SECTION
  // ==========================================================

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          '¡Hola! 👋',
          style: TextStyle(
            color: muted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Bienvenido a tu restaurante',
          style: TextStyle(
            color: dark,
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Administra tu menú y mantén todo listo para tus clientes.',
          style: TextStyle(
            color: muted.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HERO CARD
  // ==========================================================

  Widget _buildHeroCard() {
    return Container(
      height: 205,
      width: double.infinity,

      clipBehavior: Clip.antiAlias,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        fit: StackFit.expand,

        children: [
          // Imagen
          Image.asset(
            'assets/nacho_loko.jpeg',
            fit: BoxFit.cover,

            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              return Container(
                color: orange,
              );
            },
          ),

          // Degradado oscuro
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,

                colors: [
                  Colors.black.withValues(alpha: 0.70),
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                ],

                stops: const [
                  0.0,
                  0.55,
                  1.0,
                ],
              ),
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(22),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Text(
                    'SABOR MEXICANO',
                    style: TextStyle(
                      color: dark,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'El sabor que hace\nla diferencia.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _buildSectionHeader() {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                '¿Qué quieres hacer?',
                style: TextStyle(
                  color: dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: 3),

              Text(
                'Gestiona tu restaurante desde aquí',
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MAIN ACTIONS
  // ==========================================================

  Widget _buildMainActions(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Column(
      children: [
        // ====================================================
        // MENU DIGITAL
        // ====================================================

        _buildActionCard(
          icon: Icons.restaurant_menu_rounded,

          title: 'Menú digital',

          description:
          'Administra categorías, productos, precios e imágenes.',

          iconBackground: orange,

          onTap: () {
            ref
                .read(categoryProvider.notifier)
                .loadCategories();

            context.push('/menu');
          },
        ),

        const SizedBox(height: 14),

        // ====================================================
        // PEDIDOS
        // ====================================================

        _buildActionCard(
          icon: Icons.room_service_rounded,

          title: 'Pedidos',

          description:
          'Consulta y realiza un seguimiento de los pedidos.',

          iconBackground: dark,

          onTap: () {
            // Próximamente
          },
        ),
      ],
    );
  }

  // ==========================================================
  // ACTION CARD
  // ==========================================================

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,

      borderRadius: BorderRadius.circular(22),

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: onTap,

        child: Ink(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: dark.withValues(alpha: 0.055),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),

          child: Row(
            children: [
              // Icono
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(width: 16),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        color: dark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: muted,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Flecha
              Container(
                width: 36,
                height: 36,

                decoration: BoxDecoration(
                  color: lightBackground,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: dark,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // QUICK INFO
  // ==========================================================

  Widget _buildQuickInfo() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cream,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: orange.withValues(alpha: 0.10),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: yellow.withValues(alpha: 0.75),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: dark,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Consejo',
                  style: TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Mantén actualizados los precios y la disponibilidad de tus productos.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM BAR
  // ==========================================================

  Future<void> _handleTabSelection(
      BuildContext context,
      int index,
      WidgetRef ref,
      ) async {
    final items = _buildBottomBarItems();

    // Asegurarnos de que el índice sea válido
    if (index < 0 || index >= items.length) {
      return;
    }

    switch (items[index].title) {
      case 'Meseros':
        context.go('/userProfile');
        break;

      case 'Inicio':
        context.go('/home');
        break;

      case 'Contacto':
        ref
            .read(commerceProvider.notifier)
            .loadCommerce('1');

        context.push('/restaurant');
        break;
    }
  }

  // ==========================================================
  // BOTTOM BAR ITEMS
  // ==========================================================

  List<TabItem> _buildBottomBarItems() {
    return const [
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
    ];
  }
}
