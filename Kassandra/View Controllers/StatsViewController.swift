//
//  DetailViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {
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

    self.parent?.title = "Details - Team #\(self.teamNumber!)"

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

    let ass1DataSet = TeamManager.shared.autoSwitchSucc(from: matches)
    let asf1DataSet = TeamManager.shared.autoRunSucc(from: matches)

    let ass2DataSet = TeamManager.shared.autoScaleSucc(from: matches)
    let asf2DataSet = TeamManager.shared.autoScaleFail(from: matches)

    let platDataSet = TeamManager.shared.platform(from: matches)

    let psDataSet = TeamManager.shared.partnerSucc(from: matches)
    let pfDataSet = TeamManager.shared.partnerFail(from: matches)

    let csDataSet = TeamManager.shared.climbSucc(from: matches)
    let cfDataSet = TeamManager.shared.climbFail(from: matches)

    let scatterData = ScatterChartData(dataSets: [
      arsDataSet,
      arfDataSet,
      ass1DataSet,
      asf1DataSet,
      ass2DataSet,
      asf2DataSet,
      psDataSet,
      pfDataSet,
      csDataSet,
      cfDataSet,
      platDataSet
    ])
    scatterData.setDrawValues(false)
    self.scatterChart.data = scatterData

    self.scatterChart.xAxis.setLabelCount(matches.count, force: false)
    self.scatterChart.xAxis.valueFormatter = ChartDataFormatter(with: matches)
    self.scatterChart.invalidateIntrinsicContentSize()
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
    self.scatterChart.rightAxis.enabled = false

    self.scatterChart.xAxis.labelPosition = .bottom
    self.scatterChart.xAxis.drawGridLinesEnabled = true
    self.scatterChart.xAxis.avoidFirstLastClippingEnabled = true
    self.scatterChart.xAxis.labelRotationAngle = -90
    self.scatterChart.xAxis.granularityEnabled = true
    self.scatterChart.xAxis.granularity = 1.0

    self.scatterChart.leftAxis.axisMinimum = 0.0
    self.scatterChart.leftAxis.axisMaximum = 8.0
    self.scatterChart.leftAxis.granularity = 1.0
    self.scatterChart.leftAxis.setLabelCount(8, force: true)
    self.scatterChart.leftAxis.valueFormatter = ScatterLeftAxis()
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

