import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final isTextVisibleProvider = StateProvider<bool>((ref) => false);

class Fadeanimation extends ConsumerStatefulWidget {
  const Fadeanimation({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FadeanimationState();
}

class _FadeanimationState extends ConsumerState<Fadeanimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeanimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,
    duration: Duration(seconds: 1));

    _fadeanimation= Tween<double>(begin: 0,end: 1).animate(_controller);

    Future.delayed(Duration(seconds:1),(){
      ref.read(isTextVisibleProvider.notifier).state =true;
      _controller.repeat(
        reverse: true,
        period: Duration(milliseconds: 2),
  
      );
    }
    
    
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(isTextVisibleProvider);
    return FadeTransition(opacity: _fadeanimation,
    alwaysIncludeSemantics: false,
    child: Text(visible? "Login":"",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),);


  }
}