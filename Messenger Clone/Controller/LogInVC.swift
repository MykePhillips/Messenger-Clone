//
//  ViewController.swift
//  Messenger Clone
//
//  Created by Myke on 30/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogInVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            
            performSegue(withIdentifier: "toMessagesVC", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUpVC" {
            
            if let destination = segue.destination as? SignUpVC {
            
            if self.userUid != nil {
                
                destination.userUid = userUid
            }
                
                if self.emailField.text != nil {
                    
                    destination.emailField = emailField.text
                }
                
                if self.passwordField.text != nil {
                    
                    destination.passwordField = passwordField.text
                    
                }
                
            }
        }
    }
    
    @IBAction func SignInAction(_ sender: Any) {
        
        if let email = emailField.text , let password = passwordField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion:
                { (user, error) in
                    if error == nil {
                        self.userUid = user?.uid
                        
                        KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                        self.performSegue(withIdentifier: "toMessagesVc", sender: nil)
                    }else{
                        self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                    }
            })
        }
    }
    
}

