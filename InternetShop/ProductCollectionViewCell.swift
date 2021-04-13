//
//  ProductCollectionViewCell.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var addItemButton: UIButton!
  @IBOutlet weak var removeItemButton: UIButton!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var numberOfItemsInCartLabel: UILabel!
}
