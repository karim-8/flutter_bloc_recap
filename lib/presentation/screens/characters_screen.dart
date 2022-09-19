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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_recap/constants/colors.dart';
import 'package:flutter_bloc_recap/constants/strings.dart';

import '../../business_logic/characters_cubit.dart';
import '../../data/models/character_model.dart';
import 'character_item.dart';
class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {

  List<CharactersModel>? allCharacters;
  List<CharactersModel>? userSearchResults;
  final searchTextEditController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    ///1- Fire the service method get data inside the cubit
   BlocProvider.of<CharactersCubit>(context).getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: charactersScreenAppBar(),
      body: charactersBlocWidget(),
    );
  }

  AppBar charactersScreenAppBar() {
    return AppBar(
      backgroundColor: MyColors.myYellow,
      leading: _isSearching ? const BackButton(color: Colors.grey,) : Container(),
      title: _isSearching ? _searchFieldItem() :
      const Text(Constants.characterAppBarTitile,style: TextStyle(color: Colors.black),),
      actions: _buildAppBarActionButtons(),
      //leading: _isSearching ?  ,
    );
  }

  Widget charactersBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
          /// - Logic Should go to the VM
          if (state is CharactersInitial) {
            print("Intial State");
          }else if (state is CharactersLoaded) {
            allCharacters = state.data;
            return buildLoadedListWidgets();
          }else {
            return showLoadingIndicator();
          }
          return Container();
        }
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharactersGridView(),
          ],
        ),
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildCharactersGridView() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2 / 3,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
    ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: searchTextEditController.text.isEmpty ?  allCharacters?.length: userSearchResults!.length,
        itemBuilder: (ctx, index) {
         return CharacterItem(model:searchTextEditController.text.isEmpty ?
         allCharacters![index] : userSearchResults![index]);
        });
  }

  Widget _searchFieldItem() {
    return TextField(
      controller: searchTextEditController,
      cursorColor: Colors.yellow,
      decoration: const InputDecoration(
        hintText: 'Find a Character',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black)
      ),
      style: TextStyle(color: Colors.grey, fontSize: 18),
      onChanged: (searchResult){
        addSearchResult(searchResult);
      },
    );
  }

  void addSearchResult(String data) {
    if (allCharacters != null) {
      userSearchResults = allCharacters!
          .where((element) => element.name!.toLowerCase().startsWith(data)).toList();
    }
    setState(() {});
  }

  List<Widget> _buildAppBarActionButtons() {
    if(_isSearching)  {
      /// x button
      return [IconButton(onPressed: (){
        _clearSearchField();
        Navigator.pop(context);
      },
          icon: const Icon(Icons.clear,color: MyColors.myGrey,))];
    } else {
      return [IconButton(onPressed: _startSearch,
          icon: const Icon(Icons.search,color: MyColors.myGrey,))];
    }
  }

  void _startSearch() {
    //create back button on search field as it goes to new route
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
   _clearSearchField();
   setState(() {
     _isSearching = false;
   });
  }

  void _clearSearchField() {
    setState(() {
      searchTextEditController.clear();
    });
  }

}
