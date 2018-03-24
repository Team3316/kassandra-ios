//
//  Chart.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Charts

extension StatsViewController {
  func configureChart (with matches: [MatchData]) {
    // Line Chart
    let scaleDataSet = TeamManager.getChartDataSet(from: matches, type: .scales)
    let switchDataSet = TeamManager.getChartDataSet(from: matches, type: .switches)
    let exchangeDataSet = TeamManager.getChartDataSet(from: matches, type: .exchanges)

    let lineData = LineChartData(dataSets: [scaleDataSet, switchDataSet, exchangeDataSet])
    lineData.setDrawValues(true)
    self.lineChart.data = lineData

    self.lineChart.xAxis.setLabelCount(matches.count, force: true)

    // Average
    self.lineChart.leftAxis.removeAllLimitLines()
    let avg = round(TeamManager.totalCubesAverage(from: matches))
    let avgLine = ChartLimitLine(limit: avg)
    self.lineChart.leftAxis.addLimitLine(avgLine)

    self.lineChart.invalidateIntrinsicContentSize()

    // Scatter chart
    let arsDataSet = self.teamManager!.autoRunSucc(from: matches)
    let arfDataSet = self.teamManager!.autoRunFail(from: matches)

    let ass1DataSet = self.teamManager!.autoSwitchSucc(from: matches)
    let asf1DataSet = self.teamManager!.autoRunSucc(from: matches)

    let ass2DataSet = self.teamManager!.autoScaleSucc(from: matches)
    let asf2DataSet = self.teamManager!.autoScaleFail(from: matches)

    let platDataSet = self.teamManager!.platform(from: matches)

    let psDataSet = self.teamManager!.partnerSucc(from: matches)
    let pfDataSet = self.teamManager!.partnerFail(from: matches)

    let csDataSet = self.teamManager!.climbSucc(from: matches)
    let cfDataSet = self.teamManager!.climbFail(from: matches)

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
    self.scatterChart.invalidateIntrinsicContentSize()
  }
}

