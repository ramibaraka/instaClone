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
    @IBOutlet weak var likeImg: UILabel!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postID)
        
        if img != nil {
            self.postIMG.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion:{(data, error) in
                    if error != nil {
                        print("UNABLE TO DOWNLOAD IMAGE FROM FIREBASE STORAGE")
                    } else {
                        if let imageData = data {
                            if let img = UIImage(data: imageData){
                                self.postIMG.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
                })
            }
        likesRef.observeSingleEvent(of: .value, with:{ (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.text = "Like"
            } else {
                self.likeImg.text = "Unlike"
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        likesRef.observeSingleEvent(of: .value, with:{ (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.text = "Unlike"
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.text = "Like"
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    

}
