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
    @IBOutlet weak var favouritesCountLabel: UILabel!
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
            
            retweetbutton.isSelected = tweet.retweeted!
            likebutton.isSelected = tweet.favorited!
            usernameLabel.text = tweet.user?.name
            userscreenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetContentLabel.text = tweet.text
            if tweet.retweetCount! > 1{
                retweetCountLabel.text = "\(tweet.retweetCount!) Retweets"
            }else{
                retweetCountLabel.text = "\(tweet.retweetCount!) Retweet"
            }
            
            if let url = tweet.user?.profileUrl{
                userImage.setImageWith(url)
            }
            
            favouritesCountLabel.text! =  "\(tweet.favorite!) favourites"
            let timestamps = tweet.timestamp
            let calendar = Calendar.current
            
            
            if let timestamp = tweet.timestamp{
                let elapsedTime = Date().timeIntervalSince(timestamp)
                if elapsedTime < 60{
                    timestampLabel.text =  String(Int(elapsedTime)) + "seconds"
                    
                }else if elapsedTime < 3600 {
                    timestampLabel.text = String(Int(elapsedTime / 60)) + "Mins"
                }else if elapsedTime < 24*3600 {
                    timestampLabel.text = String(Int(elapsedTime / 60 / 60)) + "Hour"
                    
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
    
    @IBAction func replaybuttonClick(_ sender: UIButton) {
    }

    @IBAction func retweetButtonClick(_ sender: UIButton) {
        
        TwitterClient.shareInstance?.retweetCreate(isRetweeted: retweetbutton.isSelected,tweetid: tweetid, success: { (retweet:Int) in
            self.retweetCountLabel.text = "\(retweet) Retweets"
        }, failure: { (error:Error) in
            print("retweetButtonClick error : \(error.localizedDescription)")
        })
        self.retweetbutton.isSelected = !self.retweetbutton.isSelected
    }
    @IBAction func onFavoriteButotnClick(_ sender: UIButton) {
        
        if likebutton.isSelected{
            TwitterClient.shareInstance?.detroyFavorite(tweetid: tweetid, success: { (favourite: Int) in
                print("detroyFavorite Success")
               self.favouritesCountLabel.text! = "\(favourite) favourites"
            }, failure: { (error:Error) in
                print("detroyFavorite failure : \(error.localizedDescription)")
            })
        }else{
            
            TwitterClient.shareInstance?.createFavorite(tweetid: tweetid, success: { (favourite: Int) in
                print("createFavorite Success")
                self.favouritesCountLabel.text! = "\(favourite) favourites"
            }, failure: { (error:Error) in
                print("createFavorite failure : \(error.localizedDescription)")
            })
        }
         self.likebutton.isSelected = !self.likebutton.isSelected
    }
}
