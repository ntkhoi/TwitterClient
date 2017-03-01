//
//  TwitterClient.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let shareInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "yllhZ2fmytsEI0xaZ3Hlq6OZQ", consumerSecret: "fzVwZmTlvPVMfxuhECyyNilrogxLZqilUaCwxC8HVjegdhMwbV")
    
    
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error)->())?
    
    func login(success:@escaping ()->(), failure :@escaping (Error)->()){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "codeschooltwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            
            print( "Request Token : \(requestToken!.token)")
            UIApplication.shared.open(url!, options: ["": AnyObject.self ], completionHandler: nil)
            
        }, failure: { (error: Error?) in
            print("i got error : \(error?.localizedDescription)")
        })
    }
    
    
    func currentAccount(susscess:@escaping (User) ->() , failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask,response: Any?) in
            let dictionary = response as! NSDictionary
            let user = User(dictionary: dictionary)
            susscess(user)
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            failure(error)
        })
        
        
    }
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> () , failure: @escaping (Error?) -> () , count : Int ){
        
        
        get("1.1/statuses/home_timeline.json", parameters: ["count":"\(count)"], progress: nil, success: { (task:URLSessionDataTask,response: Any?) in
            print("Get home data success")
            let dictionarys = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionarys: dictionarys)
            
            success(tweets)
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL? ){
        
        let defaults = UserDefaults.standard
        var requestToken: BDBOAuth1Credential
        if let url = url{
            defaults.set(url.query, forKey: "key_urlquery")
            defaults.synchronize()
            requestToken = BDBOAuth1Credential(queryString: url.query)
            
        }else{
            var queryUrl =  defaults.string(forKey: "key_urlquery")
              requestToken = BDBOAuth1Credential(queryString: queryUrl)
        }
        
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            self.currentAccount(susscess: { (user:User) in
                
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error:Error) in
                self.loginFailure?(error)
            })
            
            
        }, failure: { (error:Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func tweetshowDetails(id: String , success: @escaping (Tweet)->() , failure: @escaping (Error) ->()) {
        get("1.1/statuses/show.json", parameters: ["id":id], progress: nil, success: { (task:URLSessionDataTask,response: Any?) in
            print("Get tweetshowDetails data success")
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task:URLSessionDataTask?,error: Error) in
            failure(error)
        })
        
    }
    
    
    func poststatusTweet(status: String ,success:@escaping (Tweet)->(),  failure: @escaping(Error) ->() ){
//        1.1/statuses/update.json
        post("1.1/statuses/update.json", parameters: ["status":status], progress: nil,success: { (task:URLSessionDataTask,response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            print("poststatusTweet error : \(error.localizedDescription)")
            failure(error)
            
        })
    }
    
    func createFavorite(tweetid: String ,success:@escaping (Int)->(),  failure: @escaping(Error) ->() ){
        //        1.1/statuses/update.json
        post("1.1/favorites/create.json", parameters: ["id":tweetid], progress: nil,success: { (task:URLSessionDataTask,response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet.favorite! )
            
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            print("poststatusTweet error : \(error.localizedDescription)")
            failure(error)
            
        })
    }
    
    func detroyFavorite(tweetid: String ,success:@escaping (Int)->(),  failure: @escaping(Error) ->() ){
        //        1.1/statuses/update.json
        post("1.1/favorites/destroy.json", parameters: ["id":tweetid], progress: nil,success: { (task:URLSessionDataTask,response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet.favorite!)
            
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            print("poststatusTweet error : \(error.localizedDescription)")
            failure(error)
            
        })
    }
    
    
    func retweetCreate(isRetweeted: Bool, tweetid: String , success: @escaping (Int)->() , failure: @escaping(Error)->() ){
        
        if(isRetweeted){
            post("1.1/statuses/unretweet/\(tweetid).json", parameters: nil, progress: nil,success: { (task:URLSessionDataTask,response: Any?) in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet.retweetCount!)
            }, failure: { (task:URLSessionDataTask?,error: Error) in
                print("retweetCreate error : \(error.localizedDescription)")
                
            })
            
        }else{
            post("1.1/statuses/retweet/\(tweetid).json", parameters: nil, progress: nil,success: { (task:URLSessionDataTask,response: Any?) in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet.retweetCount!)
            }, failure: { (task:URLSessionDataTask?,error: Error) in
                print("retweetCreate error : \(error.localizedDescription)")
                
            })
        }
    }
    
    
}
