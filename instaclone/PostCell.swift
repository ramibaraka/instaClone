//
//  PostCell.swift
//  instaclone
//
//  Created by Rami Baraka on 18/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Kingfisher


class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postIMG: UIImageView!
    @IBOutlet weak var likeImg: UILabel!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var posterImageRef: FIRDatabaseReference!
    var userNameRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        profileIMG.layer.cornerRadius = 7
        profileIMG.clipsToBounds = true
        
    }

    func configureCell(post: Post){
        self.postIMG.image = UIImage(named: "logo")
        //self.profileIMG.image = UIImage(named: "logo")
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postID)
        userNameRef = DataService.ds.REF_USERS.child("\(post.posterID)").child("username")
        
        let url = URL(string: post.imageURL)
        self.postIMG.kf.setImage(with: url,
                                 placeholder: UIImage(named: "logo"),
            options: [.transition(.fade(1))],
            progressBlock: nil,
            completionHandler: nil)
        
        userNameRef.observeSingleEvent(of: .value, with:{ (snapshot) in
            if let username = snapshot.value as? NSString {
                self.userNameLbl.text = username as String
            } else {
                //Handle fail
            }
        })
        
        
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
                self.likesRef.setValue(true)
                self.likeImg.text = "Unlike"
                self.post.adjustLikes(addLike: true)
            } else {
                self.likesRef.removeValue()
                self.likeImg.text = "Like"
                self.post.adjustLikes(addLike: false)
            }
        })
    }
    
    
    

}
