//
//  LoginViewController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 03.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
 
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        if chreytliAPI.sharedInstance.isLoggedin{
            
            chreytliAPI.sharedInstance.clearHeader()
            
            let alertController = UIAlertController(title: "Ausgelogt", message: "Erfolgreich ausgelogt!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedLogin(sender: AnyObject) {
        
        SwiftLoading().showLoading()
        
        chreytliAPI.sharedInstance.setUser(userNameTxt.text!, pw: passwordTxt.text!)
        _ = chreytliAPI.sharedInstance.getHeader()
        
        if chreytliAPI.sharedInstance.isLoggedin{
            
            SwiftLoading().hideLoading()
            
            navigationController?.popViewControllerAnimated(true)
            //go back to previews view
        
        }else{
            
            SwiftLoading().hideLoading()
        
            let alertController = UIAlertController(title: "Fehler", message: "Login fehlgeschlagen!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
}
