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
            userscreenNameLabel.text =  "@\(tweet.user!.screenName!)"
            createdtimeLabel.text = ""
            tweetcontentLabel.text = tweet.text
            if let url = tweet.user?.profileUrl{
                userprofileImage.setImageWith(url)
            }
            
            
            
            if let timestamp = tweet.timestamp{
                let elapsedTime = Date().timeIntervalSince(timestamp)
                if elapsedTime < 60{
                    createdtimeLabel.text =  String(Int(elapsedTime)) + "seconds"

                }else if elapsedTime < 3600 {
                        createdtimeLabel.text = String(Int(elapsedTime / 60)) + "Mins"
                }else if elapsedTime < 24*3600 {
                        createdtimeLabel.text = String(Int(elapsedTime / 60 / 60)) + "Hour"
                    
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
