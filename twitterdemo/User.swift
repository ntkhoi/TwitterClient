//
//  User.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit

class User{
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    
     init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String

        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if profileUrlString ==  profileUrlString{
            self.profileUrl = URL(string: profileUrlString!)
        }
        self.tagLine = dictionary["description"] as? String
    }
    
}
