//
//  User.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit

var _currentUser: User?
class User{
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    var dictionary: NSDictionary

    
     init(dictionary: NSDictionary) {
        self.dictionary =  dictionary
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as! String

        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if profileUrlString ==  profileUrlString{
            self.profileUrl = URL(string: profileUrlString!)
        }
        self.tagLine = dictionary["description"] as? String
    }
    
//    static var _currentUserAccessToken: String?
//    class var currentUserAccessToken: String?{
//        get{
//            let defaults = UserDefaults.standard
//            _currentUserAccessToken = defaults.string(forKey: "key_currentuser")
//            return _currentUserAccessToken
//        }
//        set(useraccessToken){
//            let defaults = UserDefaults.standard
//            _currentUserAccessToken = useraccessToken
//            defaults.set(_currentUserAccessToken, forKey: "key_currentuser")
//            defaults.synchronize()
//            
//        }
//    }
    
    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.data(forKey: "keycurrentuser")
                if let data = data  {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                let data = try! JSONSerialization.data(withJSONObject: user!.dictionary, options: JSONSerialization.WritingOptions())
                UserDefaults.standard.set(data, forKey: "keycurrentuser")
            } else {
                UserDefaults.standard.set(nil, forKey: "keycurrentuser")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    
}
