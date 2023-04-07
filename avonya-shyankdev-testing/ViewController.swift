//
//  ViewController.swift
//  avonya-shyankdev-testing
//
//  Created by Shyank Dev on 4/7/23.
//

import UIKit
import Numerics

class ViewController: UIViewController {

    
    private var defaultCanvasHeight : CGFloat = 540
    private var defaultCanvasWidth : CGFloat = 540
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: defaultCanvasHeight),
            scrollView.widthAnchor.constraint(equalToConstant: defaultCanvasWidth),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.addSubview(canvasIV)
        
        NSLayoutConstraint.activate([
            canvasIV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasIV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            canvasIV.heightAnchor.constraint(equalToConstant: defaultCanvasHeight),
            canvasIV.widthAnchor.constraint(equalToConstant: defaultCanvasWidth),
        ])
        
//        let img = getShapeWithCoordinate( canvasWidth: self.canvasWidth, canvasHeight: self.canvasHeight, gap : 0.5)
        
//        let img = getShaopeImagePartSmaller(graphHeight: 2, graphWidth: 2 , canvasWidth: self.defaultCanvasWidth, canvasHeight: self.defaultCanvasHeight, gap : 0.5 , drawingOriginX : 0 , drawingOriginY : 0)
        let img = getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight: 2, graphWidth: 2, drawingOriginX: 0, drawingOriginY: 0)
//        getShaopeImagePartSmaller
//        let img = getShapeForSmallArea(fromX: -defaultCanvasWidth/2, fromY: -defaultCanvasHeight/2, canvasWidth: defaultCanvasWidth, canvasHeight: defaultCanvasHeight, gap: 0.5)
        canvasIV.image = img
        canvasIV.isUserInteractionEnabled = true
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handleZoomGesture(_:)) )
        
        canvasIV.addGestureRecognizer(gesture)
    }

//    private var currentScale = 1.0 // we start it to default scale of 1,
    
    
    private var firstFingerLocation : CGPoint = .init()
    
    private var secondFingerLocation : CGPoint = .init()
    
    
    private var graphHeight : CGFloat  = 2
    private var graphWidth : CGFloat = 2
    
    private lazy var  lastCenterOfGraphXInCanvas : CGFloat = defaultCanvasWidth/2
    private lazy var  lastCenterOfGraphYInCanvas : CGFloat = defaultCanvasHeight/2
    
//    private var lastBoundEdge = 0.0
    
    private var centerXOfGraph : CGFloat {
        let withDividingFactor = defaultCanvasWidth/2 * 0.5 // this is becuase we divide the axis above
        return (lastCenterOfGraphXInCanvas / withDividingFactor)
    }
    private var centerYOfGraph : CGFloat {
        let heightDividingFactor = defaultCanvasHeight/2 * 0.5
        // this is becuase we divide the axis above
        return (lastCenterOfGraphYInCanvas / heightDividingFactor)
    }
    
    @objc func handleZoomGesture(_ recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
            
        
        case .began :
            
            firstFingerLocation = recognizer.location(ofTouch: 0, in: canvasIV)
            secondFingerLocation = recognizer.location(ofTouch: 1, in: canvasIV)
            
        case .ended :

            let scale = recognizer.scale
            
            var roundedScale = round(scale * 100) / 100 // round it two level precision level tonincrease performance
            
//            roundedScale
//            if roundedScale < 1 {
//                graphHeight = graphHeight / roundedScale
//                graphWidth = graphWidth / roundedScale
//
//            }else{
//                graphHeight = graphHeight / roundedScale
//                graphWidth = graphWidth / roundedScale
//
//            }
            if roundedScale < 1 {
                graphWidth = graphWidth * 1.3
                graphHeight = graphHeight * 1.3
            }else{
                graphWidth = graphWidth * 0.9
                graphHeight = graphHeight * 0.9
            }
           
            if (graphWidth > 2) {
                graphWidth = 2
//                centerXOfGraph = 0
//                centerYOfGraph = 0
            }
            if (graphHeight > 2) {
                graphHeight = 2
//                centerXOfGraph = 0
//                centerYOfGraph = 0
            }
            print("hallo values are  1 \(graphWidth) \(graphHeight)")
            
            if (graphHeight == 2 ||  graphWidth == 2) {
                let img = getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight: 2, graphWidth: 2, drawingOriginX: 0, drawingOriginY: 0)
                print("hallo values are  2 \(graphWidth) \(graphHeight)")
                canvasIV.image = img
                return
            }
            
            if roundedScale < 1 { //zoom out
                let img = getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight: graphHeight, graphWidth: graphWidth, drawingOriginX: centerXOfGraph, drawingOriginY: centerYOfGraph)
                print("hallo values are 3 \(graphWidth) \(graphHeight)")
                canvasIV.image = img
                return
            }
                
            // zoom in is left from now
            
            
            let firstFingerX = firstFingerLocation.x
            
            let secondFIngerX = secondFingerLocation.x
            
            let firstFingerY = firstFingerLocation.y
            
            let secondFIngerY = secondFingerLocation.y
           
            
            
            
            
            print("my sscale os \(scale) and location is \(firstFingerLocation) , \(secondFingerLocation)")
            
            // let build new box react here
            
            let startingY = firstFingerY <= secondFIngerY ? firstFingerY : secondFIngerY
            
            // I need a point where y is smaller so I will can easily get more room
            
            let statingX = firstFingerX <= secondFIngerX ? firstFingerX : secondFIngerX
            
            // I need a point where x is smaller so I will can easily get more room
            
            let diffInXAxis = abs(secondFIngerX - firstFingerX )
            let diffInYaxis = abs(secondFIngerY - firstFingerY )
            
            let newEdgeForBox = (diffInYaxis > diffInXAxis) ? diffInYaxis : diffInXAxis
            
            let startingXForNewBox : CGFloat
            let startingYForNewBox : CGFloat
            
            if (defaultCanvasHeight - startingY) >= newEdgeForBox {
                startingYForNewBox = startingY
            }else if  startingY >= newEdgeForBox {
                startingYForNewBox = startingY - newEdgeForBox
            }else{
                startingYForNewBox = 0
            }
            
            if (defaultCanvasWidth - statingX) >= newEdgeForBox {
                startingXForNewBox = statingX
            }else if statingX >= newEdgeForBox{
                startingXForNewBox = statingX - newEdgeForBox
            }else{
                startingXForNewBox = 0
            }

            let middleX = (startingXForNewBox) / 2
            let middleY = (startingYForNewBox) / 2
 
            lastCenterOfGraphXInCanvas = middleX
            lastCenterOfGraphYInCanvas = middleY
            
            print("hey final value for graphh are \(centerXOfGraph)--- \(centerYOfGraph) ,---- , \(startingYForNewBox) , \(startingXForNewBox) \(newEdgeForBox) / \(graphWidth) , \(graphHeight)")
            
            let img = getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight: graphHeight, graphWidth: graphWidth, drawingOriginX: centerXOfGraph, drawingOriginY: centerYOfGraph)
            
            canvasIV.image = img
            
            return
            
            // we have now ready with react for new box with y coordinate : startingYForNewBox, x coordinate : startingXForNewBox , and edge if newEdgeForBox
            
//            var heightRatioForGraphHeightForNewBox = (2 * newEdgeForBox) / (defaultCanvasHeight / 2)
//
//            if heightRatioForGraphHeightForNewBox > 2 {
//                heightRatioForGraphHeightForNewBox = 2
//            }
//
//            // newEdge/half of canvas height = newHightForGraph/2, becuase we have 2 for half of canvas height (270 for now)
//
//            var widthRatioForGraphWidthForNewBox = (2 * newEdgeForBox) / (defaultCanvasWidth / 2)
//
//            if widthRatioForGraphWidthForNewBox > 2 {
//                widthRatioForGraphWidthForNewBox = 2
//            }
            
            // same logic ^^^^
            
//            print("hello , postin of box are , \(startingXForNewBox) , \(startingYForNewBox) , \(heightRatioForGraphHeightForNewBox) , \(widthRatioForGraphWidthForNewBox) , \(newEdgeForBox)")
            
            
           
            
            
            
            
//            let img = getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight: 1, graphWidth: 1, drawingOriginX: 0, drawingOriginY: 0)
//
//            canvasIV.image = img
            
            
//            if roundedScale == 1 {return}
//
            
        default :
            break
        }
   
        
        
        
    }
    

    private let canvasIV :  UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let scrollView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemTeal
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let maxIteration = 50
    
    private func getShapeWithFirstDrawigPointAndGraphHeightWidth(graphHeight : CGFloat , graphWidth : CGFloat , drawingOriginX : Double , drawingOriginY : Double ) -> UIImage {
        let img = getShaopeImagePartSmaller(graphHeight: graphHeight, graphWidth: graphWidth, canvasWidth: self.defaultCanvasWidth, canvasHeight: self.defaultCanvasHeight, gap: 0.5, drawingOriginX: drawingOriginX, drawingOriginY: drawingOriginY)
        return img
    }
    
    private func getShaopeImagePartSmaller(graphHeight : CGFloat , graphWidth : CGFloat ,  canvasWidth : CGFloat , canvasHeight : CGFloat , gap : Double, drawingOriginX : Double , drawingOriginY : Double) -> UIImage{
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        let img = rendere.image { ctx in
            
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
            let maxAbsLimit = 2.0
            
            for actualX in stride(from: -Double(canvasWidth/2), to: Double(canvasWidth/2), by: gap) {
                for actualY in stride(from: -Double(canvasHeight/2), to: Double(canvasHeight/2), by: gap) {
                    
                    let withDividingFactor = canvasWidth/graphWidth * 0.5 // this is becuase we divide the axis above
                    let heightDividingFactor = canvasHeight/graphHeight * 0.5
                    
                    let x = CGFloat(actualX)/withDividingFactor // we have to take range of cooirdinate from -2 to +2,
                    let y = CGFloat(actualY)/heightDividingFactor // this will convert pixel location to coordinate on graph
                    
                    var n = 0 // number of iterations
                    let c : Complex<Double> = .init(Double(x), Double(y))
//                    var lastPosition : Complex<Double> = 0 + 0 * .i
                    var lastPosition : Complex<Double> = .init(drawingOriginX, drawingOriginY)
                    while true {
                        let z2 = (lastPosition * lastPosition)
                        lastPosition = z2 + c
                        
                        if abs(lastPosition.lengthSquared) > pow(maxAbsLimit, 2){
                            break // we want to ch'eck if this number is under limit which 2 or -2 , abs is used to get absoulte value
                        }
                        n += 1
                        if (n >= maxIteration) {
//                            let finalX = CGFloat(actualX)
//                            let finalY = CGFloat(actualY)
                            break
                        }
                    }
                    if (n >= maxIteration) {
                        ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    }else{
                        ctx.cgContext.setFillColor(getColorForPoint(numberOfIteration: n).cgColor)
                    }
                    ctx.cgContext.addRect(.init(x: actualX, y: actualY, width: 1, height: 1))
                    ctx.cgContext.drawPath(using: .fill)
                    
                }
            }

        }
        return img
//        let iv = UIImageView(image: img)
//        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .gray
//        return iv
    }
    
    
    private func getShapeForSmallArea(fromX : CGFloat , fromY : CGFloat ,  canvasWidth : CGFloat , canvasHeight : CGFloat , gap : Double) -> UIImage {
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        
        let img = rendere.image { ctx in
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
            let maxAbsLimit = 2.0
            
            for actualX in stride(from: fromX, to: Double(canvasWidth/2), by: gap) {
                for actualY in stride(from: fromY, to: Double(canvasHeight/2), by: gap) {

                    let withDividingFactor = canvasWidth/4
                    let heightDividingFactor = canvasHeight/4
                    
                    let x = CGFloat(actualX)/withDividingFactor // we have to take range of cooirdinate from -2 to +2,
                    let y = CGFloat(actualY)/heightDividingFactor // this will convert pixel location to coordinate on graph
                    
                    var n = 0 // number of iterations
                    let c : Complex<Double> = .init(Double(x), Double(y))
                    var lastPosition : Complex<Double> =
                        .init(
                            -(fromX + canvasWidth/2)/withDividingFactor,
                              (fromY + canvasHeight/2)/heightDividingFactor )
//                    = 0 + 0 * .i
                      print("youar center is \(lastPosition)")
                    while true {
                        let z2 = (lastPosition * lastPosition)
                        lastPosition = z2 + c
                        
                        if abs(lastPosition.lengthSquared) > pow(maxAbsLimit, 2){
                            break // we want to ch'eck if this number is under limit which 2 or -2 , abs is used to get absoulte value
                        }
                        n += 1
                        if (n >= maxIteration) {
//                            let finalX = CGFloat(actualX)
//                            let finalY = CGFloat(actualY)
                            break
                        }
                    }
                    if (n >= maxIteration) {
                        ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    }else{
                        ctx.cgContext.setFillColor(getColorForPoint(numberOfIteration: n).cgColor)
                    }
                    ctx.cgContext.addRect(.init(x: actualX, y: actualY, width: 1, height: 1))
                    ctx.cgContext.drawPath(using: .fill)
                    
                }
                
            }
        }
        
        return img
    }
    
    private func getShapeWithCoordinate(canvasWidth : CGFloat , canvasHeight : CGFloat , gap : Double) -> UIImage{
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        let img = rendere.image { ctx in
            
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
            let maxAbsLimit = 2.0
            
            for actualX in stride(from: -Double(canvasWidth/2), to: Double(canvasWidth/2), by: gap) {
                for actualY in stride(from: -Double(canvasHeight/2), to: Double(canvasHeight/2), by: gap) {
                    
                    let withDividingFactor = canvasWidth/4
                    let heightDividingFactor = canvasHeight/4
                    
                    let x = CGFloat(actualX)/withDividingFactor // we have to take range of cooirdinate from -2 to +2,
                    let y = CGFloat(actualY)/heightDividingFactor // this will convert pixel location to coordinate on graph
                    
                    var n = 0 // number of iterations
                    let c : Complex<Double> = .init(Double(x), Double(y))
                    var lastPosition : Complex<Double> = 0 + 0 * .i
                    while true {
                        let z2 = (lastPosition * lastPosition)
                        lastPosition = z2 + c
                        
                        if abs(lastPosition.lengthSquared) > pow(maxAbsLimit, 2){
                            break // we want to ch'eck if this number is under limit which 2 or -2 , abs is used to get absoulte value
                        }
                        n += 1
                        if (n >= maxIteration) {
//                            let finalX = CGFloat(actualX)
//                            let finalY = CGFloat(actualY)
                            break
                        }
                    }
                    if (n >= maxIteration) {
                        ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    }else{
                        ctx.cgContext.setFillColor(getColorForPoint(numberOfIteration: n).cgColor)
                    }
                    ctx.cgContext.addRect(.init(x: actualX, y: actualY, width: 1, height: 1))
                    ctx.cgContext.drawPath(using: .fill)
                    
                }
            }

        }
        return img
//        let iv = UIImageView(image: img)
//        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .gray
//        return iv
    }
    
    private func getRandomColor() -> UIColor {
        let color = [UIColor.red , .blue , .green , .systemPink , .orange , .yellow].randomElement() ?? .brown
        return color
    }
    
    private func getColorForPoint(numberOfIteration : Int) -> UIColor {
        if numberOfIteration == maxIteration {
               return .black
           }
           let hue = CGFloat(numberOfIteration) / CGFloat(maxIteration)
           return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}



    
