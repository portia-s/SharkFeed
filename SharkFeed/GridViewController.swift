//
//  GridViewController.swift
//  SharkFeed
//
//  Created by Portia Sharma on 2/6/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "gridCell"
private let refreshControl = UIRefreshControl()

class GridViewController: UICollectionViewController, PhotoSearchDelegate, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    //sets border around collectionView
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    //passed onto DetailVC for full image
    var selectedIndex = Int()
    
    //instance to access model for URLSessin & JSON Parsing
    var vcModel = PhotoSearchModel()
    
    //var customRefreshControlView: UIView!
    var hook: UIImageView!
    var fish: UIImageView!
    var refreshMessage : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setting self collectionView's datasource and delegate
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        //setting self to be model's delegate
        vcModel.delegate = self
        
        //initialize arrays and bring the imageURLs
        vcModel.imageUrls = [String]()
        vcModel.fullImageUrls = [String]()
        vcModel.flickrImageSearchAPI(offset: vcModel.imageUrls.count)
        
        //setting up refresh control
        if #available(iOS 10.0, *) {
            imageCollectionView.refreshControl = refreshControl
        } else {
            imageCollectionView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
        loadCustomRefreshControlContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcModel.imageUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {    
        // Configure the cell
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridVCCell
        DispatchQueue.main.async {
            myCell.gridCellImageView.bringImageFromUrl(url: NSURL(string: self.vcModel.imageUrls[indexPath.row]))
        }
        //reFetch next set of urls as collectionView usesup* current set of images
        if vcModel.imageUrls.count - 1 <= indexPath.row {
            vcModel.flickrImageSearchAPI(offset: vcModel.imageUrls.count)
        }
        return myCell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetailView", sender: self)
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow = CGFloat(3)
        let pads = sectionInsets.left * (numberOfCellsPerRow + 1)
        let totalwidth = collectionView.frame.width - pads
        let dimensions = floor((totalwidth / numberOfCellsPerRow))
        return CGSize(width: dimensions, height: dimensions)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let nextVC = segue.destination as! LightboxViewController
            nextVC.selectedImageUrl = NSURL(string: vcModel.fullImageUrls[selectedIndex])!
        }
    }

    // MARK: - Helper functions
    
    func updateCollectionView() {
        DispatchQueue.main.async(execute: {
            self.imageCollectionView.reloadData()
        })
    }
    
    @objc private func refreshData(sender: Any) {
            DispatchQueue.main.async {
                self.updateCollectionView()
                refreshControl.endRefreshing()
            }
    }
    
    func loadCustomRefreshControlContents() {
        
        let refreshContents = Bundle.main.loadNibNamed("CustomRefreshControlView", owner: self, options: nil)
        var customView =  refreshContents![0] as! UIView
        customView.frame = refreshControl.bounds
        refreshControl.addSubview(customView)
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        updateCollectionView()
    }
    
    
    
}
