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
    
    func saveUserData(unsplashUsers: [UnsplashUserEntity]) {
        if lastSavedCount < unsplashUsers.count {
                persistanceManager.save()
            }
        lastSavedCount = getData().count
    }
    func getData() -> [UnsplashUserEntity] {//from entity: [UnsplashUserEntity]
        return persistanceManager.fetch(UnsplashUserEntity.self)
    }
    
}
