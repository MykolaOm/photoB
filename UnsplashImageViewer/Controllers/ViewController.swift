//
//  ViewController.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/17/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ImageType {
    case profile
    case picture
}

class ViewController: UICollectionViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var userL: [UnsplashUserEntity] = []
    private var itemsToDownload: Int = 1 // min or max allowed = 10...
    private var selectedIndex: Int = 0
    private let persistanceManager = PersistanceManager.shared
    private let cashe = ImageCache()
    private var coredataHelper = UnsplashCoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        userL = coredataHelper.getData()

        requestData()
    }
   
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged )
        return refresh
    }()

    @objc private func refresh(sender: UIRefreshControl) {
        requestData()
        sender.endRefreshing()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userL.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unsplashCell", for: indexPath) as! UnsplashCell
        cell.configure(with: userL[indexPath.item])
        cell.imageView.image = cashe.getImage(url: userL[indexPath.item].imageInfo!.imageURL!)
        return cell
    }
    
    private func reloadView(){
        if userL.count != 0 {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    private func requestData(){
        guard let url = NetworkService.shared.getUrlForRandomPhotos(count:itemsToDownload) else { return }
        NetworkService.shared.getRequest(to: url, completion: { (result) in
            for item in result {
                let occurances = self.userL.filter{ $0.imageInfo != nil && $0.imageInfo?.imageURL != nil &&  $0.imageInfo?.imageURL == item.imageInfo?.imageURL
                }
                if occurances.count == 0 {
                    self.userL.append(item)
                }
            }
            for index in 0..<self.userL.count {
                let img = self.cashe.getImage(url: (self.userL[index].imageInfo?.imageURL!)!)
                self.userL[index].imageInfo?.image = NSData(data: (img?.pngData())!)
                let userT = self.cashe.getImage(url: self.userL[index].userTumb!)
                self.userL[index].profileImage = NSData(data: (userT?.pngData())!)
            }
            
            self.coredataHelper.saveUserData(unsplashUsers: self.userL)
            self.increaseItemsToDownload()
            self.reloadView()
        })
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
    
    private func getSize(index:Int, correlation: Double) -> CGSize {
        let isLandscape = UIDevice.current.orientation.isLandscape
        let dividerW: CGFloat = isLandscape ? 3.4 : 2.3
        let width = self.view.bounds.width / dividerW
        let height = width * CGFloat(correlation)
        return CGSize(width: width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        reloadView()
        self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let dest = segue.destination as? DetailViewController {
                if sender is UnsplashCell {
                    dest.image = (sender as! UnsplashCell).imageView.image
                    dest.user = (sender as! UnsplashCell).user
                }
            }
        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        requestData()
    }
    
    private func increaseItemsToDownload() {
        //it could work if random count in link had impact on number of downloaded objects
        itemsToDownload += 6
    }
}
    extension ViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let hI = Int(userL[indexPath.item].imageInfo!.height)
            let wI = Int(userL[indexPath.item].imageInfo!.width)
            let correlation: Double = Double(hI) / Double(wI)
            return getSize(index: indexPath.item, correlation: correlation)
        }
}
