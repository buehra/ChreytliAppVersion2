//
//  ChreytliAPI.swift
//  Chreytli
//
//  Created by Raphael Bühlmann on 27.12.15.
//  Copyright © 2015 CoderCAE. All rights reserved.
//

import Foundation
import Alamofire
import JSONJoy

final class chreytliAPI {
    
    static let sharedInstance = chreytliAPI()
    
    // API base URL.
    private let apiBaseURL = "http://api.chreyt.li/"
    
    internal var isLoggedin : Bool = false
    
    private var userName : String
    private var password : String
    
    private var headers = [String:String]()
    private var events = [Event]()
    private var userInfo = Author()
    
    private var allEntries : Bool = false
    
    init(){
        
        userName = ""
        password = ""
    
    }
    
    func setUser(usrName:String, pw: String){
        
        userName = usrName
        password = pw
    
    }
    
    func getHeader() -> [String:String]{
        
        if self.headers.count != 0{
            
            self.isLoggedin = true
            getUserInfo()
            return headers
        
        } else {
            
            return getAccessKey()
        }
    
    }
    
    func clearHeader(){
        
        self.isLoggedin = false
        
        self.headers.removeAll()
    
    }
    
    func setHeaderFromMemory(header: [String:String]){
        
        headers = header
        self.isLoggedin = true
        getUserInfo()
    
    }
    
    private func setHeader(tocken: Tocken){
        
        if tocken.tokentype == nil{
            
            self.isLoggedin = false
            
            
        }else{
            
            self.headers = [
                "Authorization": tocken.tokentype!+" "+tocken.accesstoken!,
                "Content-Type": "application/json"
            ]
            
            self.isLoggedin = true
            
        }
        
    }
    
    private func getAccessKey() -> [String:String]{
        
        var threadEnd = 0
        
        let body = ["grant_type": "password", "userName": userName, "password": password]
        
        Alamofire.request(.POST, apiBaseURL+"Token", parameters: body)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let tocken = Tocken(JSONDecoder(response.result.value!))
                    self.setHeader(tocken)
                    threadEnd = 1
                }else{
                    threadEnd = -1
                }
                
        }
        
        while threadEnd == 0{
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
        getUserInfo()
        
        return headers
    }
    
    func favoritSubmit(id : Int){
        
        var threadEnd = 0
        
        //api/Submissions/{id}/Favorite?userId={userId}
        Alamofire.request(.POST, apiBaseURL+"api/Submissions/"+String(id)+"/Favorite?userId="+userInfo.id!, headers: headers)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    self.userInfo = Author(JSONDecoder(response.result.value!))
                    threadEnd = 1
                }else{
                    threadEnd = -1
                }
        }
        
        while threadEnd == 0{
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
    
    }
    
    private func getUserInfo(){
        var threadEnd = 0
        
        Alamofire.request(.GET, apiBaseURL+"api/Account/UserInfo", headers: headers)
            .responseJSON { response in
                
                if response.result.isSuccess {

                    self.userInfo = Author(JSONDecoder(response.result.value!))
                    threadEnd = 1
                }else{
                    threadEnd = -1
                }
                
        }
        
        while threadEnd == 0{
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
    
    }
    
    
    func getSubmissions(pages:Int) -> [Submit]{
        
        var submissions = [Submit]()
        var threadEnd = 0
        var apiURL : String
        
        if self.allEntries{
            
            exit(0)
        }
        
        if isLoggedin{
            
            let midle = "api/Submissions?userId="+userInfo.id!
            
            apiURL = apiBaseURL+midle+"&page="+String(pages)+"&filter=sfw&filter=nsfw&filter=nsfl"
        
        }else{
        
            apiURL = apiBaseURL+"api/Submissions?page="+String(pages)+"&filter=sfw&filter=nsfw&filter=nsfl"
        }
        
        Alamofire.request(.GET, apiURL, headers: headers)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    let json = Submissions(JSONDecoder(response.result.value!))
                    
                    if json.submit?.count != 0{
                        
                        for name in json.submit! {
                            submissions.append(name)
                            
                        }
                        
                        threadEnd = 1
                        
                    }else{
                        self.allEntries = true
                        threadEnd = -1
                    }
                }
        }
        
        while threadEnd == 0{
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
        return submissions
    }
    
    
    func getEvents() -> [Event]{
        
         var threadEnd = 0
        
        Alamofire.request(.GET, apiBaseURL+"api/events")
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let json = Events(JSONDecoder(response.result.value!))
                    
                    for name in json.events!{
                        
                        self.events.append(name)
                        
                    }
                    threadEnd = 1
                    
                }else{
                    self.allEntries = true
                    threadEnd = -1
                }
        }
        
        while threadEnd == 0{
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
        return self.events
    
    
    }
    
    func getUserInfoExist() -> Author{
        return userInfo
    }
    
    
    
}

    
    

    

