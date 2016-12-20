//
//  AddPostVC.swift
//  instaclone
//
//  Created by Rami Baraka on 17/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var popOverView: UIView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var picToPost: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    
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
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func postTapped(_ sender: Any) {
    }
}
