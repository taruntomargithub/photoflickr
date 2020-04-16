//
//  ImageSearchViewModel.swift
//  PhotoFlikr
//
//  Created by Varun Tomar on 05/04/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation
import Alamofire

class ImageSearchViewModel {
    
    var dataArray: GenericType<[Photo]> =  GenericType([])
    
    func fetchData(searchText: String, pageCount: Int) {
        Alamofire.request("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=75f49785083cf8953a3febfae04469da&format=json&nojsoncallback=1&page=\(pageCount)&text=\(searchText)&per_page=20").responseJSON { response in
            guard let data = response.data else {return}
            do {
                let photosOutput = try JSONDecoder().decode(Photos.self, from: data)
                self.dataArray.value.append(contentsOf: photosOutput.photos.photo)
            }
            catch let jsonErr {
                print("Error:", jsonErr)
            }
        }
    }
}
