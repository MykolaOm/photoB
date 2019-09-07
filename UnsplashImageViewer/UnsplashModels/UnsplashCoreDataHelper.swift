//
//  UnsplashCoreDataHelper.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 9/2/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

class UnsplashCoreDataHelper {
    
    init(){}
    
    private let persistanceManager = PersistanceManager.shared
    var lastSavedCount = 0
    
   private func fillImageEntity(entity: ImagesEntity, dataSource: ImagesEntityDataSource) -> ImagesEntity {
        entity.height = Int16(dataSource.height)
        entity.width = Int16(dataSource.width)
        entity.imageDescription = dataSource.description
        entity.imageURL = dataSource.imageURL
        entity.location = dataSource.location
        entity.image = dataSource.image?.pngData() as NSData?
        return entity
    }
    
    func saveUserData(unsplashUsers: [UnsplashUser]) {
        if lastSavedCount < unsplashUsers.count {
            for index in lastSavedCount..<unsplashUsers.count {
                let userData = UnsplashUserEntity(context: persistanceManager.context)
                let imageData = ImagesEntity(context: persistanceManager.context)
                if isUnique(oldUsers: unsplashUsers, item: unsplashUsers[index],lastSavedCount: lastSavedCount) {
                    let image = fillImageEntity(entity: imageData, dataSource: unsplashUsers[index].imageInfo as ImagesEntityDataSource)
                    fillUserEntity(entity: userData, imagesEntity: image, dataSource: unsplashUsers[index])
                    persistanceManager.save()
                }
            }
            
        }
        lastSavedCount = getData().count
    }
    func getData() -> [UnsplashUser] {//from entity: [UnsplashUserEntity]
        let entity = persistanceManager.fetch(UnsplashUserEntity.self)
        var users = [UnsplashUser]()
        for object in entity {
            guard let objectImageInfo = object.imageInfo, let imageNSData = objectImageInfo.image else { return users }
            guard let image = UIImage(data: Data(referencing: imageNSData )) else { return users }
            var imageInfo = ImageInfo(description: objectImageInfo.imageDescription!,
                                      location: objectImageInfo.location!,
                                      width: Int(objectImageInfo.width),
                                      height: Int(objectImageInfo.height),
                                      imageUrl: objectImageInfo.imageURL!)
            imageInfo.image = image
            let user = UnsplashUser(name: object.name!,
                                    userName: object.userName!,
                                    userThumb: object.userTumb,
                                    instaName: object.instaName!,
                                    imageInfo: imageInfo)
            users.append(user)
        }
        return users
    }
   private func fillUserEntity(entity: UnsplashUserEntity,imagesEntity:ImagesEntity, dataSource: UnsplashUserEntityDataSource) {
        entity.imageInfo = imagesEntity
        entity.userName = dataSource.userName
        entity.name = dataSource.name
        entity.instaName = dataSource.instaName
        entity.userTumb = dataSource.userThumb
        if let image = dataSource.profileImage,
            let data = image.pngData()  {
            let nsData = NSData(data: data)
            entity.profileImage = nsData
        }
//        return entity
    }
   private func isUnique(oldUsers: [UnsplashUser], item : UnsplashUser, lastSavedCount: Int ) -> Bool {
        var isNew = true
        for index in 0..<lastSavedCount {
            if oldUsers[index].imageInfo.imageURL == item.imageInfo.imageURL ,
                oldUsers[index].userThumb == item.userThumb,
                oldUsers[index].userName == item.userName {
                    isNew = false
            }
        }
        return isNew
    }
}
