//
//  ImageUrlServer.swift
//  Cassini
//
//  Created by lyxia on 2016/9/23.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import Foundation

struct ImageUrlServer {
    private static let imageUrlDic = [
        "Image1": "http://www.bz55.com/uploads/allimg/150317/140-15031G02Q2-50.jpg",
        "Image2": "http://www.bz55.com/uploads/allimg/150317/140-15031G02Q2.jpg",
        "Image3": "http://www.bz55.com/uploads/allimg/150317/140-15031G02Q3.jpg"
    ]
    
    static func getUrlByName(_ name: String) -> URL? {
        if let urlString = imageUrlDic[name] {
            return URL(string: urlString)
        }
        return nil
    }
}
