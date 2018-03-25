//
//  Preperations.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Charts

extension StatsViewController {
  func prepareStackView () {
    self.stackView.distribution = .fillProportionally
  }

  func prepareLineChart () {
    self.lineChart.noDataText = "Please select a team from the list."
    self.lineChart.noDataFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
    self.lineChart.noDataTextColor = UIColor.white
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
    self.lineChart.leftAxis.axisMaximum = 15.0
    self.lineChart.leftAxis.granularity = 1.0
    self.lineChart.leftAxis.setLabelCount(16, force: true)

    self.lineChart.leftAxis.gridColor = UIColor.white
    self.lineChart.leftAxis.zeroLineColor = UIColor.white
    self.lineChart.leftAxis.axisLineColor = UIColor.white
    self.lineChart.leftAxis.labelTextColor = UIColor.white

    self.lineChart.xAxis.gridColor = UIColor.white
    self.lineChart.xAxis.axisLineColor = UIColor.white
    self.lineChart.xAxis.labelTextColor = UIColor.white
  }

  func prepareScatterChart () {
    self.scatterChart.noDataText = "Please select a team from the list."
    self.scatterChart.noDataFont = UIFont.systemFont(ofSize: 30, weight: .heavy)
    self.scatterChart.noDataTextColor = UIColor.white
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
    self.scatterChart.leftAxis.axisMaximum = 7.0
    self.scatterChart.leftAxis.granularity = 1.0
    self.scatterChart.leftAxis.setLabelCount(8, force: true)
    self.scatterChart.leftAxis.valueFormatter = ScatterLeftAxis()

    self.scatterChart.leftAxis.gridColor = UIColor.white
    self.scatterChart.leftAxis.zeroLineColor = UIColor.white
    self.scatterChart.leftAxis.axisLineColor = UIColor.white
    self.scatterChart.leftAxis.labelTextColor = UIColor.white

    self.scatterChart.xAxis.gridColor = UIColor.white
    self.scatterChart.xAxis.axisLineColor = UIColor.white
    self.scatterChart.xAxis.labelTextColor = UIColor.white
  }
}
