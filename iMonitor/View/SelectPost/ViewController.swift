//
//  ViewController.swift
//  InlineDatePicker
//
//  Created by Rajtharan Gopal on 07/06/18.
//  Copyright © 2018 Rajtharan Gopal. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    var datePickerIndexPath: IndexPath?
    var postCellIndexPath: IndexPath?
    var inputTexts: [String] = ["От:", "До:"]
    var inputDates: [Date] = []
    var tableView: UITableView!
    let groups = ["Выберите период данных", "Выберите пост"]
    let project = Posts()
    var projectNumber: Int = 0
    
    var startD = ""
    var endD = ""
    var url_my = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if projectNumber == 0 {
            self.navigationItem.title = "ИЭСК"
        } else if projectNumber == 1 {
            self.navigationItem.title = "МРСК Северо-Запада"
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        addInitailValues()
        setupTableView()
        
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height), style: .grouped)
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: DateTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DateTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: PostTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: PostTableViewCell.reuseIdentifier())
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func addInitailValues() {
        inputDates = Array(repeating: Date(), count: inputTexts.count)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func indexPathToInsertPost(indexPath: IndexPath) -> IndexPath {
        if let postCellIndexPath = postCellIndexPath, postCellIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func getDates(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: inputDate)
        return strDate
    }
    
    func requestData(h: String, s: String, e:String) -> String{
        let my_url = ("http://77.222.60.194/logs/?log_name=\(h)&min_date=\(s)&max_date=\(e)")
        return my_url
    }
    
    

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = [groups, project.iesk_posts]
        if datePickerIndexPath != nil {
            return items[0].count + 1
        } else {
            return items[section].count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath[0] == 0 {
            if datePickerIndexPath == indexPath {
                let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseIdentifier()) as! DatePickerTableViewCell
                datePickerCell.updateCell(date: inputDates[indexPath.row - 1], indexPath: indexPath)
                datePickerCell.delegate = self
                return datePickerCell
            } else {
                let dateCell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier()) as! DateTableViewCell
                dateCell.updateText(text: inputTexts[indexPath.row], date: inputDates[indexPath.row])
                
                var dates = ["start": Date(), "end": Date()]
                
                if indexPath.row == 0 {
                    let startDate = inputDates[indexPath.row]
                    dates["start"] = startDate
                    self.startD = getDates(inputDate: startDate)
                } else if indexPath.row == 1 {
                    let endDate = inputDates[indexPath.row]
                    dates["end"] = endDate
                    self.endD = getDates(inputDate: endDate)
                }
                
                return dateCell
            }
        } else {
            let postCell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier()) as! PostTableViewCell
            postCell.postTitle.text = project.checkProject(row: projectNumber)[indexPath.row]
            postCell.accessoryType = .disclosureIndicator
            return postCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section]
        
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath[0] == 0 {
            tableView.beginUpdates()
            if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                self.datePickerIndexPath = nil
            } else {
                if let datePickerIndexPath = datePickerIndexPath {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                }
                datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            tableView.endUpdates()
        } else {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: .main)
            let tabVc = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            navigationController?.pushViewController(tabVc, animated: true)
            
            url_my = requestData(h: project.getPostName(projName: projectNumber, row: indexPath.row), s: startD, e: endD)
            tabVc.new_URL = url_my
            tabVc.wiren = project.getPostName(projName: projectNumber, row: indexPath.row)
            tabVc.start_date = startD
            tabVc.end_date = endD
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath[0] == 0 {
            if datePickerIndexPath == indexPath {
                return DatePickerTableViewCell.cellHeight()
            } else  {
                return DateTableViewCell.cellHeight()
            }
        } else {
            return PostTableViewCell.cellHeight()
        }
        
    }
    
    
}

extension ViewController: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        inputDates[indexPath.row] = date
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
