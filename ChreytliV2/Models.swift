//
//  Models.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 05.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import Foundation
import JSONJoy

struct Event : JSONJoy{
    
    var Date:NSDate?
    var Title:String?
    var Descriptions:String?
    var AllDay:Bool?
    var Start:NSDate?
    var End:NSDate?
    
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        Title = decoder["title"].string
        Descriptions = decoder["description"].string
        let start = decoder["start"].string
        let end = decoder["end"].string
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        
        Start = dateFormatter.dateFromString(start!)
        End = dateFormatter.dateFromString(end!)
    }
    
}


struct Events : JSONJoy {
    var events: Array<Event>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let addrs = decoder.array {
            events = Array<Event>()
            for addrDecoder in addrs {
                events?.append(Event(addrDecoder))
            }
        }
    }
}

struct Author : JSONJoy{
    
    var id : String?
    var name : String?
    var createDate : String?
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        name = decoder["userName"].string
        createDate = decoder["createDate"].string
        
    }
    
}

struct Submit : JSONJoy{
    
    var author: Author?
    
    var imgUrl : String?
    var Url : String?
    var score : Int?
    var type : Int?
    var dienst : String?
    var color : UIColor?
    var id : Int?
    var isFavorite : Bool?
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        imgUrl = decoder["img"].string
        Url = decoder["url"].string
        score = decoder["score"].integer
        type = decoder["type"].integer
        switch type {
        case 0?:
            dienst = "\u{f03e} Image"
            imgUrl = "http://api.chreyt.li/"+imgUrl!
            Url = "http://api.chreyt.li/"+Url!
            color = UIColor.blueColor()
        case 1?:
            dienst = "\u{f16a} YouTube"
            color = UIColor.redColor()
        case 2?:
            dienst = "\u{f1bc} Spotify"
            color = UIColor.greenColor()
        case 3?:
            dienst = "\u{f03e} Video"
            imgUrl = "http://api.chreyt.li/"+imgUrl!
            Url = "http://api.chreyt.li/"+Url!
            color = UIColor.blueColor()
        case 4?:
            dienst = "\u{f281} Reddit"
            color = UIColor.purpleColor()
        case 5?:
            dienst = "\u{f1be} SoundCloud"
            color = UIColor.orangeColor()
        default:
            dienst = "\u{f128} UnKnown"
            color = UIColor.yellowColor()
        }
        author = Author(decoder["author"])
        id = decoder["id"].integer
        isFavorite = decoder["isFavorite"].bool
    }
    
}



struct Submissions : JSONJoy {
    var submit: Array<Submit>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let authors = decoder.array {
            submit = Array<Submit>()
            for authDecoder in authors {
                submit?.append(Submit(authDecoder))
            }
        }
    }
}


struct Tocken : JSONJoy{
    
    var username : String?
    var tokentype : String?
    var accesstoken : String?
    
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        username = decoder["userName"].string
        tokentype = decoder["token_type"].string
        accesstoken = decoder["access_token"].string
    }
    
}
