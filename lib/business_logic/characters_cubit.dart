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

 *   Created by KARIM on 15,September,2022",
 */
///

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import '../data/models/character_model.dart';
import '../data/models/quote_model.dart';
import '../data/repository/characters_repo.dart';

part 'characteers_state.dart';

class CharactersCubit extends Cubit<CharactersState> {

  final CharactersRepo repo;
  List<CharactersModel> charactersDataList = [];
  CharactersCubit(this.repo) : super(CharactersInitial());

  void getAllData() {
    repo.getData().then((charactersList)  {
     emit(CharactersLoaded(charactersList));
     charactersDataList = charactersList;
    });
  }

  void getQuotesList(String characterName) {
    repo.getCharacterQuotes(characterName).then((value) => (){
      emit(QuotesLoadedState(value));
    });
  }
}
