//
//  ViewController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 03.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit
import Alamofire
import JSONJoy

class ViewController: UICollectionViewController {
    
    @IBOutlet var collectionHubView: UICollectionView!
    @IBOutlet weak var postSubmitBtn: UIBarButtonItem!
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    
    
    var loadedContentCount : Int = 0
    var pages : Int = 0
    var index : Int = 0
    
    var allEntries : Bool = false
    let apiBaseURL = "http://api.chreyt.li/"
    
    var submissions = [Submit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionHubView.delegate = self
        collectionHubView.dataSource = self
        
        getSubmissions()
    }
    
    override func viewWillAppear(animated: Bool) {
        if chreytliAPI.sharedInstance.isLoggedin{
            
            postSubmitBtn.enabled = true
            loginBtn.title = "Logout"
        
            loadedContentCount++
            
        }else{
            
            postSubmitBtn.enabled = false
            loginBtn.title = "Login"
        
            loadedContentCount = 0
        }
        
        if self.loadedContentCount == 1{
            submissions.removeAll()
            pages = 0
            getSubmissions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submissions.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomCellView = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCellView
        cell.userText.text = submissions[indexPath.row].author?.name
        cell.SubmitImage.imageFromUrl(submissions[indexPath.row].imgUrl!)
        cell.DienstText.text = submissions[indexPath.row].dienst
        cell.DienstText.backgroundColor = submissions[indexPath.row].color
        
        let buttonTitel : String = String(submissions[indexPath.row].score!)+" \u{f004}"
        cell.ScoreBtn.setTitle(buttonTitel, forState: UIControlState.Normal)
        
        if submissions[indexPath.row].isFavorite!{
            cell.ScoreBtn.titleLabel!.textColor = UIColor.redColor()
        }
        
        cell.index = submissions[indexPath.row].id!
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        index = indexPath.row
        performSegueWithIdentifier("showSubmission", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSubmission" {
            let vc = segue.destinationViewController as! ShowSubmitViewController
            
            vc.URL = submissions[index].Url!
            vc.type = submissions[index].type!
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let lastRowIndex = collectionHubView.numberOfItemsInSection(0)
        if indexPath.row == lastRowIndex - 1 {
            pages++
            getSubmissions()
        }
    }
    
    func getSubmissions(){
        
        SwiftLoading().showLoading()
        
        if self.allEntries{
            
            SwiftLoading().hideLoading()
            exit(0)
        }
        
        var apiURL : String
        
        
        if chreytliAPI.sharedInstance.isLoggedin{
            
            let userInfo = chreytliAPI.sharedInstance.getUserInfoExist()
            let midle = "api/Submissions?userId="+userInfo.id!
            
            apiURL = apiBaseURL+midle+"&page="+String(pages)+"&filter=sfw&filter=nsfw&filter=nsfl"
            
        }else{
            
            apiURL = apiBaseURL+"api/Submissions?page="+String(pages)+"&filter=sfw&filter=nsfw&filter=nsfl"
        }
        
        Alamofire.request(.GET, apiURL)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    let json = Submissions(JSONDecoder(response.result.value!))
                    
                    if json.submit?.count != 0{
                        
                        for name in json.submit! {
                            self.submissions.append(name)
                        }
                        
                        self.collectionHubView.reloadData()
                        SwiftLoading().hideLoading()
                        
                    }else{
                        self.allEntries = true
                    }
                }
        }
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

