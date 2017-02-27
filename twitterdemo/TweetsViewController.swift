//
//  TweetsViewController.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
   

    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        
        
        TwitterClient.shareInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets.append(contentsOf: tweets)
            self.tableview.reloadData()
            for tweet in tweets{
                print(tweet.text!)
            }
        }, failure: { (error:Error?) in
            print("Request api error: \(error?.localizedDescription)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView(){
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        self.tableview.estimatedRowHeight = 110
    }
    

}

extension TweetsViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "tweetdetailSegue", sender: nil)
    }
    
    
}






