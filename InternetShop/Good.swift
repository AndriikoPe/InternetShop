//
//  File.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import Foundation

struct Goods: Codable {
  var goods: [Good]
  
  mutating func sort(ascending: Bool) {
    if ascending {
      goods.sort { (good1, good2) -> Bool in
        (good2.price ?? 0) - (good1.price ?? 0) > 0
      }
    } else {
      goods.sort { (good1, good2) -> Bool in
        (good1.price ?? 0) - (good2.price ?? 0) > 0
      }
    }
  }
}

struct Good: Codable, Equatable, Hashable {
  let name: String?
  let imageURL: String?
  let price: Double?
  
  enum CodingKeys: String, CodingKey {
    case name
    case imageURL = "image-url"
    case price
  }
}

extension UserDefaults {
  func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
    let encoded = try? JSONEncoder().encode(data)
    set(encoded, forKey: defaultName)
  }
  func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
     guard let userDefaultData = data(forKey: key) else {
       return nil
     }
     return try? JSONDecoder().decode(T.self, from: userDefaultData)
   }
}
