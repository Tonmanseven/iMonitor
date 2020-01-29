//
//  ProjectCell.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 18/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet weak var imageLep: UIImageView!
    @IBOutlet weak var projectLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Функция переиспользования для знака > 
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}
