//
//  DataFetcherService.swift
//  aliTest
//
//  Created by Rita on 01.12.2023.
//

import Foundation

class DataFetcherService {
var dataFetcher: DataFetcher!

  init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
      self.dataFetcher = dataFetcher
  }
    
    func fetchData(number: String, type: String, completion: @escaping (String?) -> Void) {
        let url = "http://numbersapi.com/\(number)/\(type)"
        dataFetcher.fetchStringData(urlString: url, response: completion)
    }
}
