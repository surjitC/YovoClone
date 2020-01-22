//
//  ImageDownloader.swift
//  Yovo Clone
//
//  Created by Surjit on 21/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {

    // MARK: - Constants
    static let sharedInstance = ImageDownloader()

    typealias DownloadComplete = ((UIImage, IndexPath) -> Void)


    func downloadImageFrom(urlString: String, indexPath: IndexPath, completionHandler: @escaping DownloadComplete) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, indexPath: indexPath) { (image, indexPath) in
            completionHandler(image, indexPath
            )
        }
    }

    func downloadImageFrom(url: URL, indexPath: IndexPath, completionHandler: @escaping DownloadComplete) {

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                    if let image = UIImage(data: data) {
                        completionHandler(image, indexPath)

                }
            }.resume()
    }
}
