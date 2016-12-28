//
//  UserConfigVC.swift
//  instaclone
//
//  Created by Rami Baraka on 22/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserConfigVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var profileIMG: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var imageSet = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        


    }


    @IBAction func profileIMGTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileIMG.image = image
            profileIMG.layer.cornerRadius = 100
            self.imageSet = true
            imagePicker.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Image issue", message: "Please try another photo", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            imagePicker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    @IBAction func continueTapped(_ sender: Any) {
        
        guard let username = userNameField.text, username != "" else{
            let alert = UIAlertController(title: "Username", message: "Please pick a username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let img = profileIMG.image, self.imageSet == true else {
            let alert = UIAlertController(title: "Image missing", message: "Please select profile photo", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_PICS.child(imUid).put(imgData, metadata: metaData) {
                (metaData, error) in
                if error != nil {
                    print("Profile image upload FAILED")
                } else {
                    print("Profile image uploaded successfuly")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.updateUserInFirebase(imgURL: url, username: username)
                        KeychainWrapper.standard.set(url, forKey: PROFILE_IMG_URL)
                    }
                    self.performSegue(withIdentifier: "toFeedFromUserConfig", sender: nil)
                }
            }
        }
    }
    
    func updateUserInFirebase(imgURL: String, username: String){
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            let post:Dictionary<String, Any> = [
                "imageURL": imgURL,
                "username": username
            ]
            let firebasePost = DataService.ds.REF_USERS.child(uid)
            firebasePost.updateChildValues(post)
            
        }
    }
    
    
}
