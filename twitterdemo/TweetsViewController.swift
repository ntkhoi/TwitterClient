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
   
    @IBOutlet weak var leftLeadingContentView: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!

    @IBOutlet weak var contentView: UIView!
    var orginLeftMargin : CGFloat!
    
    
    var tweets = [Tweet]()
    let refreshControl  = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(self.fetchData), for: UIControlEvents.valueChanged)
        self.tableview.insertSubview(refreshControl, at: 0)
        setupTableView()
        fetchData()
        
        
    }
    
   
    func fetchData(){
        refreshControl.beginRefreshing()
        TwitterClient.shareInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets.removeAll()
            self.tweets.append(contentsOf: tweets)
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error:Error?) in
            print("Request api error: \(error?.localizedDescription)")
            self.refreshControl.endRefreshing()
        }, count: 20)
    }
    
    var isMoreDataLoading = false
    var currentPageCount:Int = 20
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading{
            
            let scrollViewContentHeight = self.tableview.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tableview.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableview.isDragging) {
                isMoreDataLoading = true
                currentPageCount += 20
                refreshControl.beginRefreshing()
                TwitterClient.shareInstance?.homeTimeline(success: { (tweets:[Tweet]) in
                    self.tweets.removeAll()
                    self.tweets.append(contentsOf: tweets)
                    self.tableview.reloadData()
                    self.refreshControl.endRefreshing()
                    self.isMoreDataLoading = false
                    self.refreshControl.endRefreshing()
                }, failure: { (error:Error?) in
                    self.refreshControl.endRefreshing()
                }, count: currentPageCount)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc =  segue.destination as? TweetDetailViewController
        if let vc = vc{
            vc.tweetid = sender as! String
            print("vc.tweetid \(vc.tweetid)")
        }else{
            let vc = segue.destination as! NewTweetViewController
            vc.delegate = self
        }
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
        self.performSegue(withIdentifier: "tweetdetailSegue", sender: tweets[indexPath.row].id)
    }
    
    
}

extension TweetsViewController: NewTweetViewControllerDelegate ,UIScrollViewDelegate{
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, onTweetClick tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        self.tableview.reloadData()
    }
    
   
}


extension TweetsViewController {

    @IBAction func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .began:
            orginLeftMargin = leftLeadingContentView.constant
            break
        case .changed :
            leftLeadingContentView.constant = orginLeftMargin + translation.x
        break
        
        case .ended:
            UIView.animate(withDuration: 0.3, animations:{
                if velocity.x > 0 {
                    
                    if(self.leftLeadingContentView.constant > self.menuView.frame.width/2){
                        self.leftLeadingContentView.constant = self.menuView.frame.width
                    }else{
                        self.leftLeadingContentView.constant = 0
                    }
                    
                }else{
                    self.leftLeadingContentView.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        break
            
        default:
            break
            
        }
        
    }
}





