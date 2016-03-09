//
//  PrimeTableViewCell.swift
//  TableViewPrimes
//
//  Created by weimar on 2/17/16.
//  Copyright © 2016 Weimar. All rights reserved.
//

import UIKit

class PrimeTableViewCell: UITableViewCell {

    @IBOutlet weak var primeImage: UIImageView!
    @IBOutlet weak var primeNumber: UILabel!
    @IBOutlet weak var primeDecomp: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
