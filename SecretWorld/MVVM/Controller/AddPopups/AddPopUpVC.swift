//
//  AddPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//
import UIKit
import IQKeyboardManagerSwift
import BackgroundRemoval
struct Products {
    let name: String?
    let price: Int?
    init(name: String?, price: Int?) {
        self.name = name
        self.price = price
    }
}
class AddPopUpVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - OUTLETS
    @IBOutlet var btnMarkerLogo: UIButton!
    @IBOutlet var imgVwMarkerLogo: UIImageView!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet var txtFldLOcation: UITextField!
    @IBOutlet var btnPopupLogo: UIButton!
    @IBOutlet var imgVwPopupLogo: UIImageView!
    @IBOutlet var heightVwNoProductlsit: NSLayoutConstraint!
    @IBOutlet var txtFldEndTime: UITextField!
    @IBOutlet var txtFldEndDate: UITextField!
    @IBOutlet var txtFldStartTime: UITextField!
    @IBOutlet var txtFldStartDate: UITextField!
    @IBOutlet var txtVwDescription: IQTextView!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var heightTblVw: NSLayoutConstraint!
    @IBOutlet var tblVwList: UITableView!
    @IBOutlet weak var lblDescriptionCount: UILabel!
    //MARK: - VARIABLES
    var arrProducts = [Products]()
    var isUploadLogoImg = false
    var isUploadMarker = false
    var viewModel = PopUpVM()
    var lat:Double?
    var long:Double?
    var selectedStartTime:String?
    var selectedEndTime:String?
    var selectedStartDate:String?
    var selectedEndDate:String?
    var currentTime:String?
    var currentDate:String?
    var isComing = false
    var arrEditProducts = [AddProducts]()
    var callBack:(()->())?
    var popupDetails:PopupDetailData?
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        txtFldStartDate.tag = 1
        txtFldEndDate.tag = 2
        txtFldStartTime.tag = 3
        txtFldEndTime.tag = 4
        let nibNearBy = UINib(nibName: "ProductListTVC", bundle: nil)
        tblVwList.register(nibNearBy, forCellReuseIdentifier: "ProductListTVC")
        uiSet()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }
    func uiSet(){
        txtVwDescription.delegate = self
        if isComing == true{
            // Update promote business
            lblScreenTitle.text = "Edit Promote Business"
            btnCreate.setTitle("Update", for: .normal)
            btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
            imgVwPopupLogo.imageLoad(imageUrl: popupDetails?.businessLogo ?? "")
            if popupDetails?.image == "" || popupDetails?.image == nil{
                
                btnMarkerLogo.setImage(UIImage(named: "Group25"), for: .normal)
            }else{
                
                btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
                imgVwMarkerLogo.imageLoad(imageUrl: popupDetails?.image ?? "")
            }
            
            txtFldName.text = popupDetails?.name ?? ""
            txtVwDescription.text = popupDetails?.description ?? ""
            txtFldLOcation.text = popupDetails?.place ?? ""
            arrEditProducts = popupDetails?.addProducts ?? []
            txtFldStartDate.text = convertDateString(popupDetails?.startDate ?? "")
            txtFldEndDate.text = convertDateString(popupDetails?.endDate ?? "")
            txtFldStartTime.text = convertTimeString(popupDetails?.startDate ?? "")
            txtFldEndTime.text = convertTimeString(popupDetails?.endDate ?? "")
            lat = popupDetails?.lat ?? 0.0
            long = popupDetails?.long ?? 0.0
            manageTableVIewHeight()
            tblVwList.reloadData()
        }else{
            //add
            lblScreenTitle.text = "Promote Business"
            btnCreate.setTitle("Create", for: .normal)
            manageTableVIewHeight()
        }
        setupDatePickers()
    }
      func setupDatePickers() {
        setupDatePicker(for: txtFldStartDate, mode: .date, selector: #selector(startDateDonePressed))
        setupDatePicker(for: txtFldEndDate, mode: .date, selector: #selector(endDateDonePressed))
        setupDatePicker(for: txtFldStartTime, mode: .time, selector: #selector(startTimeDonePressed))
        setupDatePicker(for: txtFldEndTime, mode: .time, selector: #selector(endTimeDonePressed))
      }
    @objc func actionStartTime() {
      if let datePicker = txtFldStartTime.inputView as? UIDatePicker {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        selectedStartTime = dateFormatter.string(from: datePicker.date)
        let currentDate = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateString = dateFormatter.string(from: currentDate)
        if txtFldStartDate.text == currentDateString {
          if datePicker.date < currentDate {
            datePicker.date = currentDate
            txtFldStartTime.text = nil
          } else {
            datePicker.minimumDate = currentDate
            txtFldStartTime.text = selectedStartTime
          }
        } else {
          datePicker.minimumDate = nil
          txtFldStartTime.text = selectedStartTime
        }
      }
    }
      func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        if #available(iOS 13.4, *) {
          datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = datePicker
          if textField == txtFldStartDate || textField == txtFldEndDate{
              datePicker.minimumDate = Date()
          }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        // Add the flexible space item first and then the "Done" button
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.tag = textField.tag
      }
      @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        switch sender.tag {
        case 1:
          updateTextField(txtFldStartDate, datePicker: sender)
        case 2:
          updateTextField(txtFldEndDate, datePicker: sender)
        case 3:
          updateTextField(txtFldStartTime, datePicker: sender)
        case 4:
          updateTextField(txtFldEndTime, datePicker: sender)
        default:
          break
        }
      }
    func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
      let dateFormatter = DateFormatter()
      if textField == txtFldStartDate || textField == txtFldEndDate {
        dateFormatter.dateFormat = "dd-MM-yyyy"
      } else if textField == txtFldStartTime || textField == txtFldEndTime {
        dateFormatter.dateFormat = "h:mm a"
      }
      textField.text = dateFormatter.string(from: datePicker.date)
      validateDateAndTime()
    }
      @objc func startDateDonePressed() {
        if let datePicker = txtFldStartDate.inputView as? UIDatePicker {
          updateTextField(txtFldStartDate, datePicker: datePicker)
        }
        txtFldStartDate.resignFirstResponder()
      }
      @objc func endDateDonePressed() {
        if let datePicker = txtFldEndDate.inputView as? UIDatePicker {
          updateTextField(txtFldEndDate, datePicker: datePicker)
        }
        txtFldEndDate.resignFirstResponder()
      }
    @objc func startTimeDonePressed() {
        if let datePicker = txtFldStartTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDate = dateFormatter.string(from: Date())
            let selectedStartDateText = txtFldStartDate.text ?? ""
            if selectedStartDateText == currentDate {
                datePicker.minimumDate = Date()
            } else {
                datePicker.minimumDate = nil
            }
            updateTextField(txtFldStartTime, datePicker: datePicker)
        }
        txtFldStartTime.resignFirstResponder()
    }
      @objc func endTimeDonePressed() {
        if let datePicker = txtFldEndTime.inputView as? UIDatePicker {
          updateTextField(txtFldEndTime, datePicker: datePicker)
        }
        txtFldEndTime.resignFirstResponder()
      }
    func validateDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDate = Date()
        // Validate start time
        if let datePicker = txtFldStartTime.inputView as? UIDatePicker {
            let selectedStartDateText = txtFldStartDate.text ?? ""
            if let selectedStartDate = dateFormatter.date(from: selectedStartDateText) {
                if Calendar.current.isDate(selectedStartDate, inSameDayAs: currentDate) {
                    datePicker.minimumDate = currentDate
                    let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "h:mm a"
                    let currentTimeString = timeFormatter.string(from: currentDate)
                                print("Current Time: \(currentTimeString)")
                    if currentTimeString > txtFldStartTime.text ?? ""{
                        txtFldStartTime.text = ""
                    }
                } else {
                    
                    datePicker.minimumDate = nil
                }
            }
        }
        // Validate end time
        if let datePicker = txtFldEndTime.inputView as? UIDatePicker {
            let selectedEndDateText = txtFldEndDate.text ?? ""
            if let selectedEndDate = dateFormatter.date(from: selectedEndDateText) {
                if Calendar.current.isDate(selectedEndDate, inSameDayAs: currentDate) {
                    datePicker.minimumDate = currentDate
                } else {
                    
                    datePicker.minimumDate = nil
                }
            }
        }
        guard let startDateText = txtFldStartDate.text,
              let endDateText = txtFldEndDate.text,
              let startTimeText = txtFldStartTime.text,
              let endTimeText = txtFldEndTime.text else {
            return
        }
        guard let startDate = dateFormatter.date(from: startDateText),
              let endDate = dateFormatter.date(from: endDateText) else {
            return
        }
        if startDate == endDate {
            dateFormatter.dateFormat = "h:mm a"
            guard let startTime = dateFormatter.date(from: startTimeText),
                  let endTime = dateFormatter.date(from: endTimeText) else {
                return
            }
            if endTime <= startTime {
                
                txtFldEndTime.text = ""
                showSwiftyAlert("", "Enter valid time.", false)
            }
        }else if startDate > endDate {
            
            txtFldEndDate.text = ""
            showSwiftyAlert("", "Enter valid date.", false)
        }
    }
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if dateString.contains(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    func convertTimeString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if dateString.contains(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    //MARK: - BUTTON ACTIONS
    
    @IBAction func actionUploadMarkerLogo(_ sender: UIButton) {
        if isUploadMarker == true{
            do {
                let processedImage = try BackgroundRemoval().removeBackground(image: imgVwMarkerLogo.image ?? UIImage())
                self.imgVwMarkerLogo.image = processedImage
                Store.MarkerLogo = processedImage
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
                vc.isComing = 9
                vc.callBack = { [weak self] image in
                    guard let self = self else { return }
                    self.imgVwMarkerLogo.image = image
                    if Store.MarkerLogo == UIImage(named: "") || Store.MarkerLogo == nil{
                        self.btnMarkerLogo.setImage(UIImage(named: "Group25"), for: .normal)
                        self.isUploadMarker = false
                    }else{
                        self.btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }catch{
                print("Error removing background: \(error.localizedDescription)")
            }
        }else{
            openCamera()
//            ImagePicker().pickImage(self) { image in
//                self.imgVwMarkerLogo.image = image
//                Store.MarkerLogo = image
//                self.btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
//                self.isUploadMarker = true
//            }
        }
    }
    func openCamera() {
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController()
               imagePicker.sourceType = .camera
               imagePicker.delegate = self
               imagePicker.allowsEditing = false
               self.present(imagePicker, animated: true, completion: nil)
           }
       }
    // MARK: - UIImagePickerControllerDelegate
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
         if let image = info[.originalImage] as? UIImage {
             do {
                 let processedImage = try BackgroundRemoval().removeBackground(image: image)
                 
                     self.imgVwMarkerLogo.image = processedImage
                     Store.MarkerLogo = processedImage
                     self.btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
                     self.isUploadMarker = true
                 
             } catch {
                 print("Error removing background: \(error.localizedDescription)")
             }
         }
         picker.dismiss(animated: true, completion: nil)
     }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionUploadimg(_ sender: UIButton) {
        if isUploadLogoImg == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
            vc.isComing = 0
            vc.callBack = { [weak self] image in
                
                guard let self = self else { return }
                self.imgVwPopupLogo.image = image
                if Store.LogoImage == UIImage(named: "") || Store.LogoImage == nil{
                    self.btnPopupLogo.setImage(UIImage(named: "Group25"), for: .normal)
                    self.isUploadLogoImg = false
                }else{
                    self.btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            ImagePicker().pickImage(self) { image in
                self.imgVwPopupLogo.image = image
                Store.LogoImage = image
                self.btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
                self.isUploadLogoImg = true
            }
        }
    }
    @IBAction func actionAddProduct(_ sender: UIButton) {
        txtFldName.resignFirstResponder()
        txtVwDescription.resignFirstResponder()
        txtFldStartDate.resignFirstResponder()
        txtFldEndDate.resignFirstResponder()
        txtFldStartTime.resignFirstResponder()
        txtFldEndTime.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = true
        vc.callBack = {[weak self] productName,price,isdelete,isEdit in
            
            guard let self = self else { return }
            print(productName.count)
            if self.isComing == true{
                self.arrEditProducts.append(AddProducts(productName: productName, price: price, id: ""))
            }else{
                self.arrProducts.append(Products(name: productName, price: price))
            }
            self.tblVwList.reloadData()
            self.manageTableVIewHeight()
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionCreate(_ sender: UIButton) {
        if imgVwPopupLogo.image == UIImage(named: "") || imgVwPopupLogo.image == nil{
            showSwiftyAlert("", "No logo selected. Please choose an image to upload", false)
        }else  if imgVwMarkerLogo.image == UIImage(named: "") || imgVwMarkerLogo.image == nil{
            showSwiftyAlert("", "No marker logo selected. Please choose an image to upload", false)
        }else if txtFldName.text == ""{
            showSwiftyAlert("", "This field cannot be left blank. Provide your business name", false)
        }else if txtVwDescription.text == ""{
            showSwiftyAlert("", "Description of business is required", false)
        }else if arrProducts.isEmpty && arrEditProducts.isEmpty {
            if isComing{
                showSwiftyAlert("", "Add product", false)
            } else {
                showSwiftyAlert("", "Add product", false)
            }
        }else if txtFldLOcation.text == ""{
            showSwiftyAlert("", "Please select your location", false)
        }else if txtFldStartDate.text == ""{
            showSwiftyAlert("", "Please select the start date", false)
        }else if txtFldStartTime.text == ""{
            showSwiftyAlert("", "Please select the start time", false)
        }else if txtFldEndDate.text == ""{
            showSwiftyAlert("", "Please select the end date", false)
        }else if txtFldEndTime.text == ""{
            showSwiftyAlert("", " Please select the end time", false)
        }else{
            let startDateTimeString = "\(txtFldStartDate.text ?? "") \(txtFldStartTime.text ?? "")"
            let endDateTimeString = "\(txtFldEndDate.text ?? "") \(txtFldEndTime.text ?? "")"
            let startDateTimeUTC = convertToUTC(from: startDateTimeString, with: "dd-MM-yyyy h:mm a") ?? ""
            let endDateTimeUTC = convertToUTC(from: endDateTimeString, with: "dd-MM-yyyy h:mm a") ?? ""
            print("Start Time UTC:", startDateTimeUTC)
            print("End Time UTC:", endDateTimeUTC)
//            if Store.role == "b_user"{
//                if isComing == true{
//                    //edit
//                    
//                    viewModel.UpdatePopUpApi(id: popupDetails?.id ?? "",
//                                             name: txtFldName.text ?? "",
//                                             usertype: "b_user",
//                                             business_logo: imgVwPopupLogo,
//                                             image: imgVwMarkerLogo,
//                                             startDate: startDateTimeUTC,
//                                             endDate: endDateTimeUTC,
//                                             lat: lat ?? 0.0,
//                                             long: long ?? 0.0,
//                                             description: txtVwDescription.text ?? "",
//                                             addProducts: arrEditProducts,
//                                             place: txtFldLOcation.text ?? "", isMarker: true){ message in
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
//                            vc.modalPresentationStyle = .overFullScreen
//                            vc.isSelect = 10
//                            vc.message = message
//                            myPopUpLat = self.lat ?? 0
//                            myPopUpLong = self.long ?? 0
//                            addPopUp = true
//                            vc.callBack = {[weak self] in
//                                guard let self = self else { return }
//                                SceneDelegate().PopupListVCRoot()
//                            }
//                            self.navigationController?.present(vc, animated: false)
//                        }
//                }else{
//                    //add
//                    viewModel.AddPopUpApi(usertype: "b_user", place: txtFldLOcation.text ?? "", name: txtFldName.text ?? "",
//                                          business_logo: imgVwPopupLogo,
//                                          image: imgVwMarkerLogo,
//                                          startDate: startDateTimeUTC ,
//                                          endDate: endDateTimeUTC,
//                                          lat: lat ?? 0.0,
//                                          long: long ?? 0.0,
//                                          description: txtVwDescription.text ?? "",
//                                          addProducts: arrProducts, isMarker: true) { message in
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
//                        vc.modalPresentationStyle = .overFullScreen
//                        vc.isSelect = 10
//                        vc.message = message
//                        loadHomeData = false
//                        myPopUpLat = self.lat ?? 0
//                        myPopUpLong = self.long ?? 0
//                        addPopUp = true
//                        vc.callBack = {[weak self] in
//                            guard let self = self else { return }
//                            SceneDelegate().tabBarHomeRoot()
//                        }
//                        self.navigationController?.present(vc, animated: false)
//                    }
//                }
//            }else{
                if isComing == true{
                    //edit
                    if self.imgVwMarkerLogo.image == UIImage(named: ""){
                        viewModel.UpdatePopUpApi(id: popupDetails?.id ?? "",
                                                 name: txtFldName.text ?? "",
                                                 usertype: "user",
                                                 business_logo: imgVwPopupLogo,
                                                 image: imgVwMarkerLogo,
                                                 startDate: startDateTimeUTC,
                                                 endDate: endDateTimeUTC,
                                                 lat: lat ?? 0.0,
                                                 long: long ?? 0.0,
                                                 description: txtVwDescription.text ?? "",
                                                 addProducts: arrEditProducts,
                                                 place: txtFldLOcation.text ?? "", isMarker: false){ message in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                            vc.isSelect = 10
                            vc.message = message
                            myPopUpLat = self.lat ?? 0
                            myPopUpLong = self.long ?? 0
                            addPopUp = true
                            vc.callBack = {[weak self] in
                                guard let self = self else { return }
                             SceneDelegate().PopupListVCRoot()
                            }
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.present(vc, animated: true)
                        }

                    }else{
                        do {
                            // Remove background from the image
                            let processedImage = try BackgroundRemoval().removeBackground(image: imgVwMarkerLogo.image ?? UIImage())
                            self.imgVwMarkerLogo.image = processedImage
                            viewModel.UpdatePopUpApi(id: popupDetails?.id ?? "",
                                                     name: txtFldName.text ?? "",
                                                     usertype: "user",
                                                     business_logo: imgVwPopupLogo,
                                                     image: imgVwMarkerLogo,
                                                     startDate: startDateTimeUTC,
                                                     endDate: endDateTimeUTC,
                                                     lat: lat ?? 0.0,
                                                     long: long ?? 0.0,
                                                     description: txtVwDescription.text ?? "",
                                                     addProducts: arrEditProducts,
                                                     place: txtFldLOcation.text ?? "", isMarker: true){ message in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                vc.isSelect = 10
                                vc.message = message
                                myPopUpLat = self.lat ?? 0
                                myPopUpLong = self.long ?? 0
                                addPopUp = true
                                vc.callBack = {[weak self] in
                                    guard let self = self else { return }
                                    SceneDelegate().PopupListVCRoot()
                                }
                                vc.modalPresentationStyle = .overFullScreen
                                self.navigationController?.present(vc, animated: true)
                            }
                        }catch{
                            print("Error removing background: \(error.localizedDescription)")
                        }
                    }
                }else{
                    //add
                    if self.imgVwMarkerLogo.image == UIImage(named: ""){
                        viewModel.AddPopUpApi(usertype: "user", place: txtFldLOcation.text ?? "", name: txtFldName.text ?? "",
                                              business_logo: imgVwPopupLogo,
                                              image: imgVwMarkerLogo,
                                              startDate: startDateTimeUTC ,
                                              endDate: endDateTimeUTC,
                                              lat: lat ?? 0.0,
                                              long: long ?? 0.0,
                                              description: txtVwDescription.text ?? "",
                                              addProducts: arrProducts, isMarker: false) { message in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                            vc.isSelect = 10
                            vc.message = message
                            myPopUpLat = self.lat ?? 0
                            myPopUpLong = self.long ?? 0
                            addPopUp = true
                            Store.tabBarNotificationPosted = false
                            vc.callBack = {[weak self] in
                                guard let self = self else { return }
                                SceneDelegate().tabBarHomeRoot()
                            }
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.present(vc, animated: true)
                        }
                    }else{
                        do {
                            // Remove background from the image
                                let processedImage = try BackgroundRemoval().removeBackground(image: imgVwMarkerLogo.image ?? UIImage())
                                self.imgVwMarkerLogo.image = processedImage
                            viewModel.AddPopUpApi(usertype: "user", place: txtFldLOcation.text ?? "", name: txtFldName.text ?? "",
                                                  business_logo: imgVwPopupLogo,
                                                  image: imgVwMarkerLogo,
                                                  startDate: startDateTimeUTC ,
                                                  endDate: endDateTimeUTC,
                                                  lat: lat ?? 0.0,
                                                  long: long ?? 0.0,
                                                  description: txtVwDescription.text ?? "",
                                                  addProducts: arrProducts, isMarker: true) { message in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                vc.isSelect = 10
                                vc.message = message
                                myPopUpLat = self.lat ?? 0
                                myPopUpLong = self.long ?? 0
                                addPopUp = true
                                Store.tabBarNotificationPosted = false
                                vc.callBack = {[weak self] in
                                    guard let self = self else { return }
                                    SceneDelegate().tabBarHomeRoot()
                                }
                                vc.modalPresentationStyle = .overFullScreen
                                self.navigationController?.present(vc, animated: true)
                            }
                        } catch {
                            // Handle error gracefully
                            print("Error removing background: \(error.localizedDescription)")
                            // Optionally show an alert to the user
                        }
                    }
                }
            //}
        }
    }
    func convertToUTC(from dateString: String, with format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let localDateTime = dateFormatter.date(from: dateString) {
            let utcTimeZone = TimeZone(identifier: "UTC")
            dateFormatter.timeZone = utcTimeZone
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let utcDateTime = dateFormatter.string(from: localDateTime)
            return utcDateTime
        }
        return nil
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        txtFldName.resignFirstResponder()
        txtVwDescription.resignFirstResponder()
        txtFldStartDate.resignFirstResponder()
        txtFldEndDate.resignFirstResponder()
        txtFldStartTime.resignFirstResponder()
        txtFldEndTime.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isComing = false
        vc.latitude = lat
        vc.longitude = long
        vc.callBack = { [weak self] location in
            guard let self = self else { return }
            self.txtFldLOcation.text = location.placeName ?? ""
            self.lat = location.lat
            self.long = location.long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    }
//MARK: - UITableViewDelegate
extension AddPopUpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == true{
            return  arrEditProducts.count
        }else{
            return  arrProducts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(ActionEditProduct), for: .touchUpInside)
        if isComing == true{
            cell.lblProductName.text = "\(indexPath.row + 1). \(arrEditProducts[indexPath.row].productName ?? "")"
            cell.lblPrice.text = "$\(arrEditProducts[indexPath.row].price ?? 0)"
        }else{
            cell.lblProductName.text = "\(indexPath.row + 1). \(arrProducts[indexPath.row].name ?? "")"
            cell.lblPrice.text = "$\(arrProducts[indexPath.row].price ?? 0)"
        }
        return cell
    }
    @objc func ActionEditProduct(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = false
        vc.selectedIndex = sender.tag
        if self.isComing == true{
            vc.arrEditProducts = arrEditProducts
        }else{
            vc.arrProducts = arrProducts
        }
        vc.callBack = { [weak self] productName, price,isDelete,isEdit in
                        guard let self = self else { return }
            if self.isComing == true{
                if isDelete == true{
                    self.arrEditProducts.remove(at: sender.tag)
                }else{
                    self.arrEditProducts[sender.tag] = AddProducts(productName: productName, price: price, id: "")
                }
            }else{
                if isDelete == true{
                    self.arrProducts.remove(at: sender.tag)
                }else{
                    self.arrProducts[sender.tag] = Products(name: productName, price: price)
                }
            }
            self.tblVwList.reloadData()
            self.manageTableVIewHeight()
        }
        self.navigationController?.present(vc, animated: true)
    }
    func manageTableVIewHeight() {
        let productsCount = isComing ? arrEditProducts.count : arrProducts.count
        self.heightTblVw.constant = productsCount > 0 ? CGFloat(productsCount * 50) : 0
        self.heightVwNoProductlsit.constant = productsCount == 0 ? 60 : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
}
//MARK: - uitextfielddelegates
extension AddPopUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldName{
            txtFldName.resignFirstResponder()
            txtVwDescription.becomeFirstResponder()
        }
        return true
    }
}
//MARK: - UITextViewDelegate
extension AddPopUpVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        lblDescriptionCount.text = "\(characterCount)/250"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
    }
}
