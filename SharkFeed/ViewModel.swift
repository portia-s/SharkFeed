//
//  ViewModel.swift
//  SharkFeed
//
//  Created by Portia Sharma on 2/6/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import Foundation


import Foundation
import UIKit

// MARK: Extension

extension UIImageView {
    
    //add&manage activity indicator; fetch image for given url
    func bringImageFromUrl(url: NSURL?) {
        
        //setup activity indicator
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame.size.width = 50
        activityIndicatorView.frame.size.height = 50
        activityIndicatorView.center = self.center
        activityIndicatorView.isHidden = false
        activityIndicatorView.color = UIColor.darkGray
        
        addSubview(activityIndicatorView)
        bringSubview(toFront: activityIndicatorView)
        
        //start animating
        activityIndicatorView.startAnimating()
        
        //fetch image, stop animation & remove indicator //NSURLSession
        let request = URLRequest(
            url: url! as URL,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url! as URL)
                {
                    self.image = UIImage(data: data)
                    activityIndicatorView.isHidden = true
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                }
                else {
                    self.contentMode = UIViewContentMode.scaleAspectFit
                    self.image = UIImage(named: "notfound.png")
                    activityIndicatorView.isHidden = true
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                }
            }
        }).resume()
        
    }

}
