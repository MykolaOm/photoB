//
//  ImagesEntity+CoreDataProperties.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/31/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//
//

import Foundation
import CoreData


extension ImagesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagesEntity> {
        return NSFetchRequest<ImagesEntity>(entityName: "ImagesEntity")
    }

    @NSManaged public var imageURL: URL?
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var image: NSData?
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var unsplashUser: UnsplashUserEntity?

}
