//
//  ShowSubmitViewController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 04.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class ShowSubmitViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var URL : String = ""
    var type : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self
        
        loadBrowser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBrowser(){
        
        switch type {
        case 5:
            let htmlString:String! = URL
            webView.loadHTMLString(htmlString, baseURL: nil)
        default:
            let url = NSURL (string: URL);
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
        }
        
        
    }
    
}