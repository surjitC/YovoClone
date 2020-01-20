//
//  FeedViewModel.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    internal var posts: [Post] = []
    
    func parseJson() {
        if let path = Bundle.main.path(forResource: "feed", ofType: "json") {
            var data = Data()
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch let error {
                // handle error
                debugPrint("Error reading json file", error)
            }
            do {
                let decoder = JSONDecoder()
                
                let feed = try decoder.decode(Feed.self, from: data)
                if let posts = feed.posts {
                    self.posts = posts
                }
                
            } catch let err {
                // handle error
                debugPrint("Error creating json object", err)
            }
        }
    }
    
    func downloadImage(from url: String, at indexPath: IndexPath, completionHandler: @escaping ((Data?, IndexPath) -> Void)) {
        
        //create the url with NSURL
        let dataURL = URL(string: url)! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        let task = session.dataTask(with: dataURL, completionHandler: { data, response, error in

            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let data = data, error == nil else {
                completionHandler(nil, indexPath)
                return
            }
            completionHandler(data, indexPath)
        })

        task.resume()
        
    }
}
