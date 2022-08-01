//
//  AddViewController.swift
//  Reminder App
//
//  Created by Rustem Manafov on 02.08.22.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var bodyLabel: UITextField!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(btnSave))
        
    }
    
    @objc func btnSave() {
        if let titleText = titleLabel.text, !titleText.isEmpty, let bodyText = bodyLabel.text, !bodyText.isEmpty {
            let targetDate = pickerView.date
            
            completion?(titleText, bodyText, targetDate)
        }
    }


}
