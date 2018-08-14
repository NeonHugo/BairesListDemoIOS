//
//  File.swift
//  BairesListDemoIOS
//
//  Created by NeoNHugo on 8/14/18.
//  Copyright © 2018 NeoNHugo. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)

        // set initial image to nil so it doesn't use the image from a reused cell
        image = nil

        // check if the image is already in the cache
        if let imageToCache = imageCache.object(forKey: imgURL! as NSString) {
            self.image = imageToCache
            return
        }

        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                // create UIImage
                let imageToCache = UIImage(data: data!)
                // add image to cache
                imageCache.setObject(imageToCache!, forKey: imgURL! as NSString)
                self.image = imageToCache
            }
        }
        task.resume()
    }
}




