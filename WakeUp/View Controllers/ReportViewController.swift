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

class ReportViewController: UIViewController, ChartViewDelegate {
    
    var user: User?
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<AlarmEntity>!
    var alarmEntityList: [AlarmEntity] = []
    
    @IBOutlet weak var weekTextField: UILabel!
    @IBOutlet weak var registeredUserWarningView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleIsRegisteredUser()
        
        let today = Date()
        weekTextField.text = today.startDateOfWeek.dateValue + " - " + today.endDateOfWeek.dateValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.delegate = self
    }
    
    func populateData() {
        
        let today = Date()
        let startDateOfWeek = today.startDateOfWeek
        
        print("start day of week: \(startDateOfWeek), end day of week: \(today.endDateOfWeek)")
        
        
        var weekdays: [Date] = []
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: startDateOfWeek)!
            weekdays.append(date)
        }
        
        var sleepHours: [Double] = []
        weekdays.forEach { (weekday) in
            let sleepDuration = alarmEntityList.filter({ $0.date!.dateValue == weekday.dateValue }).first?.duration ?? 0
            sleepHours.append(sleepDuration)
        }
        setChart(values: sleepHours)
    }
    
    func setChart(values: [Double] ) {
        let weekdays = 7
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<weekdays {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Hours slept")
        chartDataSet.colors = ChartColorTemplates.colorful()
        //chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        customizeBarChart()
    }
    
    func handleIsRegisteredUser() {
        guard self.user != nil else {
            registeredUserWarningView.isHidden = false
            return
        }
        registeredUserWarningView.isHidden = true
        setupFetchedResultsController()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
}

// MARK:- Helper Methods

extension ReportViewController {
    
    // Customize Bar Chart
    
    func customizeBarChart() {
        
        barChartView.noDataText = "You need to provide data for the chart."
        
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        
        barChartView.xAxis.drawLabelsEnabled = false
        
        barChartView.legend.enabled = false
        barChartView.minOffset = -40
        barChartView.extraBottomOffset = -40
        
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        //barChartView.backgroundColor = .red
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
        guard let alarmEntityList = fetchedResultsController.fetchedObjects else { return }
        debugPrint("Alarm entities object count \(alarmEntityList.count)")
        self.alarmEntityList = alarmEntityList
        populateData()
    }
}
