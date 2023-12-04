//
//  NetworkDataFetcher.swift
//  aliTest
//
//  Created by Rita on 01.12.2023.
//

import Foundation

protocol DataFetcher {
   func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
    
    func fetchStringData(urlString: String, response: @escaping (String?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    
    var networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void) {
        print(T.self)
        networking.request(urlString: urlString) { (data, error) in
           if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    func fetchStringData(urlString: String, response: @escaping (String?) -> Void) {
        networking.request(urlString: urlString) { (data, error) in
           if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            let decoded = String(decoding: data, as: UTF8.self)
            response(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
