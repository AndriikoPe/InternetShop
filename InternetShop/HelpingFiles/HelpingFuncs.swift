//
//  HelpingFuncs.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import Foundation
import UIKit

struct HelpingFuncs {
  static func isValidEmail(_ email: String)  -> Bool {
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    return emailPredicate.evaluate(with: email)
  }
  static  func fetchImage(for url:String?, into view: UIImageView) {
    guard let url = URL(string: url ?? "") else { return }
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      guard let data = data else {
        return
      }
      DispatchQueue.main.async {
        view.image = UIImage(data: data)
      }
    }
    task.resume()
  }
  static func update(cart: [Good:Int]) -> [Good:Int] {
    var cartTmp = cart
    for good in cart.keys {
      if cartTmp[good] == 0 {
        cartTmp[good] = nil
      }
    }
    return cartTmp
  }
}
