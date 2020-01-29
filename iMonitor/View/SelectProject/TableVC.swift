//
//  TableVC.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 18/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    let img = UIImage(named: "project")
    private var projects = ["ИЭСК", "МРСК Северо-Запада"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Monitor System"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch tableView {
        case self.tableView:
            return self.projects.count
        default:
            return 0
        }
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProjectCell
        
        cell.projectLable.text = self.projects[indexPath.row]
        cell.imageLep.image = img
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите проект"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let mainStory = UIStoryboard(name: "Main", bundle: .main)
        let viewC = mainStory.instantiateViewController(withIdentifier: "viewC") as! ViewController
        viewC.projectNumber = indexPath.row
        
        navigationController?.pushViewController(viewC, animated: true)
    }

}
