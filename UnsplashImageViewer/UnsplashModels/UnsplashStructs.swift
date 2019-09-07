//
//  UnsplashStructs.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/26/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit

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
