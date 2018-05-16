//
//  UIRotater.swift
//  Everpobre
//
//  Created by DesarrolloMac1 on 7/05/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
protocol UIRotaterDelegate: NSObjectProtocol {
    func rotater(_ sender: UIRotater, didChangeRotation angle: Float, scale: Float)
    func rotater(_ sender: UIRotater, didEndRotation angle: Float, scale: Float)
}

class UIRotater: UIView {
    
    var sliderRotater = UISlider()
    var sliderZoomer = UISlider()
    var rotaterValue = UILabel()
    var zoomerValue = UILabel()
    var myconstrains : [NSLayoutConstraint]!
    
    weak var delegate : UIRotaterDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
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
        myconstrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderRotater]-10-[rotaterValue]-10-|", options: [], metrics: nil, views: viewDict)
        
        myconstrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[sliderZoomer]-10-[zoomerValue]-10-|", options: [], metrics: nil, views: viewDict))
        
        //VERTICAL
        myconstrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[sliderRotater]-10-[sliderZoomer]-10-|", options: [], metrics: nil, views: viewDict))
        
        myconstrains.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[rotaterValue]-10-[zoomerValue]-10-|", options: [], metrics: nil, views: viewDict))
        
        sliderRotater.addTarget(self, action: #selector(changeRotationValue), for: .valueChanged)
        
        sliderZoomer.addTarget(self, action: #selector(changeZoomValue), for: .valueChanged)
        
        sliderRotater.addTarget(self, action: #selector(finishRotation(sender:)), for: .touchUpInside)
        
        sliderZoomer.addTarget(self, action: #selector(finishZoom), for: .touchUpInside)
        
        print(self.constraints.count)
        setPriorityConstraints()
        
        addConstraints(myconstrains)
        
    }
    
    func setPriorityConstraints() {
        self.myconstrains.forEach { constraint in
            print("defaultHigh for constraint")
            constraint.priority = .defaultHigh
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    @objc func changeRotationValue(sender : UISlider) {
        rotaterValue.text = "\(sender.value)"
        delegate?.rotater(self, didChangeRotation: sliderRotater.value, scale: sliderZoomer.value)
    }
    
    @objc func changeZoomValue(sender : UISlider) {
        zoomerValue.text = "\(sender.value)"
        delegate?.rotater(self, didChangeRotation: sliderRotater.value, scale: sliderZoomer.value)
    }
    
    @objc func finishRotation(sender : UISlider) {
        delegate?.rotater(self, didEndRotation: sliderRotater.value, scale: sliderZoomer.value)
    }
    
    @objc func finishZoom(sender : UISlider) {
        delegate?.rotater(self, didEndRotation: sliderRotater.value, scale: sliderZoomer.value)
    }
}
