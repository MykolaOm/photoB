//
//  UnsplashStructs.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/26/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

protocol ImagesEntityDataSource {
    var imageURL: URL? { get set }
    var description: String { get set }
    var location: String { get set }
    var image: UIImage? { get set }
    var width: Int { get set }
    var height: Int { get set }
}
protocol UnsplashUserEntityDataSource {
    var name: String { get set }
    var userName: String { get set }
    var userThumb: URL? { get set }
    var instaName: String { get set }
    var imageInfo : ImageInfo { get set}
    var profileImage: UIImage? { get set }
}

protocol JsonAdopted: UnsplashUserEntityDataSource {

}

struct UnsplashUser: JsonAdopted, UnsplashConfigurator, UnsplashUserEntityDataSource,Equatable {
    static func == (lhs: UnsplashUser, rhs: UnsplashUser) -> Bool {
        if lhs.name == rhs.name,
            lhs.userName == rhs.userName,
            lhs.userThumb == rhs.userThumb,
            lhs.instaName == rhs.instaName {
            return true
        } else {
            return false
        }
    }
    
    var name: String
    var userName: String
    var userThumb: URL?
    var instaName: String
    var imageInfo : ImageInfo
    var profileImage: UIImage?
    
    init(name: String, userName: String, userThumb : URL?, instaName: String, imageInfo: ImageInfo) {
        self.name = name
        self.userName = userName
        self.userThumb = userThumb
        self.instaName = instaName
        self.imageInfo = imageInfo
    }
}

struct ImageInfo: ImagesEntityDataSource {
    var imageURL: URL?
    var description: String
    var location: String
    var form: ImageForm
    var image: UIImage?
    var width: Int
    var height: Int
    init(description: String, location: String, width: Int, height: Int, imageUrl: URL?) {
        self.imageURL = imageUrl
        self.description = description
        self.location = location
        self.height = height
        self.width = width
        self.form = ImageForm.getForm(width: width, height: height)
    }
}

enum ImageForm {
    case tall
    case wide
    case square
    
    static func getForm(width: Int, height: Int) -> ImageForm {
        var form: ImageForm = .square
        if width > height       { form = .wide }
        else if width < height  { form = .tall }
        return form
    }
}
