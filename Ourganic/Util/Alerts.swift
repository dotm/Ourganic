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
    let alertErrorController = UIAlertController(
        title: "Login Required",
        message: "Please log in to your account first.",
        preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
        title: "OK",
        style: .default,
        handler: nil
    )
    alertErrorController.addAction(dismiss)
    UIApplication.topViewController()?.present(alertErrorController, animated: true, completion: nil)
}
func alertUser_toRegisterStoreFirst(){
    let alertErrorController = UIAlertController(
        title: "You don't have a store",
        message: "Please register your store first.",
        preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
        title: "OK",
        style: .default,
        handler: nil
    )
    alertErrorController.addAction(dismiss)
    UIApplication.topViewController()?.present(alertErrorController, animated: true, completion: nil)
}

func alert_featureToBeImplemented(){
    let alertErrorController = UIAlertController(
        title: "Feature Under Construction",
        message: "This feature doesn't exist yet",
        preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
        title: "OK",
        style: .default,
        handler: nil
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
