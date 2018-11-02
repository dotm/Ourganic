//
//  OrderDetailViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController {
    @IBOutlet weak var invoiceNumberLbl: UILabel!
    @IBOutlet weak var totalPaymentLbl: UILabel!
    @IBOutlet weak var paymentDeadline: UILabel!
    
    var order:OrderModel?
    
    var notifVC: NotificationViewController = NotificationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = Date().addingTimeInterval(2 * 60 * 60)
        paymentDeadline.text = "Pay Before : \(dateFormatter.string(from: date))"
        paymentDeadline.textColor = UIColor.black
        invoiceNumberLbl.text = order?.invoiceNumber
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "id-ID")
        let prodPrice = numberFormatter.string(from: NSNumber(value: (order?.totalPrice)!))
        totalPaymentLbl.text = prodPrice
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
    }
    
    
    
}
