// lib/features/perfil/presentation/screens/perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../providers/perfil_provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar perfil al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilProvider>().loadPerfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Si no está autenticado, mostrar pantalla de login
        if (!authProvider.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mi Perfil'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No has iniciado sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia sesión para ver tu perfil',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/login');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Si está autenticado, mostrar el perfil
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await context.push('/edit-perfil');
                  // Recargar perfil después de editar
                  if (context.mounted) {
                    context.read<PerfilProvider>().reload();
                  }
                },
                tooltip: 'Editar perfil',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PerfilProvider>().reload();
                },
                tooltip: 'Recargar',
              ),
            ],
          ),
          body: Consumer<PerfilProvider>(
            builder: (context, provider, child) {
              // Loading state
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (provider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar perfil',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => provider.reload(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              // No data state
              if (!provider.hasPerfil) {
                return const Center(
                  child: Text(
                    'No se encontró información del perfil',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // Success state
              final perfil = provider.perfil!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Avatar y nombre
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundImage:
                                  perfil.photo_url != null &&
                                          perfil.photo_url!.isNotEmpty
                                      ? NetworkImage(perfil.photo_url!)
                                      : null,
                              child:
                                  perfil.photo_url == null ||
                                          perfil.photo_url!.isEmpty
                                      ? Text(
                                        perfil.first_name.isNotEmpty
                                            ? perfil.first_name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 16),

                            // Nombre completo
                            Text(
                              '${perfil.first_name} ${perfil.last_name}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // Username
                            Text(
                              '@${perfil.username}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Información de contacto
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text('Email'),
                            subtitle: Text(perfil.email),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Nombre'),
                            subtitle: Text(perfil.first_name),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Apellido'),
                            subtitle: Text(perfil.last_name),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.badge),
                            title: const Text('Usuario'),
                            subtitle: Text(perfil.username),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Información adicional
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.fingerprint),
                            title: const Text('ID de Usuario'),
                            subtitle: Text(perfil.id.toString()),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('Último acceso'),
                            subtitle: Text(perfil.last_login ?? 'Nunca'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón de Cerrar Sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Confirmar logout
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Cerrar Sesión'),
                                  content: const Text(
                                    '¿Estás seguro que deseas cerrar sesión?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text('Cerrar Sesión'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true && context.mounted) {
                            await context.read<AuthProvider>().logout();
                            if (context.mounted) {
                              // Navegar a habitaciones
                              context.go('/habitaciones');
                            }
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar Sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
