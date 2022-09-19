/**
 *  ██████╗ ██╗████████╗███████╗ █████╗  ██████╗████████╗ ██████╗ ██████╗ ██╗   ██╗",
 *  ██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝",
 *  ██████╔╝██║   ██║   █████╗  ███████║██║        ██║   ██║   ██║██████╔╝ ╚████╔╝",
 *  ██╔══██╗██║   ██║   ██╔══╝  ██╔══██║██║        ██║   ██║   ██║██╔══██╗  ╚██╔╝",
 *  ██████╔╝██║   ██║   ██║     ██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║   ██║",
 *  ╚═════╝ ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝",
 *
 * Copyright (c) 2022 Bitfactory GmbH. All rights reserved.",
 * https://www.bitfactory.io",
 *
 * Redistribution and use in source and binary forms, with or without",
 * modification, are not permitted.",
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS",
 * 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT",
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS",
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE",
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,",
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,",
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;",
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER",
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT",
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN",
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE",
 * POSSIBILITY OF SUCH DAMAGE.",
 *
 *   ",
 *
 *  --> Kaefer

 *   Created by KARIM on 16,September,2022",
 */
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_recap/data/models/character_model.dart';
import 'package:flutter_bloc_recap/presentation/screens/character_details.dart';
import 'package:flutter_bloc_recap/presentation/screens/characters_screen.dart';
import 'business_logic/characters_cubit.dart';
import 'constants/strings.dart';
import 'data/repository/characters_repo.dart';
import 'data/web_service/character_web_service.dart';

class AppRouter {
  late CharactersCubit cubit;
  late CharactersRepo repo;
  
  AppRouter() {
  repo = CharactersRepo(CharactersWebServices());
  cubit = CharactersCubit(repo);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutingStrings.charactersScreen:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(create: (BuildContext context) => cubit,
            child: const CharactersScreen(),)
        );

      case RoutingStrings.charactersDetailsScreen:
        final character = settings.arguments as CharactersModel;
        return MaterialPageRoute(builder: (_) =>
         BlocProvider(create: (BuildContext context) => cubit,
             child: CharacterDetailsScreen(character: character) ));
    }
    return null;
  }
}
