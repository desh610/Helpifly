import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/widgets/custom_dropdown_by_array.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:image_picker/image_picker.dart';

class AddRequestBottomSheet extends StatefulWidget {
  const AddRequestBottomSheet({super.key});

  @override
  _AddRequestBottomSheetState createState() => _AddRequestBottomSheetState();
}

class _AddRequestBottomSheetState extends State<AddRequestBottomSheet> {
  final TextEditingController _mainTitleController = TextEditingController();
  final TextEditingController _secondaryTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController searchTextController = TextEditingController();
  List<String> filteredSearchTextList = [];
  String _selectedType = 'Product';

  File? _itemImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _itemImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     searchTextController.addListener(_filterSearchText);
  }

   void _filterSearchText() {
    final query = searchTextController.text.toLowerCase();
    final allSearchTextList = context.read<AppCubit>().state.categories;
    setState(() {
      filteredSearchTextList = allSearchTextList
          .where((i) => i.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onSuggestionTap(String suggestion) {
     final allCategories = context.read<AppCubit>().state.categories;
    print(suggestion);
    searchTextController.text = suggestion;
    setState(() {
      filteredSearchTextList.clear();
    });
    closeKeyboard(context);
    _dismissSuggestions();
    
  }
 

  void _dismissSuggestions() {
    setState(() {
      filteredSearchTextList.clear();
    });
  }

  @override
  void dispose() {
    _mainTitleController.dispose();
    _secondaryTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: EdgeInsets.all(15.0),
      height: MediaQuery.of(context).size.height -25,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.transparent, size: 20),
              ),
              Text(
                "New item",
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_rounded, color: grayColor, size: 24),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                   const SizedBox(height: 20),
                  GestureDetector(
                      onTap: _pickImage,
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: inCardColor,
                              borderRadius: BorderRadius.circular(12),
                              // shape: BoxShape.circle,
                              image: _itemImage != null
                                  ? DecorationImage(
                                      image: FileImage(_itemImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _itemImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: grayColor,
                                      size: 26,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Tap to set item logo",
                            style: TextStyle(fontSize: 14, color: grayColor),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text("Item category", style: TextStyle(color: white, fontWeight: FontWeight.w500),),
                    ],
                  ),
                  CustomSearchBar(
                      controller: searchTextController,
                      onChanged: (text) {
                       
                      },
                    ),
                     if (filteredSearchTextList.isNotEmpty)
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredSearchTextList.length,
                            itemBuilder: (context, index) {
                              final suggestion = filteredSearchTextList[index];
                              return ListTile(
                                title: Text(
                                  suggestion,
                                  style: const TextStyle(color: black),
                                ),
                                onTap: () => _onSuggestionTap(suggestion),
                              );
                            },
                          ),
                        ),
                      ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _mainTitleController,
                    hintText: "Enter main title here",
                    overlineText: "Main title",
                    minLines: 1,
                    maxLines: 1,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _secondaryTitleController,
                    hintText: "Enter secondary title here",
                    overlineText: "Secondary title",
                    minLines: 1,
                    maxLines: 1,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 15),
                    CustomDropdownByArray(
                        items: ['Product', 'Service'],
                        selectedValue:
                            'Product', // Must match exactly one item in the list
                        hintText: 'Select type',
                        overlineText: 'Type',
                        backgroundColor: inCardColor,
                        textColor: white,
                        hintColor: grayColor,
                        overlineTextColor: white,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value??"";
                          });
                        },
                      ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: "Enter description here",
                    overlineText: "Description",
                    minLines: 10,
                    maxLines: null,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    onTap: () {
                      context.read<AppCubit>().requestItem(
                        mainTitle: _mainTitleController.text,
                        secondaryTitle: _secondaryTitleController.text,
                        description: _descriptionController.text,
                        requestImage: _itemImage,
                        type: _selectedType,
                        category: searchTextController.text,
                        context: context
                      );
                      Navigator.of(context).pop(); // Close the bottom sheet after publishing
                    },
                    buttonText: "Send Request",
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
