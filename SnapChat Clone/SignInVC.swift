//
//  ViewController.swift
//  SnapChat Clone
//
//  Created by XECE on 9.05.2025.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func signinBttn(_ sender: Any) {
    }
    
    @IBOutlet weak var signupBttn: NSLayoutConstraint!
}

