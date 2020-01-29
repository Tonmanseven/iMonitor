//
//  ChartLineVC.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 29/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import UIKit
import Alamofire
import SwiftChart

class ChartLineVC: UIViewController, ChartDelegate {
    
    
    @IBOutlet weak var chartActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lineChart: Chart!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelLeadingMarginConst: NSLayoutConstraint!
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    var WirenBoardHost = ""
    var start_d = ""
    var end_d = ""
    var vin_val = [String]()
    var time_val = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Телеметрия"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelLeadingMarginInitialConstant = labelLeadingMarginConst.constant
        
        let selectTabBarC = self.tabBarController as! TabBarVC
        self.WirenBoardHost = selectTabBarC.wiren
        self.start_d = selectTabBarC.start_date
        self.end_d = selectTabBarC.end_date
        
        lineChart.delegate = self
        self.chartActivityIndicator.startAnimating()
        getTelemetry(host: WirenBoardHost, start: start_d, end: end_d)
    }
    
    
    fileprivate func initChart(datas: [Double], timeData: [Double]) {
        let series = ChartSeries(datas)
        series.area = true
        var labels: [Double] = []
        var strTime: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd HH:mm"
        // labels numbers
        for (i, _) in timeData.enumerated(){
            labels.append(Double(i))
        }
        
        // label string names
        for i in timeData{
            let date = Date(timeIntervalSince1970: i)
            let strDate = dateFormatter.string(from: date)
            strTime.append(strDate)
        }
        
        lineChart.xLabels = labels
        lineChart.showXLabelsAndGrid = false
        lineChart.xLabelsTextAlignment = .center
        lineChart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return strTime[labelIndex]
        }
        lineChart.add(series)
    }
    
    func getTelemetry(host: String, start: String, end: String) { //host: String, st: String, end: String
        let hola_url = "http://77.222.60.194/telemetry/?log_name=\(host)&min_date=\(start)&max_date=\(end)"
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
                self.vin_val.append(i["vin"] as! String)
                self.time_val.append(i["timetel"] as! String)
                self.chartActivityIndicator.stopAnimating()
            }
            
            var data_val: [Double] = []
            var data_time: [Double] = []
            
            for val in self.vin_val{
                data_val.append(Double(val)!)
            }
            for t in self.time_val{
                data_time.append(self.get_dates(inputDate: t))
                
            }
            
            self.initChart(datas: data_val, timeData: data_time)
            
        }
       
    }
    
    func get_dates(inputDate: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        let returndate: Date = dateFormatter.date(from: inputDate)!

        let dateStamp: TimeInterval = returndate.timeIntervalSince1970
        let doubleDate:Double = Double(dateStamp)
        return doubleDate
    }
    
    
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {

        if let value = lineChart.valueForSeries(0, atIndex: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            label.text = "12:22 " + numberFormatter.string(from: NSNumber(value: value))!
            
            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - label.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }
            
            labelLeadingMarginConst.constant = constant
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConst.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
    
    }
       
}
