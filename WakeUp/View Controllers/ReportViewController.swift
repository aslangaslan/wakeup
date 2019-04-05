//
//  ReportViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 28.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData
import Charts

class ReportViewController: UIViewController {
    
    var user: User?
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<AlarmEntity>!
    
    @IBOutlet weak var weeklyStackView: UIStackView!
    @IBOutlet weak var registeredUserWarningView: UIView!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleIsRegisteredUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "You need to provide data for the chart."
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let sleepHours = [0,0,6,3,0,10,0]
        setChart(days, values: sleepHours)
    }
    
    func setChart(_ days: [String], values: [Int] ) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<days.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Hours slept")
        chartDataSet.colors = ChartColorTemplates.colorful()
        //chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        
        barChartView.xAxis.drawLabelsEnabled = false
        
        barChartView.legend.enabled = false
        barChartView.minOffset = 0
    }
    
    func handleIsRegisteredUser() {
        guard let _ = self.user else {
            registeredUserWarningView.isHidden = false
            return
        }
        // self.generateMockData()
        setupFetchedResultsController()
    }
}

// Core Data Methods

extension ReportViewController: NSFetchedResultsControllerDelegate {
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            handlePerformFetch()
        } catch {
            debugPrint("Alarm entity could not be read. Core data problem.")
        }
    }
    
    func handlePerformFetch() {
        guard let alarmEntities = fetchedResultsController.fetchedObjects else { return }
        debugPrint("Alarm entities object count \(alarmEntities.count)")
    }
}

// Generate Mock Data

extension ReportViewController {
    
    func generateMockData() {
        let mondaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 22, minute: 15)
        let mondayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 8, minute: 15)
        debugPrint("Sleep time: \(mondaySleepTime)'Wake up time: \(mondayWakeUpTime)")
        self.fillDailyBar(sleepTime: mondaySleepTime, wakeUpTime: mondayWakeUpTime)
        
        let tuesdaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 23, minute: 55)
        let tuesdayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 8, minute: 05)
        debugPrint("Sleep time: \(tuesdaySleepTime)'Wake up time: \(tuesdayWakeUpTime)")
        self.fillDailyBar(sleepTime: tuesdaySleepTime, wakeUpTime: tuesdayWakeUpTime)
        
        let wednesdaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 01, minute: 00)
        let wednesdayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 11, minute: 00)
        debugPrint("Sleep time: \(wednesdaySleepTime)'Wake up time: \(wednesdayWakeUpTime)")
        self.fillDailyBar(sleepTime: wednesdaySleepTime, wakeUpTime: wednesdayWakeUpTime)
        
        let thursdaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 23, minute: 00)
        let thursdayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 8, minute: 00)
        debugPrint("Sleep time: \(thursdaySleepTime)'Wake up time: \(thursdayWakeUpTime)")
        self.fillDailyBar(sleepTime: thursdaySleepTime, wakeUpTime: thursdayWakeUpTime)
        
        let fridaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 22, minute: 15)
        let fridayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 8, minute: 15)
        debugPrint("Sleep time: \(fridaySleepTime)'Wake up time: \(fridayWakeUpTime)")
        self.fillDailyBar(sleepTime: fridaySleepTime, wakeUpTime: fridayWakeUpTime)
        
        let saturdaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 23, minute: 55)
        let saturdayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 8, minute: 05)
        debugPrint("Sleep time: \(saturdaySleepTime)'Wake up time: \(saturdayWakeUpTime)")
        self.fillDailyBar(sleepTime: saturdaySleepTime, wakeUpTime: saturdayWakeUpTime)
        
        let sundaySleepTime = self.createDate(year: 2019, month: 4, day: 1, hour: 01, minute: 00)
        let sundayWakeUpTime = self.createDate(year: 2019, month: 4, day: 2, hour: 11, minute: 00)
        debugPrint("Sleep time: \(sundaySleepTime)'Wake up time: \(sundayWakeUpTime)")
        self.fillDailyBar(sleepTime: sundaySleepTime, wakeUpTime: sundayWakeUpTime)
    }

    func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.timeZone = Calendar.current.timeZone
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        
        // Create date from components
        let userCalendar = Calendar.current
        let date = userCalendar.date(from: components)
        
        return date!
    }
}

// Building Report Methods

extension ReportViewController {
    
    func fillDailyBar(sleepTime: Date, wakeUpTime: Date) {
        
        let calculatedSleepTime = self.getMinute(date: sleepTime)
        let calculatedWakeUpTime = self.getMinute(date: wakeUpTime)
        
        debugPrint("Calculated sleep time: \(calculatedSleepTime), calculated wake up time: \(calculatedWakeUpTime)")
        
        // Calculate Bar Heights
        
        let bottomBarHeight: Double
        if calculatedSleepTime > 720 { bottomBarHeight = Double((calculatedSleepTime - 720) / 3) }
        else { bottomBarHeight = Double((calculatedSleepTime + 720) / 3) }
        
        let sleepBarHeight: Double
        if calculatedSleepTime > 720 { sleepBarHeight = Double(abs(calculatedSleepTime - calculatedWakeUpTime)) / 5 }
        else { sleepBarHeight = Double(abs(calculatedSleepTime - calculatedWakeUpTime)) / 3 }
        
        let topBarHeight = 480 - bottomBarHeight - sleepBarHeight
        
        debugPrint("Bottom bar height: \(bottomBarHeight), Sleep bar height: \(sleepBarHeight), Top bar height: \(topBarHeight)")
        
        // Create Bars
        
        let bottomBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: bottomBarHeight))
        bottomBar.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        //bottomBar.backgroundColor = .clear
        bottomBar.heightAnchor.constraint(equalToConstant: CGFloat(bottomBarHeight)).isActive = true
        
        let sleepBar = UIView(frame: CGRect(x:0 , y: 0, width: 0, height: sleepBarHeight))
        sleepBar.backgroundColor = UIColor(red:0.00, green:0.59, blue:1.00, alpha:1.0)
        sleepBar.heightAnchor.constraint(equalToConstant: CGFloat(sleepBarHeight)).isActive = true
        sleepBar.layer.cornerRadius = 5
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: topBarHeight))
        topBar.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        //topBar.backgroundColor = .clear
        topBar.heightAnchor.constraint(equalToConstant: CGFloat(topBarHeight)).isActive = true
        
        // Create and Add Daily Stack View
        
        self.createAndAddDailyStackView([topBar, sleepBar, bottomBar])
    }
    
    func getMinute(date: Date) -> Int {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        return (hour * 60) + minute
    }
    
    func createAndAddDailyStackView(_ views: [UIView]) {
        let dailyStackView = UIStackView(arrangedSubviews: views)
        dailyStackView.axis = .vertical
        dailyStackView.distribution = .fill
        dailyStackView.alignment = .fill
        dailyStackView.translatesAutoresizingMaskIntoConstraints = false
        dailyStackView.spacing = 0
        
        weeklyStackView.insertArrangedSubview(dailyStackView, at: 0)
        self.view.layoutIfNeeded()
    }
}
