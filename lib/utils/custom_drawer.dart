import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  static const Color orange = Color(0xFFE4572E);
  static const Color yellow = Color(0xFFFFC857);
  static const Color dark = Color(0xFF292524);
  static const Color cream = Color(0xFFFFF8EA);
  static const Color background = Color(0xFFF8F7F5);
  static const Color muted = Color(0xFF78716C);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: background,
      width: MediaQuery.of(context).size.width * 0.84,
      elevation: 0,

      child: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            const _DrawerHeader(),

            // ==================================================
            // MENU
            // ==================================================

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  16,
                  22,
                  16,
                  16,
                ),

                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      bottom: 10,
                    ),

                    child: Text(
                      'MENÚ PRINCIPAL',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // ==================================================
                  // INICIO
                  // ==================================================

                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Inicio',
                    subtitle: 'Panel principal',

                    onTap: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),

                  // ==================================================
                  // MENÚ DIGITAL
                  // ==================================================

                  _DrawerItem(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'Menú digital',
                    subtitle: 'Categorías y productos',
                    highlighted: true,

                    onTap: () {
                      Navigator.pop(context);
                      context.push('/menu');
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // ADMINISTRACIÓN
                  // ==================================================

                  const Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      bottom: 10,
                    ),

                    child: Text(
                      'ADMINISTRACIÓN',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // ==================================================
                  // PEDIDOS
                  // ==================================================

                  _DrawerItem(
                    icon: Icons.room_service_rounded,
                    title: 'Pedidos',
                    subtitle: 'Gestiona los pedidos',

                    onTap: () {
                      //Navigator.pop(context);

                      // Agrega aquí la ruta cuando
                      // tengas implementada la pantalla.
                      //
                      // context.push('/orders');
                    },
                  ),

                  // ==================================================
                  // MESEROS
                  // ==================================================

                  _DrawerItem(
                    icon: Icons.supervisor_account_rounded,
                    title: 'Meseros',
                    subtitle: 'Gestiona el personal',

                    onTap: () {
                      // Navigator.pop(context);
                      // context.go('/userProfile');
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // RESTAURANTE
                  // ==================================================

                  const Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      bottom: 10,
                    ),

                    child: Text(
                      'RESTAURANTE',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // ==================================================
                  // CONTACTO
                  // ==================================================

                  _DrawerItem(
                    icon: Icons.phone_rounded,
                    title: 'Contacto',
                    subtitle: 'Información del restaurante',

                    onTap: () {
                      //Navigator.pop(context);

                      // Agrega aquí la navegación
                      // cuando tengas implementada
                      // la pantalla de contacto.
                    },
                  ),

                  // ==================================================
                  // UBICACIÓN
                  // ==================================================

                  /*_DrawerItem(
                    icon: Icons.location_on_rounded,
                    title: 'Ubicación',
                    subtitle: 'Encuentra nuestro restaurante',

                    onTap: () {
                      Navigator.pop(context);

                      // Agrega aquí la navegación
                      // cuando tengas implementada
                      // la pantalla de ubicación.
                    },
                  ),*/
                ],
              ),
            ),

            // ==================================================
            // FOOTER
            // ==================================================

            const _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DRAWER HEADER
// ============================================================

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        18,
        22,
      ),

      decoration: const BoxDecoration(
        color: CustomDrawer.orange,

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // TOP ROW
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              // Logo
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: CustomDrawer.yellow,

                  borderRadius: BorderRadius.circular(17),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.restaurant_rounded,
                  color: CustomDrawer.dark,
                  size: 29,
                ),
              ),

              // Botón cerrar
              Material(
                color: Colors.white.withValues(
                  alpha: 0.12,
                ),

                borderRadius: BorderRadius.circular(12),

                child: InkWell(
                  borderRadius: BorderRadius.circular(12),

                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(9),

                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ==================================================
          // RESTAURANT NAME
          // ==================================================

          const Text(
            'Nacho Loko',

            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Panel de administración',

            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================
          // USER CARD
          // ==================================================

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),

              borderRadius: BorderRadius.circular(15),

              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.10,
                ),
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.person_rounded,
                    color: CustomDrawer.orange,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 11),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Lidia Cesari',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        'Administradora',

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.verified_rounded,
                  color: CustomDrawer.yellow,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DRAWER ITEM
// ============================================================

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),

      child: Material(
        color: highlighted
            ? CustomDrawer.orange.withValues(
          alpha: 0.10,
        )
            : Colors.transparent,

        borderRadius: BorderRadius.circular(17),

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(17),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 11,
            ),

            child: Row(
              children: [
                // ==================================================
                // ICON
                // ==================================================

                Container(
                  width: 44,
                  height: 44,

                  decoration: BoxDecoration(
                    color: highlighted
                        ? CustomDrawer.orange
                        : Colors.white,

                    borderRadius: BorderRadius.circular(13),

                    border: highlighted
                        ? null
                        : Border.all(
                      color: CustomDrawer.dark
                          .withValues(
                        alpha: 0.05,
                      ),
                    ),

                    boxShadow: highlighted
                        ? [
                      BoxShadow(
                        color: CustomDrawer.orange
                            .withValues(
                          alpha: 0.20,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),

                  child: Icon(
                    icon,

                    size: 21,

                    color: highlighted
                        ? Colors.white
                        : CustomDrawer.dark.withValues(
                      alpha: 0.68,
                    ),
                  ),
                ),

                const SizedBox(width: 13),

                // ==================================================
                // TEXT
                // ==================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,

                        style: TextStyle(
                          color: highlighted
                              ? CustomDrawer.orange
                              : CustomDrawer.dark,

                          fontSize: 14,

                          fontWeight: highlighted
                              ? FontWeight.w900
                              : FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        subtitle,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          color: CustomDrawer.muted
                              .withValues(
                            alpha: 0.85,
                          ),

                          fontSize: 11,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // ARROW
                // ==================================================

                Icon(
                  Icons.chevron_right_rounded,

                  size: 21,

                  color: highlighted
                      ? CustomDrawer.orange
                      : CustomDrawer.dark.withValues(
                    alpha: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DRAWER FOOTER
// ============================================================

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        8,
        22,
        20,
      ),

      child: Column(
        children: [
          Divider(
            color: CustomDrawer.dark.withValues(
              alpha: 0.08,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              Container(
                width: 26,
                height: 26,

                decoration: BoxDecoration(
                  color: CustomDrawer.orange
                      .withValues(alpha: 0.10),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Icon(
                  Icons.restaurant_rounded,
                  color: CustomDrawer.orange,
                  size: 14,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                'Nacho Loko',

                style: TextStyle(
                  color: CustomDrawer.dark.withValues(
                    alpha: 0.65,
                  ),

                  fontSize: 11,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '© Desarrollado por DA',

            style: TextStyle(
              color: CustomDrawer.dark.withValues(
                alpha: 0.38,
              ),

              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}