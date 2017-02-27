//
//  Tweet.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit

class Tweet {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int?
    var favorite: Int?
    var user: User?

    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favorite = dictionary["favourites_count"] as? Int ?? 0
        
        let timestampString = dictionary["created_at"] as? String
       
        if let timestampString = timestampString{
            let fommater = DateFormatter()
            fommater.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = fommater.date(from: timestampString)
        }
        
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary{
            self.user = User(dictionary: userDictionary)
            print("User of tweet : \(self.user?.name)")
        }
        
    }
    
    class func  tweetsWithArray(dictionarys: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionarys{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
