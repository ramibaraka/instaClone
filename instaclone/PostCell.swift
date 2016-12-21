//
//  PostCell.swift
//  instaclone
//
//  Created by Rami Baraka on 18/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postIMG: UIImageView!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postIMG.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:{(data, error) in
                    if error != nil {
                        print("UNABLE TO DOWNLOAD IMAGE FROM FIREBASE STORAGE")
                    } else {
                        print("IMAGE DOWNLOADED FROM FIREBASE STORAGE")
                        if let imageData = data {
                            if let img = UIImage(data: imageData){
                                self.postIMG.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
                })
            }
    }
        
    
    
    
    
}
