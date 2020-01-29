//
//  LogsTableViewC.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 23/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit
import Alamofire

class LogsTableViewC: UITableViewController {
        
    var startDateLogs: String = ""
    var endDateLogs: String = ""
    var hostName: String = ""
    var new_url = ""
    
    @IBOutlet weak var logsActivityIndicator: UIActivityIndicatorView!
    
    var items = [Logs]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Сообщения"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logsActivityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        let afDelegate = Alamofire.SessionManager.default.delegate
        afDelegate.taskDidComplete = { urlSession, urlSessionTask, error in
            print("Task did complete")
        }

        afDelegate.dataTaskDidReceiveResponse = { urlSession, urlSessionDataTask, urlResponse in
            print("Data task did receive response")
            let urlsrd = URLSession.ResponseDisposition(rawValue: 1)
            return urlsrd!
        }
        
        
        let logVC = self.tabBarController as! TabBarVC
        self.new_url = logVC.new_URL
        getRequest(hola_url: new_url)
        
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogsCellIndetifier", for: indexPath) as! LogsTableViewCell
        
        let item = items[indexPath.row]
        
        cell.hostLabel.text = item.hostName
        cell.timeLabel.text = item.dateLog
        
        cell.logLabel.lineBreakMode = .byWordWrapping
        cell.logLabel.numberOfLines = 0
        cell.logLabel.text = item.logMess
    
        return cell
    }
    
    func getRequest(hola_url: String) { //host: String, st: String, end: String
        Alamofire.request(hola_url, method: .get).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
                }
            guard let arrayOfItems = response.result.value as? [[String: AnyObject]]
                else {
                    print("Не могу перевести в массив")
                    return
            }
            
            for i in arrayOfItems {
               
                let item = Logs(hostName: i["log_name"] as! String, dateLog: self.getDates(inputDate: i["log_time"] as! String), logMess: i["log_text"] as! String)
                self.items.append(item)
                self.logsActivityIndicator.stopAnimating()
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func getDates(inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        let returndate: Date = dateFormatter.date(from: inputDate)!
    
        let strFormatter = DateFormatter()
        strFormatter.dateFormat = "dd-MM-YY HH:mm"
        let strDate: String = strFormatter.string(from: returndate)
        return strDate
    }
   
}

