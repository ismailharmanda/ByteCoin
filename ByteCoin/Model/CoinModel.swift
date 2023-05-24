//
//  WeatherModel.swift
//  Clima
//
//  Created by ismail harmanda on 22.05.2023.
//

import Foundation

struct CoinModel {

    var asset_id_base:String
    var asset_id_quote:String
    var rate:Double
    
    init(asset_id_base: String, asset_id_quote: String, rate: Double) {
        self.asset_id_base = asset_id_base
        self.asset_id_quote = asset_id_quote
        self.rate = rate
    }
    
}
