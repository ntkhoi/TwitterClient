//
//  TweetDetailViewController.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/28/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import AFNetworking
class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userscreenNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweetbutton: UIButton!
    
    @IBOutlet weak var relaybutton: UIButton!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    var tweetid: String = ""
    var tweet: Tweet! {
        didSet{
            usernameLabel.text = tweet.user?.name
            userscreenNameLabel.text = "@\(tweet.user?.screenName)"
            tweetContentLabel.text = tweet.text
            if tweet.retweetCount! > 1{
                retweetCountLabel.text = "\(tweet.retweetCount!) Retweets"
            }else{
                retweetCountLabel.text = "\(tweet.retweetCount!) Retweet"
            }
            
            if let url = tweet.user?.profileUrl{
                userImage.setImageWith(url)
            }
            
            let timestamps = tweet.timestamp
            let calendar = Calendar.current
            if let timestamps = timestamps{
                let hour: Int = calendar.component(.hour, from: timestamps)
                if hour >= 1{
                    timestampLabel.text = "\(hour)h"
                }
                else{
                     let minutes: Int = calendar.component(.minute, from: timestamps)
                    timestampLabel.text = "\(minutes) mins"

                }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.shareInstance?.tweetshowDetails(id: tweetid, success: { (tweet: Tweet) in
            self.tweet = tweet
        }, failure: { (error:Error) in
            print("False")
        })

    }
    @IBAction func onClickLikeButton(_ sender: UIButton) {
    }

}
