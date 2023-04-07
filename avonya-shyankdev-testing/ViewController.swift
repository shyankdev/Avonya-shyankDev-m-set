//
//  ViewController.swift
//  avonya-shyankdev-testing
//
//  Created by Shyank Dev on 4/7/23.
//

import UIKit
import Numerics

class ViewController: UIViewController {

    
    private var canvasHeight : CGFloat = 540
    private var canvasWidth : CGFloat = 540
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: canvasHeight),
            scrollView.widthAnchor.constraint(equalToConstant: canvasWidth),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let img = getShapeWithCoordinate()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            img.heightAnchor.constraint(equalToConstant: canvasHeight),
            img.widthAnchor.constraint(equalToConstant: canvasWidth),
        ])
    }


    private let scrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.backgroundColor = .systemTeal
        scrollview.maximumZoomScale = 100
        return scrollview
    }()
    private let maxIteration = 50
    private func getShapeWithCoordinate() -> UIImageView{
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        let img = rendere.image { ctx in
            
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
            let maxAbsLimit = 2.0
            
            
            
//            stride(from: -Double(canvasWidth/2), to: Double(canvasWidth/2), by: 0.25)
//            stride(from: -Double(canvasHeight/2), to: Double(canvasHeight/2), by: 0.25)
//            for actualX in -Int(canvasWidth/2)...Int(canvasWidth/2) {
//                for actualY in -Int(canvasHeight/2)...Int(canvasHeight/2) {
              
            for actualX in stride(from: -Double(canvasWidth/2), to: Double(canvasWidth/2), by: 0.5) {
                for actualY in stride(from: -Double(canvasHeight/2), to: Double(canvasHeight/2), by: 0.5) {
                    
                    let withDividingFactor = canvasWidth/4
                    let heightDividingFactor = canvasHeight/4
                    
                    let x = CGFloat(actualX)/withDividingFactor // we have to take range of cooirdinate from -2 to +2,
                    let y = CGFloat(actualY)/heightDividingFactor // this will convert pixel location to coordinate on graph
                    
//                    let x = CGFloat(actualX)
//                    let y = CGFloat(actualY)
                    
//                    print("hey x is \(x) , y is \(y) , actuall value are of x & y =>>> \(actualX) \(actualY)")
                    
                    
                    //MARK: - this might be needed in future
//                    let cSqr =  pow(Double(x) , 2) + pow(Double(y), 2)
//                    let c = sqrt(Double(cSqr)) // this is maginautde of c or value of comlex number
//
//                    print("value of c \(c)")
                    
                    var n = 0
                    
                    // fc (z) = z^2 + c
//                    var lastResult = 0.0
                    // we are taking as zero as, at zero value of z is also zero, by convention or by m set structure
//                    let c : Complex<Double> = 2 + 3 * .i
                    
                    let c : Complex<Double> = .init(Double(x), Double(y))
                    
                    var lastPosition : Complex<Double> = 0 + 0 * .i
//                    print(z.real)      // 2.0
//                    print(z.imaginary) // 3.0
//                    let realPart =
//                    var c = Complex(Real(x), Real(y) )
                    while true {
                        let z2 = (lastPosition * lastPosition)
                        lastPosition = z2 + c
                        
                        if abs(lastPosition.lengthSquared) > pow(maxAbsLimit, 2){
//                            print("last result at stage 1 is \(lastResult)")
                            break // we want to ch'eck if this number is under limit which 2 or -2 , abs is used to get absoulte value
                        }
                        n += 1
                        if (n >= maxIteration) {
                            let finalX = CGFloat(actualX)
//                            + canvasWidth/4
                            let finalY = CGFloat(actualY)
//                            + canvasHeight/4
                            
//                            print("actual x = \(actualX) , actual y = \(actualY) , final x = \(finalX)  final y =\(finalY)")
//                            print("last result at final 1 is \(lastPosition)")
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
            
//             print(" \n 💥 \n hallo, poins set are , \(mSetPoints)")
            
//            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
//            ctx.cgContext.translateBy(x: 0, y: canvasHeight/2)
//            ctx.cgContext.rotate(by: -(2 * .pi)/3)
//            ctx.cgContext.move(to: .zero)
//            ctx.cgContext.addLine(to: .init(x: 200, y: -90))
//            ctx.cgContext.addLine(to: .init(x: 100, y: -100))
            
//            for i in 0..<mSetPoints.count {
//                let point = mSetPoints[i]
//                if i == 0 {
//                    ctx.cgContext.move(to: .init(x: point.x, y: -(point.y)))
////                    print("initial point is \(point)")
//                }else{
////                    ctx.cgContext.inser
////                    ctx.cgContext.addQuadCurve(to: point, control: point)
//
//                    ctx.cgContext.addRect(.init(x: point.x, y: point.y, width: 1, height: 1))
////                    ctx.cgContext.addLine(to: .init(x: point.x, y: -(point.y)))
//
//                }
//            }
            
           
//            ctx.cgContext.closePath()
            
            
//            ctx.cgContext.setFillColor(UIColor.black.cgColor)
////            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//            ctx.cgContext.setLineWidth(0)
//            ctx.cgContext.drawPath(using: .fill)
            
//            for point in mSetPoints {
//                ctx.cgContext.addLine(to: point)
//                ctx.cgContext.setFillColor(UIColor.red.cgColor)
//                ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//                ctx.cgContext.setLineWidth(10)
//                ctx.cgContext.drawPath(using: .fillStroke)
//            }
//
//            let rectangle = CGRect(x: 0, y: 0, width: 480  , height: 400)
//            ctx.cgContext.setFillColor(UIColor.red.cgColor)
//            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//            ctx.cgContext.setLineWidth(10)
//
//            ctx.cgContext.addRect(rectangle)
//            ctx.cgContext.drawPath(using: .fillStroke)

        }
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        return iv
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



extension ViewController : UIScrollViewDelegate{
    //    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    //        return .init()
    //    }
}
    
