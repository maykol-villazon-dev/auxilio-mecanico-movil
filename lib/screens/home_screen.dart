import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // CU-02 móvil: Logout
  // Esta función elimina el token y cierra la sesión del usuario
  Future<void> _handleLogout(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final isMecanico = user?.rol == 'mecanico';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auxilio Mecánico', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Cerrar Sesión',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: user == null 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bienvenida dinámica según rol
                Text(
                  'Hola, ${user.nombre}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(isMecanico 
                  ? 'Panel de Control - Personal Técnico' 
                  : '¿En qué podemos ayudarte hoy?'),
                
                const SizedBox(height: 32),
                
                // Dashboard diferenciado por ROL
                if (isMecanico) 
                  _buildMecanicoDashboard(context)
                else 
                  _buildClienteDashboard(context),
                
                const SizedBox(height: 32),
                
                // Sección de Incidentes Activos
                Text(
                  isMecanico ? 'Servicios Asignados' : 'Mis Servicios en Curso',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildActiveServiceCard(context, isMecanico),
              ],
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.brandPrimary,
        unselectedItemColor: AppColors.textSecondary.withOpacity(0.5),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          if (!isMecanico) const BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Mapa'),
          if (isMecanico) const BottomNavigationBarItem(icon: Icon(Icons.build_circle_rounded), label: 'Tareas'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildClienteDashboard(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard('Solicitar Auxilio', Icons.emergency_rounded, AppColors.brandPrimary),
        _buildActionCard('Mis Vehículos', Icons.directions_car_rounded, AppColors.warning),
        _buildActionCard('Historial', Icons.history_rounded, AppColors.success),
        _buildActionCard('Pagos', Icons.payment_rounded, AppColors.textSecondary),
      ],
    );
  }

  Widget _buildMecanicoDashboard(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard('Tareas Pendientes', Icons.assignment_rounded, AppColors.brandPrimary),
        _buildActionCard('Mi Disponibilidad', Icons.event_available_rounded, AppColors.success),
        _buildActionCard('Reportes', Icons.assessment_rounded, AppColors.warning),
        _buildActionCard('Herramientas', Icons.build_rounded, AppColors.textSecondary),
      ],
    );
  }

  Widget _buildActiveServiceCard(BuildContext context, bool isMecanico) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.brandLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isMecanico ? Icons.build_rounded : Icons.location_on_rounded, 
                color: AppColors.brandPrimary
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMecanico ? 'Atendiendo Incidente #102' : 'Remolque en camino', 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Text(
                    isMecanico ? 'Ubicación: Av. Bush' : 'Llegada estimada: 15 min', 
                    style: const TextStyle(fontSize: 12)
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
