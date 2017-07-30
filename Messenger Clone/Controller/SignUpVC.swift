//
//  SignUpVC.swift
//  Messenger Clone
//
//  Created by Myke on 30/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var userUid : String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
    }

    override func viewDidDisappear(_ animated: Bool) {
    
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessagesVC", sender: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            userImagePicker.image = image
            
            imageSelected = true
            
        }else{
            
            print("Image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUpUser(img: String) {
        
        let userData = ["username": username!, "userImg": img]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImg() {
        
        if usernameField.text == nil {
            
            signUpBtn.isEnabled = false
            
        }else{
            
            username = usernameField.text
            signUpBtn.isEnabled = true
        }
        
        guard let img = userImagePicker.image, imageSelected == true else {
            
            print("Image needs to be selected")
            
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata)
            { (metadata, error) in
                
                if error != nil {
                    print("did not upload image")
                }else{
                    print("uploaded")
                    
                    let dowloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    if let url = dowloadUrl {
                        self.setUpUser(img: url)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user, error) in
            
            if error != nil {
                print("cannot create user")
            }else{
                if let user = user {
                    self.userUid = user.uid
                }
            }
            
            self.uploadImg()
        })
    }
    
    @IBAction func selectedImgPicker(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}








