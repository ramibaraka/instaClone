//
//  Post.swift
//  instaclone
//
//  Created by Rami Baraka on 20/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import Foundation


class Post {

    private var _caption: String!
    private var _imageURL:String!
    private var _likes:Int!
    private var _postID:String!
    
    init(caption: String, imageURL: String, likes: Int){
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postID: String, postData: Dictionary<String, AnyObject>){
        self._postID = postID
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String{
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
    }
    
    
    var caption:String {
        return _caption
    }
    
    var imageURL:String {
        return _imageURL
    }
    
    var likes:Int {
        return _likes
    }
    
    var postID:String {
        return _postID
    }
    
}
