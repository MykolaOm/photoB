//
//  ImageCashe.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 9/1/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

class ImageCache {
    func tryGetImage(url : URL) -> UIImage? {
        var retval: UIImage?
        
        if isCached(url: url) {
            self.cacheGuard.wait()
            retval = self.cache[url]
            self.cacheGuard.signal()
        }
        
        return retval
    }
    
    func getImage(url: URL)-> UIImage? {
        if let retval = self.tryGetImage(url: url) {
            return retval
        }
        
        var retVal: UIImage?
        if let data = try? Data(contentsOf: url) {
            retVal = UIImage(data: data)
            self.cacheGuard.wait()
            self.cache[url] = retVal
            self.cacheGuard.signal()
        }
        
        return retVal
    }
    
    
    private func isCached(url : URL) -> Bool {
        if let _ = self.cache[url] {
            return true
        } else {
            return false
        }
    }
    
    private var cache = Dictionary<URL, UIImage>()
    private var cacheGuard = DispatchSemaphore(value: 1)
}
