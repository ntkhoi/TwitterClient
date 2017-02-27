//
//  LoginViewController.swift
//  twitterdemo
//
//  Created by Nguyen Trong Khoi on 2/27/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButon(_ sender: Any) {
        TwitterClient.shareInstance?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error:Error) in
            print("Log in error: \(error.localizedDescription)")
        })
    }
    



}
