//
//  DetailViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scatterChart: ScatterChartView!
  
  var isChosen: Bool = false

  var teamNumber: Int? {
    didSet {
      configureView()
    }
  }

  func configureView() {
    self.loadViewIfNeeded()

    self.title = "Details - Team #\(self.teamNumber!)"

    let matches = TeamManager.shared.getMatches(of: self.teamNumber!).sorted { $0.matchKey() < $1.matchKey() }

    // Line Chart
    let scaleDataSet = TeamManager.getChartDataSet(from: matches, type: .scales)
    let switchDataSet = TeamManager.getChartDataSet(from: matches, type: .switches)
    let exchangeDataSet = TeamManager.getChartDataSet(from: matches, type: .exchanges)
    scaleDataSet.drawValuesEnabled = false

    let lineData = LineChartData(dataSets: [scaleDataSet, switchDataSet, exchangeDataSet])
    lineData.setDrawValues(false)
    self.lineChart.data = lineData

    self.lineChart.xAxis.setLabelCount(matches.count, force: true)
    self.lineChart.xAxis.valueFormatter = ChartDataFormatter(with: matches)

    // Average
    let avg = TeamManager.totalCubesAverage(from: matches)
    let avgLine = ChartLimitLine(limit: avg)
    self.lineChart.leftAxis.addLimitLine(avgLine)

    self.lineChart.invalidateIntrinsicContentSize()

    // Scatter chart
    let arsDataSet = TeamManager.shared.autoRunSucc(from: matches)
    let arfDataSet = TeamManager.shared.autoRunFail(from: matches)
    let scatterData = ScatterChartData(dataSets: [arsDataSet, arfDataSet])
    scatterData.setDrawValues(false)
    self.scatterChart.data = scatterData
  }

  func prepareStackView () {
    self.stackView.spacing = 8.0
    self.stackView.distribution = .fillEqually
  }

  func prepareLineChart () {
    self.lineChart.noDataText = "Please select a team from the list."
    self.lineChart.noDataFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
    self.lineChart.chartDescription = nil

    self.lineChart.setScaleEnabled(false)
    self.lineChart.pinchZoomEnabled = false
    self.lineChart.dragEnabled = false
    self.lineChart.highlightPerTapEnabled = false
    self.lineChart.legend.enabled = false

    self.lineChart.xAxis.labelPosition = .bottom
    self.lineChart.xAxis.drawGridLinesEnabled = false
    self.lineChart.xAxis.avoidFirstLastClippingEnabled = true
    self.lineChart.xAxis.labelRotationAngle = -90
    self.lineChart.xAxis.granularityEnabled = true
    self.lineChart.xAxis.granularity = 1.0

    self.lineChart.rightAxis.enabled = false

    self.lineChart.leftAxis.drawAxisLineEnabled = false
    self.lineChart.leftAxis.axisMinimum = 0.0
    self.lineChart.leftAxis.axisMaximum = 12.0
    self.lineChart.leftAxis.granularity = 1.0
    self.lineChart.leftAxis.setLabelCount(12, force: true)
  }

  func prepareScatterChart () {
    self.scatterChart.noDataText = "Please select a team from the list."
    self.scatterChart.noDataFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
    self.scatterChart.chartDescription = nil

    self.scatterChart.setScaleEnabled(false)
    self.scatterChart.pinchZoomEnabled = false
    self.scatterChart.dragEnabled = false
    self.scatterChart.highlightPerTapEnabled = false
    self.scatterChart.legend.enabled = false

    self.scatterChart.legend.enabled = false
    self.scatterChart.xAxis.enabled = false
    self.scatterChart.rightAxis.enabled = false

    self.scatterChart.leftAxis.axisMinimum = 0.0
    self.scatterChart.leftAxis.axisMaximum = 6.0
    self.scatterChart.leftAxis.granularity = 1.0
    self.scatterChart.leftAxis.setLabelCount(6, force: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.prepareStackView()
    self.prepareLineChart()
    self.prepareScatterChart()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

