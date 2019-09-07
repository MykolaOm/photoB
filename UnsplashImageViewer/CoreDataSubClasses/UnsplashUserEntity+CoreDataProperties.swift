//
//  UnsplashUserEntity+CoreDataProperties.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/31/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//
//

import Foundation
import CoreData


extension UnsplashUserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnsplashUserEntity> {
        return NSFetchRequest<UnsplashUserEntity>(entityName: "UnsplashUserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var userName: String?
    @NSManaged public var userTumb: URL?
    @NSManaged public var instaName: String?
    @NSManaged public var profileImage: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var imageInfo: ImagesEntity?

}
