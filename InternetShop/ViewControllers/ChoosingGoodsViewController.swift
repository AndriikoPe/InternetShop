//
//  HomeViewController.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import UIKit

class ChoosingGoodsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  var goods: Goods?
  var cart = [Good:Int]()

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    guard let jsonData = readLocalFile("jsonData") else { return }
    goods = try? JSONDecoder().decode(Goods.self, from: jsonData)
    goods?.sort(ascending: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    cart = UserDefaults.standard.codableObject(dataType: [Good:Int].self, key: Constants.Defaults.cartData) ?? [Good:Int]()
    collectionView.reloadData()
  }
    
  private func readLocalFile(_ name: String) -> Data? {
    do {
      if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
        let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
          return jsonData
        }
    } catch {
      print(error)
    }
    return nil
  }

  @IBAction func segmentedControlValueChanged(_ sender: Any) {
    let oldArray = goods?.goods ?? [Good]();
    switch sortingSegmentedControl.selectedSegmentIndex {
    case 0:
      goods?.sort(ascending: true)
      break
    case 1:
      goods?.sort(ascending: false)
      break
    default: break
    }
    reloadWithAnimation(oldValues: oldArray)
  }
  
  func reloadWithAnimation(oldValues: [Good]) {
    collectionView.performBatchUpdates {
      let newArray = goods?.goods ?? [Good]();
      for i in oldValues.indices {
        if oldValues[i] != newArray[i], let newIndex = newArray.firstIndex(of: oldValues[i]) {
          let oldPath = IndexPath(row: i, section: 0),
              newPath = IndexPath(row: newIndex, section: 0)
          collectionView.moveItem(at: oldPath, to: newPath)
          collectionView.moveItem(at: newPath, to: oldPath)
        }
      }
    }
  }

  // MARK: - Collection view methods
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    goods?.goods.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.StoryBoard.collectionViewCellId, for: indexPath)
    if let productCell = cell as? ProductCollectionViewCell {
      guard let good = goods?.goods[indexPath.row] else { return cell }
      productCell.productNameLabel.text = good.name
      productCell.priceLabel.text = String(good.price ?? 0.0)
      view.contentMode = .scaleAspectFill
      view.clipsToBounds = true
      productCell.imageView.image = nil
      HelpingFuncs.fetchImage(for: good.imageURL, into: productCell.imageView)
      productCell.numberOfItemsInCartLabel.text = String(cart[good] ?? 0)
      productCell.addItemButton.addTarget(self, action: #selector(self.addItemToCart(_:)), for: .touchUpInside)
      productCell.removeItemButton.addTarget(self, action: #selector(self.removeItemFromCart(_:)), for: .touchUpInside)
    }
    return cell
  }
  
  
  @objc func addItemToCart(_ sender: UIButton) {
    guard let indexPath = indexPath(for: sender) else { return }
    let index = indexPath.row
    guard let item = goods?.goods[index] else { return }
    // If the item is nil, 0 + 1 = 1. If the item is not nil, adds one more.
    cart.updateValue((cart[item] ?? 0) + 1, forKey: item)
    cart = HelpingFuncs.update(cart: cart)
    UserDefaults.standard.setCodableObject(cart, forKey: Constants.Defaults.cartData)
    (collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell)?
      .numberOfItemsInCartLabel.text = String(cart[item] ?? 0)
  }
  
  @objc func removeItemFromCart(_ sender: UIButton) {
    guard let indexPath = indexPath(for: sender) else { return }
    let index = indexPath.row
    guard let item = goods?.goods[index] else { return }
    // Returns if there are less than 1 items in the cart.
    if (cart[item] ?? 0 < 1) { return }
    cart.updateValue((cart[item] ?? 0) - 1, forKey: item)
    cart = HelpingFuncs.update(cart: cart)
    UserDefaults.standard.setCodableObject(cart, forKey: Constants.Defaults.cartData)
    (collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell)?
      .numberOfItemsInCartLabel.text = String(cart[item] ?? 0)
  }
  
  func indexPath(for sender: UIButton) -> IndexPath? {
    collectionView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collectionView))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: 120, height: 160)
  }
}
