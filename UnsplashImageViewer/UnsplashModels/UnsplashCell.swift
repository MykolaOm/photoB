//
//  UnsplashCell.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/26/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

class UnsplashCell: UICollectionViewCell, UnsplashConfigurable {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    var user: UnsplashUser?
    
    func configure(with model: UnsplashConfigurator){
        self.user = model as? UnsplashUser
        guard let usr = user else { return }
        initiate(from: usr)
    }
    private func initiate(from model: UnsplashUser) {
        author.text = model.name
        imageDescription.text = model.imageInfo.description
        imageView.image = model.imageInfo.image
    }
}
