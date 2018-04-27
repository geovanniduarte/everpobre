//
//  MapViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/27/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var editTextLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let centerCoordinate =  mapView.centerCoordinate
        
        print(centerCoordinate)
        
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let centerCoordinate = mapView.centerCoordinate
        
        
        print(centerCoordinate)
    }

}
