//
//  LogsTableViewCell.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 24/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit

class LogsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct Logs {
    let hostName: String
    let dateLog: String
    let logMess: String
}

//struct reqDatas {
//    let host: String
//    let starDat: String
//    let endDat: String
//}
