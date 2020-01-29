//
//  PostTableViewCell.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 23/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "PostIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "PostTableViewCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 110.0
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImage.image = UIImage(named: "lep")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // Функция переиспользования для знака >
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }

}
