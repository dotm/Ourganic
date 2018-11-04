//
//  OrderInvoiceViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 04/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class OrderInvoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Header
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var invoiceNumberLbl: UILabel!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderHistoryView: UIView!
    
    //Order
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var uomLbl: UILabel!
    @IBOutlet weak var totalQtyLbl: UILabel!
    @IBOutlet weak var sendFromLbl: UILabel!
    @IBOutlet weak var sendToLbl: UILabel!
    @IBOutlet weak var deliveryMethodLbl: UILabel!
    @IBOutlet weak var deliveryFeeLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    //History
    @IBOutlet weak var statusHisTableView: UITableView!
    @IBOutlet weak var deliveryMethodHisLbl: UILabel!
    @IBOutlet weak var sendFromHisLbl: UILabel!
    @IBOutlet weak var orderMadeHisLbl: UILabel!
    @IBOutlet weak var statusHisTextView: UITextView!
    @IBOutlet weak var updateStatusHisBtn: UIButton!
    
    //Variable
    var orderModel:OrderModel?
    var isBuyer:Bool = true
    
    //Constant
    let CHECKOUT:String = "Check Out"
    let WAITING_CHECKOUT:String = "Waiting for Check Out"
    let APPROVE_ORDER:String = "Approve Order"
    let APPROVED:String = "Approved"
    let ORDER_RECEIVED:String = "Order Received"
    
    let ACTION_BTN_TAG:Int = 0
    let UPDATE_STATUS_BTN_TAG:Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusHisTableView.delegate = self
        statusHisTableView.dataSource = self
        
        updateStatusHisBtn.tag = UPDATE_STATUS_BTN_TAG
        actionButton.tag = ACTION_BTN_TAG
        
        setupView()
        
        segmentedView.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedView.selectedSegmentIndex = 0
        orderDetailView.isHidden = false
        orderHistoryView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    private func setupView() {
        styleButton(actionButton)
        styleButton(updateStatusHisBtn)
        styleTextView(statusHisTextView)
        if isBuyer {
            setupForBuyer()
        } else {
            setupForSeller()
        }
        
        invoiceNumberLbl.text = orderModel?.invoiceNumber
        productImageView.layer.cornerRadius = 5
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        productImageView.kf.setImage(with: URL(string: orderModel?.product?.image_url ?? ""), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        productNameLbl.text = orderModel?.product?.product_name
        storeNameLbl.text = orderModel?.product?.store_name
        uomLbl.text = orderModel?.product?.unit_measurement
        totalQtyLbl.text = "\(orderModel!.qty)"
        sendFromLbl.text = orderModel?.sendFrom
        sendToLbl.text = orderModel?.sendTo
        deliveryMethodLbl.text = orderModel?.deliveryMethod
        deliveryFeeLbl.text = currencyFormatterUtil((orderModel?.deliveryFee)!)
        productPriceLbl.text = currencyFormatterUtil((orderModel?.product?.price_per_unit)!)
        totalPriceLbl.text = currencyFormatterUtil((orderModel?.totalPrice)!)
        
        deliveryMethodHisLbl.text = orderModel?.deliveryMethod
        sendFromHisLbl.text = orderModel?.sendFrom
        orderMadeHisLbl.text = dateFormatterUtil((orderModel?.createdDate)!)
        
        statusHisTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderModel?.statusHistory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oicell", for: indexPath) as! OrderInvoiceTableViewCell
        if !(orderModel?.statusHistory.isEmpty ?? true ) && indexPath.row == 0 {
            cell.statusLbl.textColor = UIColor.init(named: "cGreen")
            cell.pointLbl.textColor = UIColor.init(named: "cGreen")
            cell.statusExtraLbl.textColor = UIColor.init(named: "cGreen")
        } else {
            cell.statusLbl.textColor = UIColor.black
            cell.pointLbl.textColor = UIColor.black
            cell.statusExtraLbl.textColor = UIColor.black
        }
        if isBuyer {
            cell.statusLbl.text = orderModel?.statusHistory[indexPath.row].buyerDesc
            cell.statusExtraLbl.text = dateFormatterUtil(orderModel?.statusHistory[indexPath.row].createdDate ?? dateFromString(DATE_STR_NIL))
        } else {
            cell.statusLbl.text = orderModel?.statusHistory[indexPath.row].sellerDesc
            cell.statusExtraLbl.text = dateFormatterUtil(orderModel?.statusHistory[indexPath.row].createdDate ?? dateFromString(DATE_STR_NIL))
        }
        return cell
    }

    private func setupForBuyer() {
        updateStatusHisBtn.isHidden = true
        statusHisTextView.isHidden = true
        if let statusCode = orderModel?.statusHistory[0].code, statusCode == 3 {
            actionButton.setTitle(ORDER_RECEIVED, for: .normal)
            actionButton.backgroundColor = UIColor(named: "cDisable")
            actionButton.isEnabled = false
        } else if let statusCode = orderModel?.statusHistory[0].code, statusCode == 2 {
            actionButton.setTitle(ORDER_RECEIVED, for: .normal)
            actionButton.isEnabled = true
        } else if let statusCode = orderModel?.statusHistory[0].code, statusCode == 0 {
            actionButton.setTitle(CHECKOUT, for: .normal)
            actionButton.isEnabled = true
        } else {
            actionButton.setTitle(CHECKOUT, for: .normal)
            actionButton.backgroundColor = UIColor(named: "cDisable")
            actionButton.isEnabled = false
        }
    }
    
    private func setupForSeller() {
        updateStatusHisBtn.isHidden = false
        updateStatusHisBtn.isEnabled = false
        updateStatusHisBtn.backgroundColor = UIColor(named: "cDisable")
        if let statusCode = orderModel?.statusHistory[0].code, statusCode == 1 {
            actionButton.setTitle(APPROVE_ORDER, for: .normal)
            actionButton.isEnabled = true
        } else if let statusCode = orderModel?.statusHistory[0].code, statusCode == 0 {
            actionButton.setTitle(WAITING_CHECKOUT, for: .normal)
            actionButton.backgroundColor = UIColor(named: "cDisable")
            actionButton.isEnabled = false
        } else {
            actionButton.setTitle(APPROVED, for: .normal)
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor(named: "cDisable")
            updateStatusHisBtn.isEnabled = true
            updateStatusHisBtn.backgroundColor = UIColor(named: "cOrange")
        }
    }
    
    @objc private func segmentedControlChanged(_ control: UISegmentedControl){
        switch segmentedView.selectedSegmentIndex {
        case 0:
            orderDetailView.isHidden = false
            orderHistoryView.isHidden = true
        case 1:
            orderDetailView.isHidden = true
            orderHistoryView.isHidden = false
        default:
            orderDetailView.isHidden = true
            orderHistoryView.isHidden = true
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        var status = statusCons[0]
        if sender.tag == UPDATE_STATUS_BTN_TAG {
            status = statusCons[2]
            status.buyerDesc = statusHisTextView.text ?? ""
            status.sellerDesc = statusHisTextView.text ?? ""
        } else {
            print(sender.titleLabel!.text)
            if ((sender.titleLabel?.text!.isEqual(CHECKOUT))!){
                status = statusCons[1]
            } else if ((sender.titleLabel?.text!.isEqual(APPROVE_ORDER))!){
                status = statusCons[2]
            } else if ((sender.titleLabel?.text!.isEqual(ORDER_RECEIVED))!){
                status = statusCons[3]
            }
        }
        status.createdDate = Date()
        update(status: status, orderId: (orderModel?.id)!) { (result, err) in
            self.orderModel?.statusHistory = result!
            self.statusHisTextView.text = ""
            self.setupView()
            self.statusHisTableView.reloadData()
        }
    }
    
}
