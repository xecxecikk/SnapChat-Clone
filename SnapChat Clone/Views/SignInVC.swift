//
//  ViewController.swift
//  SnapChat Clone
//
//  Created by XECE on 9.05.2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func signinBttn(_ sender: Any) {
        
        
        
        
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
                
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    } else {
                        
                        UserSingleton.sharedUserInfo.username = self.usernameText.text!
                        
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }

            } else {
                self.makeAlert(title: "Error", message: "Password/Email ?")

            }
            
                }
    
    @IBAction func signupBttn(_ sender: Any) {
    if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                       if error != nil {
                           self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                       } else {
                           UserSingleton.sharedUserInfo.username = self.usernameText.text!
                           
                           
                                             let ref = Database.database().reference()
                                             
                                             // Saving user data to Realtime Database
                                             let userDictionary = [
                                                 "email": self.emailText.text!,
                                                 "username": self.usernameText.text!
                                                 
                                             ] as [String: Any]
                                             
                                             // Add the user info to the "UserInfo" node in Realtime Database
                                             ref.child("UserInfo").childByAutoId().setValue(userDictionary) { (error, ref) in
                                                 if error != nil {
                                                     self.makeAlert(title: "Error", message: "Failed to save user data.")
                                                 }
                                             }
                                             
                                             // After signing up and saving user info, navigate to FeedVC
                                             self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                                         }
                                     }
                                 } else {
                                     self.makeAlert(title: "Error", message: "Username/Password/Email ?")
                                 }
                             }
                             
                             func makeAlert(title: String, message: String) {
                                 let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                                 let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                                 alert.addAction(okButton)
                                 self.present(alert, animated: true, completion: nil)
                             }
                         }
