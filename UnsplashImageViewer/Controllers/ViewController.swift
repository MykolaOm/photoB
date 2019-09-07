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
    private let user: [UnsplashUserEntity] = []
    private var itemsToDownload: Int = 1 // min or max allowed = 10...
    private var unsplashUsers : [UnsplashUser] = []
    private var selectedIndex: Int = 0
    private let persistanceManager = PersistanceManager.shared
    private let cashe = ImageCache()
    private var coredataHelper = UnsplashCoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        unsplashUsers = coredataHelper.getData()
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
        return unsplashUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unsplashCell", for: indexPath) as! UnsplashCell
        cell.configure(with: unsplashUsers[indexPath.item])
        return cell
    }
    
    private func reloadView(){
        if unsplashUsers.count != 0 {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    // TODO: remove from VC to separate module
    private func requestData(){
        var urlComp = URLComponents(string: Constants.shared.urlString)
        urlComp?.queryItems = [
            URLQueryItem(name: "random count", value: String(itemsToDownload)),
            URLQueryItem(name: "client_id", value: AppUserInfo.shared.accessKey)
        ]
        guard let url = urlComp?.url else { return }
        NetworkService.shared.getRequest(to: url, completion: { (result) in
            for item in result {
                let occurances = self.unsplashUsers.filter{ $0.imageInfo.imageURL == item.imageInfo.imageURL }
                if occurances.count == 0 {
                    self.unsplashUsers.append(item as! UnsplashUser)
                }
            }
            for index in 0..<self.unsplashUsers.count {
                self.singleImage(type: .picture, index: index, url: self.unsplashUsers[index].imageInfo.imageURL!)
                self.singleImage(type: .profile, index: index, url: self.unsplashUsers[index].userThumb!)
            }
            self.coredataHelper.saveUserData(unsplashUsers: self.unsplashUsers)
            self.increaseItemsToDownload()
            self.reloadView()
        })
    }
    // TODO: remove from VC to separate module
    private func singleImage(type: ImageType, index: Int, url: URL ){
        let image = cashe.getImage(url: url)
        switch type {
            case .picture:  self.unsplashUsers[index].imageInfo.image = image
            case .profile:  self.unsplashUsers[index].profileImage = image
        }
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
            let correlation: Double = Double(unsplashUsers[indexPath.item].imageInfo.height) / Double(
                unsplashUsers[indexPath.item].imageInfo.width)
            return getSize(index: indexPath.item, correlation: correlation)
        }
}
