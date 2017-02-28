//
//  NewTweetViewController.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/28/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import AFNetworking

protocol NewTweetViewControllerDelegate {
//      func switchCell(switchCell: SwitchCell , didChangeValue value: Bool)
    func newTweetViewController( newTweetViewController: NewTweetViewController ,onTweetClick tweet: Tweet )
}

class NewTweetViewController: UIViewController  {
   
    var delegate : NewTweetViewControllerDelegate!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userscreenNameLabel: UILabel!
     @IBOutlet weak var tweetButton: UIButton!

    @IBOutlet weak var composeTweetTextfield: UITextField!
    var user: User!{
        didSet{
            if let url = user.profileUrl{
                userImage.setImageWith(url)
            }
            usernameLabel.text = user.name
            userscreenNameLabel.text = user.screenName
        }
    }
  
   
    override func viewDidLoad() {
        tweetButton.isEnabled = false
        
        TwitterClient.shareInstance?.currentAccount(susscess: { (user: User) in
            self.user = user
            
        }, failure: { (error: Error) in
            print("TwitterClient.shareInstance?.currentAccount : \(error.localizedDescription)")
        })
        super.viewDidLoad()
    }
    
    @IBAction func onTweetClick(_ sender: UIButton) {
        TwitterClient.shareInstance?.poststatusTweet(status: composeTweetTextfield.text!, success: { (tweet:Tweet) in
            
            
            if let navController = self.navigationController {
                self.delegate.newTweetViewController(newTweetViewController: self, onTweetClick: tweet)
                navController.popViewController(animated: true)

            }

        }, failure: { (error:Error) in
            print("post status error : \(error.localizedDescription)")
        })
    }
    
    @IBAction func onEditingChanged(_ sender: UITextField) {
        if(sender.text == ""){
            tweetButton.isEnabled = false
        }
        else{
            tweetButton.isEnabled = true
        }
    }
    
    
}
