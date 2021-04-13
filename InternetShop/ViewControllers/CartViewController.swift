//
//  CartViewController.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource {
  var cart = [Good:Int]()
  var goods: Goods?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var currentPriceLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cart = UserDefaults.standard.codableObject(dataType: [Good:Int].self,
                                 key: Constants.Defaults.cartData) ?? [Good:Int]()
    goods = Goods(goods: Array(cart.keys))
    tableView.reloadData()
    updateTotalCost()
  }
  
  func updateTotalCost() {
    var totalPrice = 0.0
    for good in cart.keys {
      totalPrice += (good.price ?? 0.0) * Double(cart[good] ?? 0)
    }
    currentPriceLabel.text = "Total price: \(round(totalPrice * 100.0) / 100.0)"
  }
    
  // MARK: - Table view methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cart.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.tableViewCellId, for: indexPath)
    guard let productCell = cell as? ProductCartTableViewCell,
          let good = goods?.goods[indexPath.row] else { return cell }
    productCell.productNameLabel.text = good.name
    let totalPrice = round((Double(cart[good] ?? 0) * (good.price ?? 0.0)) * 100.0) / 100.0
    productCell.totalPriceOfItemInCartLabel.text = "\(cart[good] ?? 0) x \(good.price ?? 0.0) = \(totalPrice)"
    productCell.cartItemImageView.image = nil
    HelpingFuncs.fetchImage(for: good.imageURL, into: productCell.cartItemImageView)
    return productCell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete, let good = goods?.goods[indexPath.row] {
      cart[good] = nil
      goods?.goods.remove(at: indexPath.row)
      UserDefaults.standard.setCodableObject(cart, forKey: Constants.Defaults.cartData)
      tableView.deleteRows(at: [indexPath], with: .fade)
      updateTotalCost()
    }
  }
}
