//
//  HomepageTableViewCell.swift
//  enquraCase
//
//  Created by amarenasoftware on 25.05.2022.
//

import UIKit

class HomepageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellview: UIView!
    
    @IBOutlet weak var sube_lbl: UILabel!
    
    @IBOutlet weak var banka_durum_lbl: UILabel!
    
    @IBOutlet weak var banka_tipi_img: UIImageView!
    @IBOutlet weak var banka_tipi_lbl: UILabel!
    @IBOutlet weak var adres_lbl: UILabel!
    @IBOutlet weak var location_img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
