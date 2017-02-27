//
//  TweetCell.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userprofileImage: UIImageView!
    
    @IBOutlet weak var tweetcontentLabel: UILabel!
    @IBOutlet weak var createdtimeLabel: UILabel!
    @IBOutlet weak var userscreenNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var tweet:Tweet!{
        didSet{
            usernameLabel.text = tweet.user?.name
            userscreenNameLabel.text =  "@\(tweet.user?.screenName)"
            createdtimeLabel.text = "4h"
            tweetcontentLabel.text = tweet.text
            if let url = tweet.user?.profileUrl{
                userprofileImage.setImageWith(url)
            }
            
            let date = NSDate()
            let calendar = NSCalendar.current
            if let timestamp = tweet.timestamp{
                let hour = calendar.component(.hour, from: timestamp as Date)
                if hour >= 1{
                    createdtimeLabel.text = "\(hour)h"
                }else{
                    let minutes = calendar.component(.minute, from: date as Date)
                    
                    createdtimeLabel.text = "\( minutes)mins"
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
