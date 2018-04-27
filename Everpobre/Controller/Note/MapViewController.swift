//
//  MapViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/27/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import MapKit
protocol MapViewControllerDelegate : NSObjectProtocol {
    func saveLocation(_ sender: MapViewController, location: String?)
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var editTextLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate : MapViewControllerDelegate?
    var centerCoordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let okBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishViewController))
        navigationItem.rightBarButtonItems = [okBarButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerCoordinate =  mapView.centerCoordinate
        if let myCoordinate = self.centerCoordinate {
            let strCoordinate = "\(myCoordinate.latitude),\(myCoordinate.latitude)"
            print(strCoordinate)
            editTextLocation.text = strCoordinate;
        }
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        centerCoordinate = mapView.centerCoordinate
        if let myCoordinate = self.centerCoordinate {
            let strCoordinate = "\(myCoordinate.latitude),\(myCoordinate.latitude)"
            print(strCoordinate)
            editTextLocation.text = strCoordinate
        }
    }
    
    @objc func finishViewController() {
        let operationQueue = OperationQueue()
        let operation1 = BlockOperation {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let operation2 = BlockOperation {
            if let myDelegate = self.delegate {
                if let myCoordinate = self.centerCoordinate {
                     myDelegate.saveLocation(self, location: "\(myCoordinate.latitude),\(myCoordinate.longitude)")
                }
            }
        }
        
        operation1.addDependency(operation2);
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: false)
    }

}
