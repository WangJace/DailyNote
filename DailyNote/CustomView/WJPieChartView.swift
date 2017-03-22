//
//  WJPieChartView.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/2/12.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit
import CorePlot
import SnapKit

class WJPieChartView: UIView {
    
    var hostView: CPTGraphHostingView    // 画板
    var pieChart: CPTPieChart            // 饼状图
    var dataSource:[WJHomeStatisticDataModel] = [WJHomeStatisticDataModel]()
    var totalTimeLength: TimeInterval = 0
    
    override init(frame: CGRect) {
        hostView = CPTGraphHostingView()
        pieChart = CPTPieChart()
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        hostView = CPTGraphHostingView()
        pieChart = CPTPieChart()
        super.init(coder: aDecoder)
        setUI()
    }
    
    override func awakeFromNib() {
        setUI()
    }
    
    func setUI() {
        configureHostView()
        configureGraph()
        configureChart()
        configureLegend()
    }
    
    func configureHostView() {
        hostView.allowPinchScaling = false
        addSubview(hostView)
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "HelveticaNeue"
        textStyle.fontSize = 16.0
        textStyle.textAlignment = .center
        
        // 3 - Set graph title and text style
        graph.title = "时间去哪儿了"
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.top
    }
    
    func configureChart() {
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // 2 - Configure the chart
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = 40
        pieChart.identifier = NSString(string: graph.title!)
        pieChart.startAngle = CGFloat(M_PI_4)
        pieChart.sliceDirection = .clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.white()
        borderStyle.lineWidth = 1.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.textAlignment = .center
        pieChart.labelTextStyle = textStyle
        
        // 5 - Add chart to graph
        graph.add(pieChart)
    }
    
    func configureLegend() {
        // 1 - Get graph instance
        guard let graph = hostView.hostedGraph else { return }
        
        // 2 - Create legend
        let theLegend = CPTLegend(graph: graph)
        
        // 3 - Configure legend
        theLegend.numberOfColumns = 1
        theLegend.fill = CPTFill(color: CPTColor.white())
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 18
        theLegend.textStyle = textStyle
        
        // 4 - Add legend to graph
        graph.legend = theLegend
        if frame.width > frame.height {
            graph.legendAnchor = .right
            graph.legendDisplacement = CGPoint(x: -20, y: 0.0)
            
        } else {
            graph.legendAnchor = .bottomRight
            graph.legendDisplacement = CGPoint(x: -8.0, y: 8.0)
        }
    }
    
    func reloadData() {
        layoutSubviews()
        hostView.hostedGraph?.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hostView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        hostView.hostedGraph?.frame = frame
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
    }
}

extension WJPieChartView: CPTPieChartDataSource, CPTPieChartDelegate {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(dataSource.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let timeLength = dataSource[Int(idx)].timeLength
        return timeLength/totalTimeLength
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        let color:UIColor = dataSource[Int(idx)].color
        return CPTFill.init(color: CPTColor.init(cgColor: color.cgColor))
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let timeLength = dataSource[Int(idx)].timeLength
        let layer = CPTTextLayer.init(text: String.init(format: "%.1f%%", (timeLength/totalTimeLength)*100))
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func attributedLegendTitle(for pieChart: CPTPieChart, record idx: UInt) -> NSAttributedString? {
        let title = NSAttributedString.init(string: dataSource[Int(idx)].typeName)
        return title
    }
    
    func legendTitle(for pieChart: CPTPieChart, record idx: UInt) -> String? {
        return dataSource[Int(idx)].typeName
    }
}
