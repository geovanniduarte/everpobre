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
    var rotaterValue = UILabel()
    var zoomerValue = UILabel()
    
    weak var delegate : UIRotaterDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.backgroundColor = .red
        
        sliderRotater.maximumValue = 270
        addSubview(sliderRotater)
        
        sliderZoomer.maximumValue = 1.3
        sliderZoomer.minimumValue = 0.7
        addSubview(sliderZoomer)
        
        rotaterValue.text = "\(sliderRotater.minimumValue)"
        addSubview(rotaterValue)
        
        zoomerValue.text = "\(sliderZoomer.minimumValue)"
        addSubview(zoomerValue)
        
        sliderRotater.translatesAutoresizingMaskIntoConstraints = false
        sliderZoomer.translatesAutoresizingMaskIntoConstraints = false
        rotaterValue.translatesAutoresizingMaskIntoConstraints = false
        zoomerValue.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["zoomerValue": zoomerValue, "sliderRotater" : sliderRotater, "sliderZoomer" : sliderZoomer, "rotaterValue" : rotaterValue] as [String : Any]
        
        //HORIZONTAL
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderRotater]-10-[rotaterValue]-10-|", options: [], metrics: nil, views: viewDict)
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderZoomer]-10-[zoomerValue]-10-|", options: [], metrics: nil, views: viewDict))
        
        //constrains.append(NSLayoutConstraint(item: rotaterValue, attribute: .lastBaseline, relatedBy: .equal, toItem: sliderRotater, attribute: .lastBaseline, multiplier: 1, constant: 0))
        
        //constrains.append(NSLayoutConstraint(item: zoomerValue, attribute: .lastBaseline, relatedBy: .equal, toItem: sliderZoomer, attribute: .lastBaseline, multiplier: 1, constant: 0))
        
        //VERTICAL
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[sliderRotater]-10-[sliderZoomer]-10-|", options: [], metrics: nil, views: viewDict))
        
        constrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[rotaterValue]-10-[zoomerValue]-10-|", options: [], metrics: nil, views: viewDict))
        
        sliderRotater.addTarget(self, action: #selector(changeRotationValue), for: .valueChanged)
        
        sliderZoomer.addTarget(self, action: #selector(changeZoomValue), for: .valueChanged)
        
        addConstraints(constrains)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    @objc func changeRotationValue(sender : UISlider) {
        rotaterValue.text = "\(sender.value)"
        delegate?.rotater(self, didChangeRotation: sender.value)
    }
    
    @objc func changeZoomValue(sender : UISlider) {
        zoomerValue.text = "\(sender.value)"
        delegate?.rotater(self, didChangeZoom: sender.value)
    }
    
}
