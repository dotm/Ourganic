//
//  PriceStepper.swift
//  PriceStepper
//
//  Created by Yoshua Elmaryono on 31/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

@IBDesignable class PriceStepper: UIView {
    private var totalQty:Double?
    
    //MARK: Properties
    @IBInspectable var minimal_quantity: Double = 250 {
        didSet { reloadDisplayedText() }
    }
    @IBInspectable var unit_measurement: String = "gram" {
        didSet { reloadDisplayedText() }
    }
    var units_ordered: UInt = 1 {
        didSet { reloadDisplayedText() }
    }
    private func reloadDisplayedText(){
        displayedTextLabel.text = getDisplayedText()
    }
    private func getDisplayedText() -> String {
        self.totalQty = minimal_quantity * Double(units_ordered)
        let displayedText = "\(totalQty!) \(unit_measurement)"
        return displayedText
    }
    
    func getTotalQty() -> Double {
        return Double(self.totalQty ?? 0)
    }
    
    //MARK: Outlets
    private weak var stepDownButton: UILabel!
    private weak var stepUpButton: UILabel!
    private weak var displayedTextLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    private func setupLayout(){
        let view = self
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        setupStepDownButton(parent: view)
        setupStepUpButton(parent: view)
        setupDisplayedText(parent: view)
    }
    private func setupStepDownButton(parent view: UIView){
        let stepDownButton = UILabel()
        stepDownButton.text = "-"
        stepDownButton.textAlignment = .center
        stepDownButton.font = UIFont(name: stepDownButton.font.fontName, size: 40)
        stepDownButton.textColor = .white
        stepDownButton.backgroundColor = defaultTitleTextColor
        
        view.addSubview(stepDownButton)
        stepDownButton.translatesAutoresizingMaskIntoConstraints = false
        stepDownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stepDownButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stepDownButton.widthAnchor.constraint(equalTo: stepDownButton.heightAnchor).isActive = true
        stepDownButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stepDown))
        stepDownButton.isUserInteractionEnabled = true
        stepDownButton.addGestureRecognizer(tapGestureRecognizer)
        self.stepDownButton = stepDownButton
    }
    
    @objc private func stepDown(){
        if units_ordered == 0 {return}
        units_ordered -= 1
    }
    private func setupStepUpButton(parent view: UIView){
        let stepUpButton = UILabel()
        stepUpButton.text = "+"
        stepUpButton.textAlignment = .center
        stepUpButton.textColor = .white
        stepUpButton.font = UIFont(name: stepUpButton.font.fontName, size: 40)
        stepUpButton.backgroundColor = defaultTitleTextColor
        
        view.addSubview(stepUpButton)
        stepUpButton.translatesAutoresizingMaskIntoConstraints = false
        stepUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stepUpButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stepUpButton.widthAnchor.constraint(equalTo: stepUpButton.heightAnchor).isActive = true
        stepUpButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stepUp))
        stepUpButton.isUserInteractionEnabled = true
        stepUpButton.addGestureRecognizer(tapGestureRecognizer)
        self.stepUpButton = stepUpButton
    }
    @objc private func stepUp(){
        units_ordered += 1
    }
    private func setupDisplayedText(parent view: UIView){
        let label = UILabel()
        label.text = getDisplayedText()
        label.textAlignment = .center
        //label.font = UIFont(name: label.font.fontName, size: 40)
        label.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: stepDownButton.trailingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: stepUpButton.leadingAnchor).isActive = true
        
        self.displayedTextLabel = label
    }
}
