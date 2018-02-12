//
//  LightboxViewController.swift
//  SharkFeed
//
//  Created by Portia Sharma on 2/6/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit
import Lightbox

class LightboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var openInAppButton: UIBarButtonItem!
    
    var selectedImageUrl = NSURL()
    
    //setup scrollView parameters
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailScrollView.delegate = self
        detailScrollView.maximumZoomScale = 5.0
        detailScrollView.minimumZoomScale = 1.0
        self.automaticallyAdjustsScrollViewInsets = false
        detailScrollView.contentInset = UIEdgeInsets.zero
        detailScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        detailScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    //bring Image from URL
    override func viewDidAppear(_ animated: Bool) {
        fullImageView.bringImageFromUrl(url: selectedImageUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set view for scroll
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullImageView
    }
    
    //open image in flickr
    @IBAction func openInAppButtonsPressed(_ sender: UIBarButtonItem) {
        UIApplication.shared.openURL(selectedImageUrl as URL)
    }
    
    //save image to camera roll
    @IBAction func downloadButtonsPressed(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(fullImageView.image!, nil, nil, nil)
        let alert = UIAlertController(title: "Saved", message: "This image has been saved to camera roll.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
