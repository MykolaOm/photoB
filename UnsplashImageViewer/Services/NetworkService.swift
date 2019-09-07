//
//  NetworkService.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/25/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage
// https://api.unsplash.com/photos/random?count=5&client_id=7d9dc72fb146b796454d691116f046cfac466970ef2ea7af2089e1107543c9a0

class Constants {
    private init(){}
    static let shared = Constants()
    let urlString = "https://api.unsplash.com/photos/"
    
}

class AppUserInfo {
    private init(){}
    static let shared = AppUserInfo()
    
    let accessKey = "7d9dc72fb146b796454d691116f046cfac466970ef2ea7af2089e1107543c9a0"
    let secretKey = "02b5cdc23d9de760b9dd094e15fabe6b6cca165a91a2ddb90a8ce1fa0af6e0f0"
}

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    var requestedItemsNumb: Int = 0
//    let randomRequestParam: String = "random?count="
    
    func getRequest(to url: URL, completion: @escaping ([JsonAdopted])->Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
                if let _ = try? JSON(data: data) {
                    let users = self.parseJson(data: data)
                    completion(users)
                }
        }.resume()
    }
    
    func getImageFromLink(url: URL, completion: @escaping (UIImage) -> Void ) {
        guard let data = try? Data.init(contentsOf: url) else { return }
        if let image = UIImage(data: data) {
            completion(image)
        }
    }
    
    func getInstalink() -> URL? {
        let insta: String = "https://www.instagram.com/"
        guard let link = URL(string: "\(insta)/instaname/") else { return nil }
        return link
    }
    
    func parseJson(data: Data) -> [JsonAdopted] {
        var users: [JsonAdopted] = []
        if let json = try? JSON(data: data) {
            for index in 0..<json.count {
                let imageInfo = ImageInfo(description: json[index]["description"].string ?? "",
                                          location: json[index]["location"].string ?? "",
                                          width: json[index]["width"].int ?? 0,
                                          height: json[index]["height"].int ?? 0,
                                          imageUrl: json[index]["urls"]["thumb"].url ?? nil)
                users.append(UnsplashUser(name: json[index]["user"]["name"].string ?? "",
                                          userName: json[index]["user"]["username"].string ?? "",
                                          userThumb: json[index]["user"]["profile_image"]["large"].url ?? nil,
                                          instaName: json[index]["user"]["instagram_username"].string ?? "",
                                          imageInfo: imageInfo))
                
            }
        }
        return users
    }
}
