//
//  CustomStyling.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 16/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

let defaultCornerRadius = CGFloat(8)
let defaultTitleTextColor = UIColor(named: "cGreen")
let defaultButtonColor = UIColor(named: "cOrange")
let defaultHamTintColor = UIColor(named: "cGreenHam")
let defaultTurqoiseLblColor = UIColor(named: "cTurqoise")
let defaultDescLabelColor = UIColor(named: "cDescLblColor") 


func styleTitleLabel(_ label: UILabel){
    label.textColor = defaultTitleTextColor
    label.font = UIFont(name: "Avenir", size: label.font.pointSize)
}
func styleLink(_ label: UILabel){
    label.textColor = defaultButtonColor
}

func styleViewCorner(_ view: UIView){
    view.layer.cornerRadius = 30
}

func styleNavigationBar(_ navbar: UINavigationBar){
    navbar.tintColor = defaultButtonColor
    navbar.barTintColor = .white
    navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultTitleTextColor]
}

func styleButton(_ button: UIButton){
    button.layer.cornerRadius = defaultCornerRadius
    button.tintColor = .white
    button.backgroundColor = defaultButtonColor
    button.setTitleColor(.white, for: .normal)
    button.alpha = 1
}

func styleTextField(_ textField: UITextField){
    textField.layer.cornerRadius = defaultCornerRadius
    textField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
    textField.layer.borderWidth = 1.5
    textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
    textField.leftViewMode = .always
}

func styleTextView(_ textView: UITextView){
    textView.layer.cornerRadius = defaultCornerRadius
    textView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
    textView.layer.borderWidth = 1.5
    textView.font = UITextField().font
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
}
