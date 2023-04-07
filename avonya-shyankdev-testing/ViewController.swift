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

    private var currentScale = 1.0 // we start it to default scale of 1,
    
    @objc func handleZoomGesture(_ recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
        case .ended :
            let scale = recognizer.scale
//            let location = recognizer.location(in: canvasIV)
            let firstFingerLocation = recognizer.location(ofTouch: 0, in: canvasIV)
            let secondFingerLocation = recognizer.location(ofTouch: 1, in: canvasIV)
            print("my sscale os \(scale) and location is \(firstFingerLocation) , \(secondFingerLocation)")
            
            let roundedScale = round(scale * 100) / 100 // round it two level precision level tonincrease performance
            
            if roundedScale < 1 { // zoomed out
                if currentScale == 1 {return}
                var currentScale = currentScale * (1/roundedScale)
                if currentScale > 1 {
                    currentScale = 1
                }
                var gap = 0.5
                
                if currentScale < 0.6 {
                    gap = 0.25
                }else{
                    gap = 0.5
                }
                
                
                let img = getShapeWithCoordinate( canvasWidth: self.defaultCanvasWidth * currentScale, canvasHeight: self.defaultCanvasHeight * currentScale, gap : gap)
                
                canvasIV.image = img
            }else{ // zoomed in
                
            }
            
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



    
