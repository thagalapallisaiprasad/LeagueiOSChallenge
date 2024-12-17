//
//  DownloadImage.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import UIKit

class ImageDownloader {
  
  static func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
    guard let imageUrl = URL(string: url) else {
      completion(nil)
      return
    }
    
    let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
      if let error = error {
        print("Error downloading image: \(error.localizedDescription)")
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      guard let data = data, let image = UIImage(data: data) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      DispatchQueue.main.async {
        completion(image)
      }
    }
    
    task.resume()
  }
}
