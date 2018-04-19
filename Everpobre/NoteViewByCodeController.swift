//
//  NoteViewByCodeController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 3/8/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class NoteViewByCodeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, NotesViewControllerDelegate {
    
    let dateLabel = UILabel()
    let expirationDate = UILabel()
    let titleTextField = UITextField()
    let noteTextView = UITextView()
    
    let imageView = UIImageView()
    var topImgConstraint: NSLayoutConstraint!
    var bottonImgConstraint: NSLayoutConstraint!
    var leftImgConstraint: NSLayoutConstraint!
    var rightImgConstraint: NSLayoutConstraint!
    
    var relativePoint: CGPoint!
    
    var note: Note? {
        didSet {
            noteTextView.text = note?.title
        }
    }
    
    override func loadView() {
        let backView = UIView()
        backView.backgroundColor = .white
        
        // Configuro label
        dateLabel.text = "25/02/2018"
        backView.addSubview(dateLabel)
        
        // Configuro label
        expirationDate.text = "03/04/2018"
        backView.addSubview(expirationDate)
        
        // Configuro textField
        titleTextField.placeholder = "Tittle note"
        backView.addSubview(titleTextField)
        
        // Configuro noteTextView
        noteTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        backView.addSubview(noteTextView)
        
        // Configuro imageView
        imageView.backgroundColor = .red
        backView.addSubview(imageView)
        
        
        
        // MARK: Autolayout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false // no use autoresizing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        expirationDate.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let viewDict = ["dateLabel":dateLabel, "noteTextView":noteTextView,"titleTextField":titleTextField, "expirationDate":expirationDate]
        
        // Horizontals
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[titleTextField]-10-[expirationDate]-10-[dateLabel]-10-|", options: [], metrics: nil, views: viewDict)
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
        // Vertical
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[dateLabel]-10-[noteTextView]-10-|", options: [], metrics: nil, views: viewDict))
        
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
        
        // Img view constrains
        topImgConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: 20)
        
        bottonImgConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: noteTextView, attribute: .bottom, multiplier: 1, constant: -20)
        
        leftImgConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: 20)
        
        rightImgConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: noteTextView, attribute: .right, multiplier: 1, constant: -20)
        
        var imgConstraints = [NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)]
        
        imgConstraints.append(NSLayoutConstraint(item: imageView, attribute: .height , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200))
        
        
        imgConstraints.append(contentsOf: [topImgConstraint,bottonImgConstraint,leftImgConstraint,rightImgConstraint])
        
        
        backView.addConstraints(constrains)
        backView.addConstraints(imgConstraints)
        
        NSLayoutConstraint.deactivate([bottonImgConstraint,rightImgConstraint])
        
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
    }
    
    @objc func userMoveImage(longPressGesture: UILongPressGestureRecognizer) {
        print("es continuado")
        
        switch longPressGesture.state {
        case .began:
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
            })
        case .changed:
            let location = longPressGesture.location(in: noteTextView)
            leftImgConstraint.constant = location.x - relativePoint.x
            topImgConstraint.constant = location.y - relativePoint.y
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1);
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        note?.title = textField.text
        try! note?.managedObjectContext?.save()
    }
    
    @objc func addLocation() {
        
    }
    
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
    {
        self.note = note
    }

}
