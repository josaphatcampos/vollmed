//
//  WebService.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import UIKit

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    
    func downloadImage(from imageURl: String)async throws -> UIImage?{
        let imageCache = NSCache<NSString, UIImage>()
        
        guard let url = URL(string: imageURl) else { return nil }
        
        if let cachedImage = imageCache.object(forKey: imageURl as NSString) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else { return nil }
        
        imageCache.setObject(image, forKey: imageURl as NSString)
        
        return image
    }
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        guard let url = URL(string: endpoint) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonDecoder = try? JSONDecoder().decode([Specialist].self, from: data) {
            return jsonDecoder
        } else {
            return nil
        }
    }
}
