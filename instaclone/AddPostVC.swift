//
//  AddPostVC.swift
//  instaclone
//
//  Created by Rami Baraka on 17/12/16.
//  Copyright © 2016 Rami Baraka. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {
    @IBOutlet weak var popOverView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        popOverView.layer.cornerRadius = 1

    }


    @IBAction func saveBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
