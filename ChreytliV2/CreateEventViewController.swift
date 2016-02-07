//
//  CreateEventViewController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 03.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var sDateText: UITextField!
    @IBOutlet weak var eDateTest: UITextField!
    
    var editableTextfield : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        eDateTest.inputView = datePickerView
        sDateText.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func StartDatum(sender: AnyObject) {
        editableTextfield = false
    }
    
    @IBAction func EndDatum(sender: AnyObject) {
        editableTextfield = true
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if editableTextfield{
            eDateTest.text = dateFormatter.stringFromDate(sender.date)

        }else{
            sDateText.text = dateFormatter.stringFromDate(sender.date)

        }
        
    }
}
