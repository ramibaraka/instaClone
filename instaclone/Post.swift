//
//  Post.swift
//  instaclone
//
//  Created by Rami Baraka on 20/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import Foundation
import Firebase

class Post {

    private var _caption: String!
    private var _imageURL:String!
    private var _likes:Int!
    private var _postID:String!
    private var _postRef: FIRDatabaseReference!
    private var _posterID:String!
    private var _posterImgUrl: String!
    
    init(caption: String, imageURL: String, likes: Int, posterID:String, posterImgUrl:String){
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
        self._posterID = posterID
        self._posterImgUrl = posterImgUrl
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
        if let posterID = postData["posterID"] as? String {
            self._posterID = posterID
        }
        
        if let posterImgUrl = postData["posterProfileImgURL"] as? String {
            self._posterImgUrl = posterImgUrl
        }
        _postRef = DataService.ds.REF_POSTS.child(_postID)
        
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
    
    var posterID:String{
        return _posterID
    }
    
    var posterImgUrl: String{
        return _posterImgUrl
    }
    
    
    func adjustLikes(addLike:Bool){
        if addLike {
            _likes = likes + 1
        } else {
            _likes = likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
}
