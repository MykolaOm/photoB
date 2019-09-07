//
//  UnsplashCell.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/26/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

//class UnsplashCell: UICollectionViewCell, UnsplashConfigurable {
class UnsplashCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    var user: UnsplashUserEntity?
    
//    func configure(with model: UnsplashConfigurator){
    func configure(with model: UnsplashUserEntity){
        self.user = model
        guard let usr = user else { return }
        initiate(from: usr)
    }
    private func initiate(from model: UnsplashUserEntity) {
        author.text = model.name
        imageDescription.text = model.imageInfo?.imageDescription
//        if let imgData = model.imageInfo?.image {
//            let data = Data(imgData)
//            imageView.image = UIImage(data: data)
//        }
    }
}
