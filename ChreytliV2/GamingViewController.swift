//
//  GamingViewController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 03.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//


import UIKit

class GamingViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    @IBOutlet weak var myBrowser: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myBrowser.delegate = self
        
        browserLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if chreytliAPI.sharedInstance.isLoggedin{
            loginBtn.title = "Logout"
            
        }else{
            loginBtn.title = "Login"
            
        }
    }
    
    @IBAction func pressedRefresh(sender: AnyObject) {
        
        browserLoad()
    }
    
    func browserLoad(){
        
        let localfilePath = NSBundle.mainBundle().URLForResource("home", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        myBrowser.loadRequest(myRequest);
        
    }
    
    
}