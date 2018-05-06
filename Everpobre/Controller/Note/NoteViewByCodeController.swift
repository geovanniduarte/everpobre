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

enum datePickerVariations : CGFloat {
    case heighOpened = 214
    case heighMarginClosed = 0
    case marginOpen = 0.5
}

let IMAGE_ENTITY_NAME = "Image"
typealias ImageContraintsPairs = [String: [NSLayoutConstraint]]
class NoteViewByCodeController: UIViewController , UINavigationControllerDelegate, UITextFieldDelegate, NotesViewControllerDelegate {
    
    let backView = UIView()
    let dateLabel = UILabel()
    let expirationDate = UIButton() //textField .
    let titleTextField = UITextField()
    let noteTextView = UITextView()
    let notebookPickerView = UIPickerView()
    var imageView = UIImageView()
    let testButton = UIButton()
    let datePicker = UIDatePicker()
    let mapView = MKMapView()
    
    var topImgConstraint: NSLayoutConstraint!
    var bottonImgConstraint: NSLayoutConstraint!
    var leftImgConstraint: NSLayoutConstraint!
    var rightImgConstraint: NSLayoutConstraint!
    
    
    var heighDatePickerConstraint : NSLayoutConstraint!
    var marginTopDatePickerConstraint : NSLayoutConstraint!
    
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
        
        //let parentView = UIView()
        
        //let scrollView = UIScrollView()
        
        //parentView.addSubview(scrollView)
        //scrollView.addSubview(backView)
        imagesConstraints = [:]
        
        backView.backgroundColor = .white
    
        // Configuro label
        if let creationDateDouble = note?.createdAtTi {
            dateLabel.text = Date(timeIntervalSince1970: creationDateDouble).formattedDate("dd/MM/yyyy")
        }
        
        backView.addSubview(dateLabel)
        
        // Configuro label
        if let expirationDateDouble = note?.expirationDate {
            expirationDate.setTitle(Date(timeIntervalSince1970: expirationDateDouble).formattedDate("dd/MM/yyyy"), for: .normal)
            expirationDate.setTitleColor(UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0), for: .normal)
            expirationDate.addTarget(self, action: #selector(showDatePicker2(_:animateTime:)), for: .touchUpInside)
        }
        
        backView.addSubview(expirationDate)
        // Configuro textField
        titleTextField.placeholder = "Tittle note"
        backView.addSubview(titleTextField)
        
        // Configuro noteTextView
        noteTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        noteTextView.backgroundColor = UIColor.blue
        backView.addSubview(noteTextView)
        
        //configuro notebook picker
        notebookPickerView.delegate =  self
        notebookPickerView.dataSource = self
        backView.addSubview(notebookPickerView)
        
        //if (self.note?.location != nil) {
            mapView.delegate = self
            backView.addSubview(mapView)
        //}
        
        
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 5
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.isHidden = true
        backView.addSubview(datePicker)
        
        
        // MARK: Autolayout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false // no use autoresizing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        expirationDate.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        notebookPickerView.translatesAutoresizingMaskIntoConstraints = false;
        testButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints =  false
        //backView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let viewDict = ["dateLabel":dateLabel, "noteTextView":noteTextView,"titleTextField":titleTextField, "expirationDate":expirationDate, "notebookPickerView":notebookPickerView, "testButton":testButton, "datePicker":datePicker, "mapView":mapView]

        // Horizontals
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[titleTextField]-10-[expirationDate]-10-[dateLabel]-10-|", options: [], metrics: nil, views: viewDict)
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[notebookPickerView]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[datePicker]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[mapView]-10-|", options: [], metrics: nil, views: viewDict))
        
        // constratins para el backview (top, bottom, leading and trailing) as (0,0,0,0).
        //let viewDictScroll = ["backView": backView, "scrollView": scrollView]
        //var backViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[backView]-0-|", options: [], metrics: nil, views: viewDictScroll)
    
    
        // TO-DO para el scrollview, (top, bottom, leading and trailing) as (0,0,0,0).
        //var scrollViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[scrollView]-0-|", options: [], metrics: nil, views: viewDictScroll)
        
        // TO-DO view must have equal width and equal height
        //backViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "[backView(==scrollView)]", options:[], metrics: nil, views: viewDictScroll))
        
        
        // Verticals
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[dateLabel]-10-[datePicker]-10-[mapView]-10-[notebookPickerView]-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
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
       
        
    //backViewConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[backView]-0-|", options: [], metrics: nil, views: viewDictScroll))
        
        //scrollViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollView]-0-|", options: [], metrics: nil, views: viewDictScroll))
        
        
        //let equalHeightBackViewConst = NSLayoutConstraint(item: backView, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0)
        //equalHeightBackViewConst.priority = UILayoutPriority(rawValue: 250)
        //backViewConstraints.append(equalHeightBackViewConst)
        
        // Img view constrains
        //topImgConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: 20)
        
        //bottonImgConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: noteTextView, attribute: .bottom, multiplier: 1, constant: -20)
        
        //leftImgConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: 20)
        
        //rightImgConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: noteTextView, attribute: .right, multiplier: 1, constant: -20)
        
        //var imgConstraints = [NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)]
        
        //imgConstraints.append(NSLayoutConstraint(item: imageView, attribute: .height , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200))
        
        //imgConstraints.append(contentsOf: [topImgConstraint,bottonImgConstraint,leftImgConstraint,rightImgConstraint])
        
        // DatePicker constraints
        
        heighDatePickerConstraint = NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        marginTopDatePickerConstraint = NSLayoutConstraint(item: datePicker, attribute: .topMargin, relatedBy: .equal, toItem: expirationDate, attribute: .bottomMargin, multiplier: 1, constant: 0.0)
        
        //parentView.addConstraints(scrollViewConstraints)
        //scrollView.addConstraints(backViewConstraints)
        backView.addConstraints(constrains)
        //backView.addConstraints(imgConstraints)
        backView.addConstraints([heighDatePickerConstraint, marginTopDatePickerConstraint])
        
        //NSLayoutConstraint.deactivate([bottonImgConstraint,rightImgConstraint])
        
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
        */
        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
        
        imageView.addGestureRecognizer(moveViewGesture)
        
        loadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        syncModel();
        
    }
    
    
    override func viewDidLayoutSubviews()
    {
        var rect = view.convert(imageView.frame, to: noteTextView)
        rect = rect.insetBy(dx: -15, dy: -15)
        
        let paths = UIBezierPath(rect: rect)
        noteTextView.textContainer.exclusionPaths = [paths]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        note?.title = textField.text
        try! note?.managedObjectContext?.save()
    }
    
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
    {
        self.note = note
        syncModel()
    }
    
    func syncModel() {
        titleTextField.text = note?.title
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
    
    func addImageBD(url: String, leftConstant: Int16, topConstant: Int16) {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let image = NSEntityDescription.insertNewObject(forEntityName: IMAGE_ENTITY_NAME, into: privateMOC) as! Image
            image.localUrl = url
            image.leftConstant = leftConstant
            image.topConstant = topConstant
            print("images count: ",self.note?.images?.count)
            let noteCopy = privateMOC.object(with: (self.note?.objectID)!)
            image.note = noteCopy as? Note
            try! privateMOC.save()
            print("images count: ",self.note?.images?.count)
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
}

// MARK: - Actions
extension NoteViewByCodeController {
    func showDatePicker(_ sender: UIButton) {
        let datePicker = UIDatePicker()//Date picker
        //datePicker.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        datePicker.translatesAutoresizingMaskIntoConstraints =  false
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 5
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        
        
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(datePicker)
        // here you can add tool bar with done and cancel buttons if required
        
        let popoverViewController = UIViewController()
        popoverViewController.view = popoverView
        //popoverViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width: 320, height: 216)
        popoverViewController.popoverPresentationController?.sourceView = sender // source button
        popoverViewController.popoverPresentationController?.sourceRect = sender.bounds // source button bounds
        self.present(popoverViewController, animated: true, completion: nil)
        
        
    }
    
     @objc func showDatePicker2(_ sender: UIButton, animateTime: TimeInterval) {
        datePicker.isHidden = !datePicker.isHidden
        let isShow = !datePicker.isHidden
        
        UIView.animate(withDuration: 0.5) {
            self.heighDatePickerConstraint.constant = (isShow ? datePickerVariations.heighOpened.rawValue : datePickerVariations.heighMarginClosed.rawValue)
            
            self.marginTopDatePickerConstraint.constant = (isShow ? datePickerVariations.marginOpen.rawValue : datePickerVariations.heighMarginClosed.rawValue)
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        self.expirationDate.setTitle(datePicker.date.formattedDate("dd/MM/yyyy"), for: .normal)
        note?.expirationDate = datePicker.date.timeIntervalSince1970
        try! note?.managedObjectContext?.save()
    }
    
    @objc func userMoveImage(longPressGesture: UILongPressGestureRecognizer) {
        print("es continuado")
    
        switch longPressGesture.state {
        case .began:
            imageView = longPressGesture.view as! UIImageView
            relativePoint = longPressGesture.location(in: imageView)
            if let id = imageView.accessibilityIdentifier {
                let constraints = imagesConstraints[id]
                leftImgConstraint = constraints?[0]
                topImgConstraint = constraints?[1]
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
            })
        case .changed:
            
            let location = longPressGesture.location(in: noteTextView)
            leftImgConstraint?.constant = location.x - relativePoint.x
            topImgConstraint?.constant = location.y - relativePoint.y
            
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
        
        present(actionSheetAlert, animated: true, completion: nil)
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
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(filename).absoluteString
        return fileURL
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
    
    func addImageView(_ image: UIImage, with identifier: String?, leftConstant: Int16?, topConstant: Int16?) -> [Int16] {
        let newImageView = UIImageView(image: image)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.isUserInteractionEnabled = true
        newImageView.accessibilityIdentifier = identifier
        backView.addSubview(newImageView)
        
        var leftC = Int16(0)
        var topC =  Int16(0)
        
        if let left = leftConstant {
            leftC = left
        }
        
        if let top = topConstant {
            topC = top
        }
        
        let leftConstraint = NSLayoutConstraint(item: newImageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: CGFloat(leftC))
        
        let topConstraint = NSLayoutConstraint(item: newImageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: CGFloat(topC))
        
        if let id = identifier {
             imagesConstraints[id] = [leftConstraint, topConstraint]
        }
    
        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
        
        newImageView.addGestureRecognizer(moveViewGesture)
        
        var constraints = [leftConstraint, topConstraint]
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100))
        
        constraints.append(NSLayoutConstraint(item: newImageView, attribute: .height , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200))
        
        backView.addConstraints(constraints)
        return [Int16(leftC),Int16(topC)]
    }
    
    func addNewImage(_ image: UIImage) {
        if let fileName = addImageFile(image) {
            let constants = addImageView(image, with: fileName, leftConstant: nil, topConstant: nil)
             addImageBD(url: fileName, leftConstant: constants[0], topConstant: constants[1])
        }
    }
    
    func loadImages() {
        self.note?.images?.forEach { image in
            let img = image as! Image
            print(img.localUrl!)
            print(UIImage(contentsOfFile: fileInDocumentsDirectory(filename: img.localUrl!)))
            if let picture =  UIImage(contentsOfFile: img.localUrl!) {
                self.addImageView(picture, with: img.localUrl!, leftConstant: img.leftConstant, topConstant: img.topConstant)
            }
        }
    }
    
}
