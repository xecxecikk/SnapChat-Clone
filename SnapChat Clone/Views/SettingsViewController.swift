//
//  SettingsViewController.swift
//  SnapChat Clone
//
//  Created by XECE on 12.05.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    
    
    
    @IBAction func logoutBttn(_ sender: Any) {
        
        print("LOGOUT butonuna basıldı")

        do {
                   try Auth.auth().signOut()
                   clearUserSession()
                   performSegue(withIdentifier: "toSignInVC", sender: nil)
               } catch let signOutError as NSError {
                   showAlert(title: "Sign Out Error", message: signOutError.localizedDescription)
               }
           }

           private func clearUserSession() {
               UserSingleton.sharedUserInfo.email = ""
               UserSingleton.sharedUserInfo.username = ""
           }

           private func showAlert(title: String, message: String) {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               present(alert, animated: true)
           }
       }
