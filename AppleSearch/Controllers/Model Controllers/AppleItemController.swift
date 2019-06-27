//
//  AppleItemController.swift
//  AppleSearch
//
//  Created by Timothy Rosenvall on 6/27/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class AppleItemController {
    
    static let baseURL = URL(string: "https://itunes.apple.com")
    
    static func fetchAppleItemFor(term: String, completion: @escaping([AppleItem]?) -> Void) {
        guard var url = baseURL else {completion(nil); return}
        
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let searchTermQuery = URLQueryItem(name: "term", value: term)
        let mediaQuery = URLQueryItem(name: "media", value: "music")
        
        components?.queryItems = [searchTermQuery, mediaQuery]
        
        guard let finalURL = components?.url else {completion(nil); return}
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil); return
            }
            
            guard let data = data else {completion(nil); return}
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(TopLevelJSON.self, from: data)
                
                completion(topLevelJSON.results); return
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchImageFor(appleItem: AppleItem, completion: @escaping (UIImage?) -> Void) {
        let baseURL = appleItem.imageURL
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil); return
            }
            if let data = data {
                let image = UIImage(data: data)
                completion(image); return
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
}
