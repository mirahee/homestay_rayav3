import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'user.dart';



class AddHomestay extends StatefulWidget {
  final User user;
  final Position position;
  final List<Placemark> placemarks;
  const AddHomestay({Key? key, required this.user, required this.position, required this.placemarks}) : super(key: key,
  );
  



  @override
  State<AddHomestay> createState() => _AddHomestayState();
}

class _AddHomestayState extends State<AddHomestay> {
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescEditingController =
      TextEditingController();
  final TextEditingController _prpriceEditingController =
      TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _praddrEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
    var _lat, _lng;

  @override
  void initState() {
    super.initState();
    // _checkPermissionGetLoc();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    //_getAddress();
    _prstateEditingController.text =
        widget.placemarks[0].administrativeArea.toString();
    _prlocalEditingController.text = widget.placemarks[0].locality.toString();
  }


  File? _image;
  var pathAsset = "assets/images/camera.png";
  bool _isChecked = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add New Homestay")),
        body: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: _selectImageDialog,
              child: Card(
                elevation: 8,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image!) as ImageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add New Homestay",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _prnameEditingController,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Homestay name must be longer than 3"
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Homestay Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _prdescEditingController,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Homestay description must be longer than 10"
                          : null,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Homestay Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _prpriceEditingController,
                            validator: (val) => val!.isEmpty
                                ? "Homestay price must contain value"
                                : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.money),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _prqtyEditingController,
                            validator: (val) => val!.isEmpty
                                ? "Capacity should be more than 0"
                                : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Capacity',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.ad_units),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      )
                    ],
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _praddrEditingController,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Address must be longer than 10"
                          : null,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Address/home',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      child: const Text('Add Homestay'),
                      onPressed: () => {
                        _newProductDialog(),
                      },
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ));
  }

  void _newProductDialog() {
     if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your product/service",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this homestay?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _selectImageDialog() {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select picture from:",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 54,
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 54,
                    onPressed: _onGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
  }
  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      //maxImages: 3,
      maxHeight: 800,
      maxWidth: 800,
    );
   /* final pickedFile2 = await picker.pickImage(
      source: ImageSource.camera,
      //maxImages: 3,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile3 = await picker.pickImage(
      source: ImageSource.camera,
      //maxImages: 3,
      maxHeight: 800,
      maxWidth: 800,
    );*/
   
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //_image2 = File(pickedFile2.path);
      //_image3 = File(pickedFile3.path);
      //cropImage();
      setState(() {  
          //_image = [pickedFile1, pickedFile2, pickedFile3];
      });
    } else {
      print('No image selected.');
    }

  }
  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
     /*final pickedFile2 = await picker.pickImage(
      source: ImageSource.gallery,
      //maxImages: 3,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile3 = await picker.pickImage(
      source: ImageSource.gallery,
      //maxImages: 3,
      maxHeight: 800,
      maxWidth: 800,
    );*/
    if (pickedFile != null ) {
      _image = File(pickedFile.path);
      //_image2 = File(pickedFile2.path);
      //_image2 = File(pickedFile3.path);
      //cropImage();
      setState(() {  
          //_image = [pickedFile1, pickedFile2, pickedFile3];
      });
    } else {
      print('No image selected.');
    }
  }
  /*Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }*/

  
  void insertProduct() {
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    String qty = _prqtyEditingController.text;
    String state = _prstateEditingController.text;
    String local = _prlocalEditingController.text;
    String addr = _praddrEditingController.text;

    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("http://192.168.176.247/homestay_raya/php/insert_product.php"), body: {
      "userid": widget.user.id,
      "prname": prname,
      "prdesc": prdesc,
      "prprice": prprice,
      "qty": qty,
      "state": state,
      "local": local,
      "lat": _lat,
      "lon": _lng,
      "addr": addr,
      "image": base64Image
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
  }


