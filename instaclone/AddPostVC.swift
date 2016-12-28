//
//  AddPostVC.swift
//  instaclone
//
//  Created by Rami Baraka on 17/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var popOverView: UIView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var picToPost: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    var imageSet = false
    var userID: String?
    var posterImageRef: FIRDatabaseReference!
    var userProfileImgURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            self.userID = uid
            posterImageRef = DataService.ds.REF_USERS.child("\(uid)").child("imageURL")
            posterImageRef.observeSingleEvent(of: .value, with:{ (snapshot) in
                if let url = snapshot.value as? String {
                    self.userProfileImgURL = url
                }
            })
        }
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        

        
    }


    @IBAction func saveBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            picToPost.image = image
        } else {
            self.displayError(title: "Image issue", message: "There was an issue with the image you selected. Please select another one", okBtnTxt: "Ok")
        }
        self.imageSet = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            self.displayError(title: "Caption missing", message: "Please enter a caption for your post", okBtnTxt: "Ok")
            return
        }
        guard let img = picToPost.image, self.imageSet == true else {
            self.displayError(title: "Image missing", message: "Please select an image to upload", okBtnTxt: "Ok")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_PICS.child(imUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    self.displayError(title: "Error", message: "Post failed please contact support", okBtnTxt: "Ok")
                } else {
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFireBase(imgURL: url)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func postToFireBase(imgURL: String){

        let post:Dictionary<String, Any> = [
                "caption": self.captionField.text!,
                "imageURL": imgURL,
                "likes": 0,
                "posterID": self.userID!,
                "posterProfileImgURL": self.userProfileImgURL!
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    func displayError(title: String, message:String, okBtnTxt:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtnTxt, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
