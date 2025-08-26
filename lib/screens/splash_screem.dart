// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:medb_app/provider/auth_provider.dart';


// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     // Simulate splash screen delay
//     await Future.delayed(const Duration(seconds: 2));
    
//     if (mounted) {
//       final authState = ref.read(authNotifierProvider);
      
//       if (authState.isAuthenticated) {
//         context.go('/dashboard');
//       } else {
//         context.go('/login');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Scaffold(
//       backgroundColor: theme.colorScheme.primary,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Logo/Brand
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Text(
//                   'MedB',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2E86AB),
//                   ),
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 48),
            
//             // Loading indicator
//             LoadingAnimationWidget.fourRotatingDots(
//               color: Colors.white,
//               size: 40,
//             ),
            
//             const SizedBox(height: 24),
            
//             Text(
//               'Loading...',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white.withOpacity(0.8),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }