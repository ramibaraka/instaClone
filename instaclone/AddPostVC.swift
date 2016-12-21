//
//  AddPostVC.swift
//  instaclone
//
//  Created by Rami Baraka on 17/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import Firebase

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var popOverView: UIView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var picToPost: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    var imageSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        popOverView.layer.cornerRadius = 1

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
            print("Image was not valid")
        }
        self.imageSet = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func postTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            let alert = UIAlertController(title: "Caption missing", message: "Please enter a caption for your post", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let img = picToPost.image, self.imageSet == true else {
            let alert = UIAlertController(title: "Image missing", message: "Please select an image to upload", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_PICS.child(imUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("UPLOAD WAS NOT SUCCSESSFUL")
                } else {
                    print("UPLOAD TO FIREBASE SUCCESSFUL")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFireBase(imgURL: url)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func postToFireBase(imgURL: String){
        let post:Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageURL": imgURL,
            "likes": 0
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
    }
}
