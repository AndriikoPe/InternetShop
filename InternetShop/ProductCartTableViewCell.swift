//
//  ProductCartTableViewCell.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 12.04.2021.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var cartItemImageView: UIImageView!
  @IBOutlet weak var totalPriceOfItemInCartLabel: UILabel!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
