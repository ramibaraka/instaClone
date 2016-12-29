//
//  FeedVC.swift
//  instaclone
//
//  Created by Rami Baraka on 16/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var posterImageRef: FIRDatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.estimatedRowHeight = 180.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(FeedVC.loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        changeStatusBarColor()
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts.removeAll()
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postID: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadList(notification: NSNotification){
        posts.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
              
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: true, completion: {})
            })
            
    }
    
    func changeStatusBarColor(){
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor(red: 24.0/255, green: 24.0/255, blue: 24.0/255, alpha: 1.0)
    }
   
    @IBAction func addPostPressed(_ sender: Any) {
        performSegue(withIdentifier: "AddPost", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.posts[indexPath.row]
        
        posterImageRef = DataService.ds.REF_USERS.child("\(post.posterID)").child("imageURL")
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.tag = indexPath.row

            let url = URL(string: post.posterImgUrl)
            cell.profileIMG.kf.setImage(with: url)

            cell.configureCell(post: post)
            cell.setNeedsLayout()
            return cell
        } else {
            return PostCell()
        }
    }
    

 
    
}
