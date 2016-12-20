//
//  PostCell.swift
//  instaclone
//
//  Created by Rami Baraka on 18/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit

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

    func configureCell(post: Post){
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
    }
    
}
