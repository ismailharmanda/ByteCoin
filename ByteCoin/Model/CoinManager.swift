//
//  CoinManager.swift
//  ByteCoin
//
//  Created by ismail harmanda on 23.05.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager:CoinManager,coin:CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7B20C370-F563-4841-A81A-4ADAF07EAE19"
    
    let currencyArray: [String]
    
    var selectedCurrency: String

    init() {
        currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
        selectedCurrency = currencyArray[0]
    }

     func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        // 1. Create a URL
        if let url = URL(string: urlString){
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)
            
            return coin
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
