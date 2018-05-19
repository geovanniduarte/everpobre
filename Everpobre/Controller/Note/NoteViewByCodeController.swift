//
//  NoteViewByCodeController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 3/8/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import CoreData
import MapKit

enum showDatePickerVariations : CGFloat {
    case heighOpened = 214
    case heighMarginClosed = 0
    case marginOpen = 0.5
}

enum showRotaterVariations : CGFloat {
    case heighOpened = 100
    case heighMarginClosed = 0
    case marginOpen = 0.5
}

let IMAGE_ENTITY_NAME = "Image"
typealias ImageContraintsPairs = [UIImageView: [NSLayoutConstraint]]
class NoteViewByCodeController: UIViewController , UINavigationControllerDelegate, UITextFieldDelegate, NotesViewControllerDelegate {
    
    let backView = UIView()
    let dateLabel = UILabel()
    let expirationDate = UITextField() //textField .
    let titleTextField = UITextField()
    let noteTextView = UITextView()
    let notebookPickerView = UIPickerView()
    var imageView = UIImageView()
    var imageViewTransform : CGAffineTransform?
    let testButton = UIButton()
    let datePicker = UIDatePicker()
    let mapView = MKMapView()
    let imageRotater = UIRotater()
    
    var topImgConstraint: NSLayoutConstraint!
    var bottonImgConstraint: NSLayoutConstraint!
    var leftImgConstraint: NSLayoutConstraint!
    var rightImgConstraint: NSLayoutConstraint!
    
    
    var heighDatePickerConstraint : NSLayoutConstraint!
    var marginTopDatePickerConstraint : NSLayoutConstraint!
    
    var heightRotaterConstraint : NSLayoutConstraint!
    var marginTopRotaterConstraint : NSLayoutConstraint!
    
    var imagesConstraints : ImageContraintsPairs!
    
    var relativePoint: CGPoint!
    
    var note: Note?
    var notebooks : [Notebook]?
    
    init(note: Note) {
        // Limpiamos
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        
        imagesConstraints = [:]
        
        backView.backgroundColor = .white
    
        // Configuro label
        if let creationDateDouble = note?.createdAtTi {
            dateLabel.text = Date(timeIntervalSince1970: creationDateDouble).formattedDate(nil)
        }
        backView.addSubview(dateLabel)
        
        // Configuro textField
        backView.addSubview(titleTextField)
        
        // Configuro noteTextView
        noteTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        backView.addSubview(noteTextView)
        
        //configuro notebook picker
        notebookPickerView.delegate =  self
        notebookPickerView.dataSource = self
        backView.addSubview(notebookPickerView)
    
        mapView.delegate = self
        backView.addSubview(mapView)

        // Configuracion del datePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 5
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    
        // Configuracion del expirationDate
        expirationDate.textColor = UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0)
        expirationDate.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.tintColor = UIColor.blue
        toolBar.barTintColor = UIColor.lightGray
        
        let barButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyBoard))
        toolBar.items = [barButton1]
        toolBar.sizeToFit()
        
        expirationDate.inputAccessoryView = toolBar
        
        // Configuro label
        backView.addSubview(expirationDate)
        
        // Configuracion del imageRotater
        imageRotater.isHidden = true
        imageRotater.delegate = self
        backView.addSubview(imageRotater)
        
        // MARK: Autolayout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false // no use autoresizing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        expirationDate.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        notebookPickerView.translatesAutoresizingMaskIntoConstraints = false;
        testButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints =  false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        imageRotater.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["dateLabel":dateLabel, "noteTextView":noteTextView,"titleTextField":titleTextField, "expirationDate":expirationDate, "notebookPickerView":notebookPickerView, "testButton":testButton, "datePicker":datePicker, "mapView":mapView, "imageRotater":imageRotater]

        // Horizontals
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[titleTextField]-10-[expirationDate]-10-[dateLabel]-10-|", options: [], metrics: nil, views: viewDict)
    
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[mapView]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[notebookPickerView]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[imageRotater]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
        // Verticals
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[dateLabel]-10-[mapView]-10-[notebookPickerView]-0-[imageRotater]-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(NSLayoutConstraint(item: dateLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: backView.layoutMarginsGuide,
                                             attribute: .top,
                                             multiplier: 1, constant: 20))
        
        constrains.append(NSLayoutConstraint(item: titleTextField,
                                             attribute: .lastBaseline,
                                             relatedBy: .equal,
                                             toItem: dateLabel,
                                             attribute: .lastBaseline,
                                             multiplier: 1, constant: 0))
        
        constrains.append(NSLayoutConstraint(item: expirationDate,
                                             attribute: .lastBaseline,
                                             relatedBy: .equal,
                                             toItem: dateLabel,
                                             attribute: .lastBaseline,
                                             multiplier: 1, constant: 0))
        if note?.location != nil {
            constrains.append(NSLayoutConstraint(item: mapView,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: notebookPickerView,
                                                 attribute: .height,
                                                 multiplier: 1, constant: 0))
 
        } else {
            constrains.append(NSLayoutConstraint(item: mapView,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1, constant: 0))
        }
       
        //heighDatePickerConstraint = NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        //marginTopDatePickerConstraint = NSLayoutConstraint(item: datePicker, attribute: .topMargin, relatedBy: .equal, toItem: expirationDate, attribute: .bottomMargin, multiplier: 1, constant: 0.0)
        
        heightRotaterConstraint = NSLayoutConstraint(item: imageRotater, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)

        marginTopRotaterConstraint = NSLayoutConstraint(item: imageRotater, attribute: .topMargin, relatedBy: .equal, toItem: notebookPickerView, attribute: .bottomMargin, multiplier: 1, constant: 10)
        marginTopRotaterConstraint.priority = .defaultHigh
        
        backView.addConstraints(constrains)
        //backView.addConstraints([heighDatePickerConstraint, marginTopDatePickerConstraint])
        backView.addConstraints([heightRotaterConstraint,marginTopRotaterConstraint])
        
        loadImages()
        
        self.view = backView
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Delegado textField
        titleTextField.delegate = self
        
        // MARK: Navigation controller
        navigationController?.isToolbarHidden = false
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        
        let fixSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let mapBarButton =  UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(addLocation))
        
        
        self.setToolbarItems([photoBarButton, flexibleSpace, mapBarButton], animated: false)
        // Gestures
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        
        imageView.isUserInteractionEnabled = true
        
        view.addGestureRecognizer(swipeGesture)
        /*
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveImage))
        imageView.addGestureRecognizer(doubleTapGesture)
        
        doubleTapGesture.numberOfTapsRequired = 2
        
        imageView.addGestureRecognizer(doubleTapGesture)
         
         let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
         
         imageView.addGestureRecognizer(moveViewGesture)
        */
        
        
        loadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        syncModel();
        
    }
    
    
    override func viewDidLayoutSubviews()
    {
        let paths = self.createExlusionPaths()
        noteTextView.textContainer.exclusionPaths = paths
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editNote(values: ["title":textField.text as Any])
    }
    
    
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
    {
        editNote(values: ["title":titleTextField.text as Any])
        self.note = note
        syncModel()
    }
    
    func syncModel() {
        titleTextField.text = note?.title
        
        if let expirationDateDouble = note?.expirationDate {
            expirationDate.text = Date(timeIntervalSince1970: expirationDateDouble).formattedDate(nil)
            expirationDate.inputView = datePicker
        }
        
        if let creationDateDouble = note?.createdAtTi {
            dateLabel.text = Date(timeIntervalSince1970: creationDateDouble).formattedDate(nil)
        }
        
    }

}

// MARK : - Picker
extension NoteViewByCodeController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Delegates and data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.notebooks!.count + 1
    }
    
    // MARK: - Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var pickerCellName : String = ""
        if row == 0 {
            pickerCellName = "SELECT"
        } else {
            if let name = self.notebooks![row - 1].name {
                pickerCellName = name
            }
        }
        
        if note?.notebook?.name == pickerCellName {
            notebookPickerView.selectRow(row, inComponent: 0, animated: true);
        }
        
        return pickerCellName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            setNotebook(row - 1);
        }
    }
    
}

// MARK: - DAO
extension NoteViewByCodeController {
    
    func loadData() {
        let viewContext = DataManager.sharedManager.persistentContainer.viewContext
        
        let notebookFetchReq = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY_NAME)
        
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        
        notebookFetchReq.sortDescriptors = [sortByName]
        
        do {
            self.notebooks = try viewContext.fetch(notebookFetchReq);
        } catch {
            print("no se pudo obtener notebooks en note", error);
        }
    }
    
    func setNotebook(_ at: Int) {
        let selectedNotebook = self.notebooks![at]
        
        self.note?.notebook = selectedNotebook
        
        let viewContex = self.note?.managedObjectContext
        
        do {
           try viewContex?.save()
        } catch {
            print(error)
        }
    }
    
    func editNote(values: [String:Any]) {
        self.note?.setValuesForKeys(values)
        try! note?.managedObjectContext?.save()
    }
    
    func addImageBD(url: String, leftConstant: Int16, topConstant: Int16) {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let image = NSEntityDescription.insertNewObject(forEntityName: IMAGE_ENTITY_NAME, into: privateMOC) as! Image
            print("url save", url)
            image.localUrl = url
            image.leftConstant = leftConstant
            image.topConstant = topConstant
            let noteCopy = privateMOC.object(with: (self.note?.objectID)!)
            image.note = noteCopy as? Note
            try! privateMOC.save()
        }
    }
    
    func findImage(by url: String) -> Image? {
        let predicate = NSPredicate(format: "localUrl = %s", argumentArray: [url])
        let images = self.note?.images?.filtered(using: predicate)
        return images?.first as? Image
    }
    
    func editImageLocationBD(with url: String, left: CGFloat, top: CGFloat) {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            if var image = self.findImage(by: url) {
                image = privateMOC.object(with: image.objectID) as! Image
                image.leftConstant = Int16(left)
                image.topConstant = Int16(top)
                try! privateMOC.save()
            }
        }
    }
    
    
    func editImage(with url: String, kvcOptions: [String:Any]) {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            if var image = self.findImage(by: url) {
                image = privateMOC.object(with: image.objectID) as! Image
                image.setValuesForKeys(kvcOptions)
                try! privateMOC.save()
            }
        }
    }
    
    
}

// MARK: - Actions
extension NoteViewByCodeController {
    
     @objc func showDatePicker(_ sender: UIButton, animateTime: TimeInterval) {
        datePicker.isHidden = !datePicker.isHidden
        let isShow = !datePicker.isHidden
        
        UIView.animate(withDuration: 0.5) {
            self.heighDatePickerConstraint.constant = (isShow ? showDatePickerVariations.heighOpened.rawValue : showDatePickerVariations.heighMarginClosed.rawValue)
            
            self.marginTopDatePickerConstraint.constant = (isShow ? showDatePickerVariations.marginOpen.rawValue : showDatePickerVariations.heighMarginClosed.rawValue)
            
            self.view.layoutIfNeeded()
        }
        
    }
    @objc func showRotater(_ sender: UITapGestureRecognizer, animateTime: TimeInterval) {
        
        let imageV = sender.view as! UIImageView
        
        if !imageRotater.isHidden {
            let image =  findImage(by: imageV.accessibilityIdentifier!)
            //imageRotater.setValueForRotater(image?.rotation, scale: image?.zoom)
            imageRotater.setValuess()
        }
        
        if !imageRotater.isHidden && sender.view != imageView {
            imageView = imageV// indico cual es la imagen a rotar.
            return
        }
        
        imageRotater.isHidden = !imageRotater.isHidden
        let isShow = !imageRotater.isHidden
        imageView = sender.view as! UIImageView // indico cual es la imagen a rotar.
        imageViewTransform = imageView.transform // indico cual es el transform de la imagen a rotar.
        UIView.animate(withDuration: 0.5) {
            self.heightRotaterConstraint.constant = (isShow ? showRotaterVariations.heighOpened.rawValue : showRotaterVariations.heighMarginClosed.rawValue)
            
            self.marginTopRotaterConstraint.constant = (isShow ? showRotaterVariations.marginOpen.rawValue : showRotaterVariations.heighMarginClosed.rawValue)
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        self.expirationDate.text = datePicker.date.formattedDate(nil)
        note?.expirationDate = datePicker.date.timeIntervalSince1970
        try! note?.managedObjectContext?.save()
    }
    
    @objc func userMoveImage(longPressGesture: UILongPressGestureRecognizer) {
    
        switch longPressGesture.state {
        case .began:
            imageView = longPressGesture.view as! UIImageView
            relativePoint = longPressGesture.location(in: imageView)
            //if let id = imageView.accessibilityIdentifier {
                let constraints = imagesConstraints[imageView]
                leftImgConstraint = constraints?[0]
                topImgConstraint = constraints?[1]
            // }
            
        case .changed:
            
            let location = longPressGesture.location(in: noteTextView)
            leftImgConstraint?.constant = location.x - relativePoint.x
            topImgConstraint?.constant = location.y - relativePoint.y
             print("es continuado", topImgConstraint?.constant)
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                self.editImageLocationBD(with: self.imageView.accessibilityIdentifier!, left: self.leftImgConstraint.constant, top: self.topImgConstraint.constant)
            })
            
        default:
            break
        }
    }
    
    @objc func closeKeyboard() {
        print("es discreto tambien")
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        } else if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
        }
    }
    
    @objc func moveImage(tapGesture: UITapGestureRecognizer) {
        
        print("es discreto")
        if topImgConstraint.isActive {
            if  leftImgConstraint.isActive {
                leftImgConstraint.isActive = false
                rightImgConstraint.isActive = true
            } else {
                topImgConstraint.isActive = false
                bottonImgConstraint.isActive = true
            }
        } else {
            if leftImgConstraint.isActive {
                bottonImgConstraint.isActive = false
                topImgConstraint.isActive = true
            } else {
                rightImgConstraint.isActive = false
                leftImgConstraint.isActive = true
            }
            
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func addLocation(_ sender : UIButton) {
        let mapViewController = MapViewController()
        mapViewController.delegate = self
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    // MARK: Toolbar button actions.
    @objc func catchPhoto () {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let actionSheetAlert =  UIAlertController(title: NSLocalizedString("Add photo", comment: "Add photo"), message: nil, preferredStyle: .actionSheet)
        
        let useCamera = UIAlertAction(title: "Camera", style: .default) {
            (alertAction) in
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let useLibrary = UIAlertAction(title: "Photo Library", style: .default) {
            (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        
        actionSheetAlert.addAction(useCamera)
        actionSheetAlert.addAction(useLibrary)
        actionSheetAlert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheetAlert.popoverPresentationController?.sourceView = self.view
            actionSheetAlert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheetAlert.popoverPresentationController?.permittedArrowDirections = []
        }
        present(actionSheetAlert, animated: true, completion: nil)
    }
    
    @objc func hideKeyBoard(_ sender : UIView) {
        print("hidekey")
        expirationDate.resignFirstResponder()
    }
}

//MARK: - Delegate implementation maps
extension NoteViewByCodeController : MapViewControllerDelegate, MKMapViewDelegate {
    func saveLocation(_ sender: MapViewController, location: String?) {
        note?.location = location
        do {
           try note?.managedObjectContext?.save()
           
        } catch {
            print(error)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if let location = note?.location {
            let arrLocation = location.split(separator: ",")
            if arrLocation.count == 2 {
                let latitude = Double(arrLocation[0])
                let longitude = Double(arrLocation[1])
                let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: latitude!, longitude: longitude!), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
                mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }
}

extension NoteViewByCodeController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addNewImage(image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func addImageFile(_ image: UIImage) -> String? {
        var fileName : String?
        if let data = UIImagePNGRepresentation(image) {
            let createdDate = Date().formattedDate("dd-MM-yyyy_hh-mm-ss")
            let fileNameURL = getDocumentsDirectory().appendingPathComponent("image_\(createdDate).png")
            do {
                try data.write(to: fileNameURL)
                fileName = fileNameURL.absoluteString
            } catch {
               print(error)
            }
        }
        return fileName
    }
    
    func addImageView(_ image: UIImage, with identifier: String?, leftConstant: Int16?, topConstant: Int16?, angle: Float?, scale: Float?) -> [Int16] {
        
        let newImageView = UIImageView(image: image)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
       
        newImageView.isUserInteractionEnabled = true
        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
        newImageView.addGestureRecognizer(moveViewGesture)
        newImageView.accessibilityIdentifier = identifier
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(showRotater(_:animateTime:)))
        doubleTapGesture.numberOfTapsRequired = 1
        newImageView.addGestureRecognizer(doubleTapGesture)
        
        var leftC = Int16(0)
        var topC =  Int16(0)
        
        if let left = leftConstant {
            leftC = left
        }
        
        if let top = topConstant {
            topC = top
        }
        // constraints de ubicacion
        let leftConstraint = NSLayoutConstraint(item: newImageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: CGFloat(leftC))
        leftConstraint.priority = .defaultHigh
        
        let topConstraint = NSLayoutConstraint(item: newImageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: CGFloat(topC))
        topConstraint.priority = .defaultHigh
        
        // Anade los constraints al mapa global.
        imagesConstraints[newImageView] = [leftConstraint, topConstraint]
        
        var constraints = [leftConstraint, topConstraint]
        
        // constraints para el tamano
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100))
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .height , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200))
        
        // constraints para que no se salga de la noteTextView
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: noteTextView, attribute: .left, multiplier: 1, constant: 0))
        
       // constraints.append(NSLayoutConstraint(item: newImageView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: noteTextView, attribute: .bottom, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: noteTextView, attribute: .right, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: noteTextView, attribute: .top, multiplier: 1, constant: 0))
        
        //rotar la imagen
        rotateZoomImage(image: newImageView, angle: angle, scale: scale)

        backView.addSubview(newImageView)
        backView.addConstraints(constraints)
        return [Int16(leftC),Int16(topC)]
    }
    
    func addNewImage(_ image: UIImage) {
        if let fileName = addImageFile(image) {
            print("url", fileName)
            if let imgName = fileName.split(separator: "/").last?.description {
                let constants = addImageView(image, with: imgName, leftConstant: nil, topConstant: nil,  angle: nil, scale: nil)
                addImageBD(url: imgName, leftConstant: constants[0], topConstant: constants[1])
            }
            
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func loadImages() {
        self.note?.images?.forEach { image in
            let img = image as! Image
            if let picture =  getSavedImage(named: img.localUrl!) {
                self.addImageView(picture, with: img.localUrl!, leftConstant: img.leftConstant, topConstant: img.topConstant, angle: img.rotation, scale: img.zoom)
            }
        }
    }
    
    func createExlusionPaths() -> [UIBezierPath] {
        var exclusionPaths = [UIBezierPath]()
        imagesConstraints.forEach { imageViewKey, value  in
            var rect = view.convert(imageViewKey.frame, to: noteTextView)
            rect = rect.insetBy(dx: -15, dy: -15)
            let path = UIBezierPath(rect: rect)
            
            exclusionPaths.append(path)
        }
        return exclusionPaths
    }
    
}

extension NoteViewByCodeController : UIRotaterDelegate {
    
    func rotater(_ sender: UIRotater, didChangeRotation angle: Float, scale: Float) {
        rotateZoomImage(image: self.imageView, angle: angle, scale: scale)
    }
    
    func rotater(_ sender: UIRotater, didEndRotation angle: Float, scale: Float) {
        editImage(with: imageView.accessibilityIdentifier!, kvcOptions: ["rotation":angle, "zoom":scale])
    }
    
    
    func rotateZoomImage(image: UIImageView, angle: Float?, scale: Float?) {
        UIView.animate(withDuration: 1.0, animations: {
            var transform : CGAffineTransform?
            if let ang = angle {
                if ang > 0 {
                    transform = CGAffineTransform(rotationAngle: CGFloat((ang * .pi) / 180.0))
                }
            }
            
            if let sca = scale {
                if sca > 0 {
                    if let tra = transform {
                        transform = tra.concatenating(CGAffineTransform(scaleX: CGFloat(sca), y: CGFloat(sca)))
                    } else {
                        transform   = CGAffineTransform(scaleX: CGFloat(sca), y: CGFloat(sca))
                    }
                }
            }
            
            if let tra = transform {
                image.transform = tra
            }
        })
    }
    
}
