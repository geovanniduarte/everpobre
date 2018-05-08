//
//  UIRotater.swift
//  Everpobre
//
//  Created by DesarrolloMac1 on 7/05/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
protocol UIRotaterDelegate: NSObjectProtocol {
    func rotater(_ sender: UIRotater, didChangeRotation: Float)
    func rotater(_ sender: UIRotater, didChangeZoom: Float)
}
class UIRotater: UIView {
    
    var sliderRotater = UISlider()
    var sliderZoomer = UISlider()
    weak var delegate : UIRotaterDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.backgroundColor = .red
        addSubview(sliderRotater)
        addSubview(sliderZoomer)
        
        sliderRotater.translatesAutoresizingMaskIntoConstraints = false
        sliderZoomer.translatesAutoresizingMaskIntoConstraints = false
        
        sliderRotater.maximumValue = 270
        sliderZoomer.maximumValue = 1.3
        sliderZoomer.minimumValue = 0.7
        
        let viewDict = ["sliderRotater" : sliderRotater, "sliderZoomer" : sliderZoomer]
        
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderRotater]-10-|", options: [], metrics: nil, views: viewDict)
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderZoomer]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[sliderRotater]-10-[sliderZoomer]-10-|", options: [], metrics: nil, views: viewDict))
        
        addConstraints(constrains)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
}
