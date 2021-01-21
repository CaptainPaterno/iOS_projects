//
//  Model.swift
//  StatePark
//
//  Created by Yixuan Zhang on 9/29/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import Foundation




struct ParkInfo:Codable {
    var name:String
    var count:Int
}

typealias parkinfo = ParkInfo
typealias parksInfo = [parkinfo]


class Model{
    var allParks: parksInfo
    
    init () {
        let mainBundle = Bundle.main
        let parkURL = mainBundle.url(forResource: "Parks", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: parkURL!)
            let decoder = PropertyListDecoder()
            allParks = try decoder.decode(parksInfo.self, from: data)
        } catch {
            print(error)
            allParks = []
            print(allParks)
        }
    }
    
    
}
