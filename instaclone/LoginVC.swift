//
//  ViewController.swift
//  instaclone
//
//  Created by Rami Baraka on 14/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        changeStatusBarColor()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.displayError(title: "Account creation failed error", message: "There was a problem with creating an account. Please contact support", okBtnTxt: "Ok")
                        } else {
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
        }
        
    }
    
    @IBAction func fbLoginPressed(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                self.displayError(title: "Facebook login failed", message: "There was a problem with the facebook login. Please contact support", okBtnTxt: "Ok")
            } else if result?.isCancelled == true {
                print("user canceled")
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credential)
            }
        }
    }
    
    
    func fireBaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error ) in
            if error != nil {
                self.displayError(title: "Authentication error", message: "There was a problem with the authentication. Please contact support", okBtnTxt: "Ok")
            } else {
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    
    func changeStatusBarColor(){
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor(red: 19.0/255, green: 19.0/255, blue: 19.0/255, alpha: 1.0)
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFireBaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "goToConfig", sender: nil)
        }

    }
    
    func displayError(title: String, message:String, okBtnTxt:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtnTxt, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


