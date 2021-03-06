//
//  Alerts.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
func ensureThat_userIsLoggedIn(then callback: @autoclosure ()->()){
    if User.isLoggedIn(){
        callback()
    }else{
        alertUser_toLoginFirst()
    }
}
func ensureThat_userIsLoggedIn(callback: ()->()){
    ensureThat_userIsLoggedIn(then: callback())
}
func ensureThat_userHasRegisteredStore(then callback: @autoclosure ()->()){
    if let _ = Store.ID {
        callback()
    }else{
        alertUser_toRegisterStoreFirst()
    }
}
func alertUser_toLoginFirst(){
    alertUser(title: "Login Required", message: "Please register first, and then log in to your account.")
}
func alertUser_toRegisterStoreFirst(_ callback: ((UIAlertAction)->())? = nil){
    alertUser(title: "You don't have a store", message: "Please register your store first.", completion: callback)
}

func alert_featureToBeImplemented(){
    alertUser(title: "Feature Under Construction", message: "This feature doesn't exist yet")
}

func alertUser(title: String, message: String, dismissText: String = "OK", completion: ((UIAlertAction)->())? = nil){
    let alertErrorController = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
        title: dismissText,
        style: .default,
        handler: completion
    )
    
    alertErrorController.addAction(dismiss)
    UIApplication.topViewController()?.present(alertErrorController, animated: true, completion: nil)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
class LoadingAlert {
    static func getLoadingAlert() -> UIAlertController {
        let loadingAlertController = UIAlertController.init(title: nil, message: "Loading..", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: loadingAlertController.view.bounds)
        
        indicator.frame.origin.x = -60
        indicator.style = .gray
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingAlertController.view.addSubview(indicator)
        indicator.startAnimating()
        
        return loadingAlertController
    }
    
    static func show(vc:UIViewController) {
        vc.navigationController?.present(getLoadingAlert(), animated: true, completion: nil)
    }
    
    static func dismiss() {
        getLoadingAlert().dismiss(animated: true, completion: nil)
    }
}

