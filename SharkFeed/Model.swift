//
//  Model.swift
//  SharkFeed
//
//  Created by Portia Sharma on 2/6/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import Foundation

//Delegate GridViewController to update the collectionView when imageurls have finished downloading
protocol PhotoSearchDelegate: class {
    func updateCollectionView()
}


class PhotoSearchModel {
    
    // arrays to store imageUrls: thumbnails & full
    var imageUrls = [String]()
    var fullImageUrls = [String]()
    
    weak var delegate : PhotoSearchDelegate?
    
    //ImageSearch NSURLSession
    func flickrImageSearchAPI(offset: Int) {
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e98778755d1982f537d56236bbb42&text=shark&format=json&nojsoncallback=1&page=1&extras%20=url_t,url_c,url_l,url_o")!
        let request = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
        let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main)
            
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let requestError = error {
                    print(requestError.localizedDescription)
                }
                else {
                    if data != nil {
                        self.extractDataFromResponse(data: data!)
                    }
                }
            })
            task.resume()
        //}
    }
    
    //Parsing JSON to extract the urls and delegate ViewController to update collectionView
    func extractDataFromResponse(data: Data) {
        if let itemDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary  {
            if let photos = itemDictionary["photos"] as? NSDictionary {
                if let photo = photos["photo"] as? [NSDictionary] {
                    var urlBase = ""
                    for photo in photo {
                        if let farm = photo["farm"] as? Int {
                            urlBase = "https://farm\(farm)"
                        }
                        if let server = photo["server"] as? String {
                            urlBase = urlBase + ".staticflickr.com/" + server
                        }
                        if let id = photo["id"] as? String {
                            urlBase = urlBase + "/" + id
                        }
                        if let secret = photo["secret"] as? String {
                            urlBase = urlBase + "_" + secret
                        }
                        let thumbnailUrl = urlBase + "_t.jpg"
                        imageUrls.append(thumbnailUrl)
                        let originalUrl = urlBase + "_z.jpg" //try b or c
                        fullImageUrls.append(originalUrl)
                    }
                }
            }
            delegate?.updateCollectionView()
        }
    }
        
}
