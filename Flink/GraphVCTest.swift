//
//  GraphVCTest.swift
//  Flink
//
//  Created by Joao Pedro Brandao on 7/28/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit
import PNChartSwift

// tem q chamar HealthDAO.loadHealthData antes
// setar o identifier (tem que ser um HKQuantityTypeIdentifier)
class GraphVCTest: UIViewController, PNChartDelegate
{
    var identifier:String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 0, self.view.frame.width*0.9, self.view.frame.height*0.6))
        lineChart.center = self.view.center
        
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        
        lineChart.showCoordinateAxis = true
        lineChart.delegate = self
        
        var ydataArray:[CGFloat] = []
        
        // Line Chart Nr.1
        var hdata:[HealthData] = HealthDAO.getDataOfCategory(identifier)
        //ydataArray = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2]
        ydataArray = getValuefromHData(hdata)
        
        var xdataArray:[String] = []
        for val in ydataArray
        {
            xdataArray += [""]
        }
        lineChart.xLabels = xdataArray
        
        var data01:PNLineChartData = PNLineChartData()
        data01.color = UIColor(red: 235/255, green: 184/255, blue: 49/255, alpha: 1.0)
        
        data01.itemCount = ydataArray.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            var yValue:CGFloat = ydataArray[index]
            var item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        
        lineChart.delegate = self
        
        self.view.addSubview(lineChart)
        self.title = hdata[0].name + " (" + hdata[0].unit + ")"
        
        println(self.title)
        
    }
    
    func getValuefromHData(hdata:[HealthData]) -> [CGFloat]
    {
        var val:[CGFloat] = []
        
        for heal in hdata
        {
            val += [CGFloat(heal.value)]
        }
        
        return val
    }
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarChartIndex(barIndex: Int)
    {
        println("Click  on bar \(barIndex)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//{
//    var chartView : GraphView!
//    var hdata:[HealthData] = []
//    
//
//    @IBOutlet weak var btntest: UIButton!
//
//    var kl = true
//    @IBAction func makechart(sender: AnyObject)
//    {
//        if kl
//        {
//            //hdata = HealthDAO.loadHealthData(NSDate.distantPast() as! NSDate, endDate: NSDate())
//
//            kl = false
//            println("printei os dados")
//        }
//        else
//        {
//            var dats:[HealthData] = []
//
//            for kl in Facade.instance.hData
//            {
//                if kl.name == "Body Mass"
//                {
//                    dats += [kl]
//                }
//            }
//
//            //chartView = GraphView(frame: view.frame, yAxisData: dats);
//
//            //chartView.lineChart.strokeChart()
//        }
//
//    }
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        
//        HealthDAO.authorizeHealthKit { (authorized,  error) -> Void in
//            if authorized
//            {
//                println("HealthKit authorization received.")
//            }
//            else
//            {
//                println("HealthKit authorization denied!")
//                if error != nil
//                {
//                    println("\(error)")
//                }
//            }
//            println("Autorizei")
//        }
//    }
//
//    
//    override func viewWillAppear(animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        
////        data01Array = [ 0, 15, 7, 8, 3, 7, 1]
////        data01 = PNLineChartData()
////        data01.color = PNGreenColor
////        data01.itemCount = data01Array.count
////        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
////        data01.getData = ({(index: Int) -> PNLineChartDataItem in
////            var yValue : CGFloat = self.data01Array[index]
////            var item = PNLineChartDataItem(y: yValue)
////            return item
////        })
//        
////        chartView.lineChart.chartData = [data01]
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//}