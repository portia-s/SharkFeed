//
//  LaunchViewController.swift
//  SharkFeed
//
//  Created by Portia Sharma on 2/6/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(gesture:)))
        leftSwipeRecognizer.direction = .left
        leftSwipeRecognizer.delegate = self
        self.view.addGestureRecognizer(leftSwipeRecognizer)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func swipeLeft(gesture : UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "swipedToGrid", sender: self)
    }
    
}

