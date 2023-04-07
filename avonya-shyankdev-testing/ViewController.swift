//
//  ViewController.swift
//  avonya-shyankdev-testing
//
//  Created by Shyank Dev on 4/7/23.
//

import UIKit

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
    
    private func getShapeWithCoordinate() -> UIImageView{
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        let img = rendere.image { ctx in
            
            let maxIteration = 500
            let maxAbsLimit = 2.0
            
            var mSetPoints = [CGPoint]()
            
            for actualX in -Int(canvasWidth/2)...Int(canvasWidth/2) {
                for actualY in -Int(canvasHeight/2)...Int(canvasHeight/2) {
                    
                    let withDividingFactor = canvasWidth/4
                    let heightDividingFactor = canvasHeight/4
                    
                    let x = CGFloat(actualX)/withDividingFactor // we have to take range of cooirdinate from -2 to +2,
                    let y = CGFloat(actualY)/heightDividingFactor // this will convert pixel location to coordinate on graph
                    
//                    let x = CGFloat(actualX)
//                    let y = CGFloat(actualY)
                    
//                    print("hey x is \(x) , y is \(y) , actuall value are of x & y =>>> \(actualX) \(actualY)")
                    
                    let cSqr =  pow(Double(x) , 2) + pow(Double(y), 2)
                    let c = sqrt(Double(cSqr)) // this is maginautde of c or value of comlex number
                    
//                    print("value of c \(c)")
                    
                    var n = 0
                    
                    // fc (z) = z^2 + c
                    var lastResult = 0.0
                    // we are taking as zero as, at zero value of z is also zero, by convention or by m set structure
                    
                    while true {
                        
                        lastResult = pow(Double(lastResult) , 2) + c
                        
                        if abs(lastResult) > maxAbsLimit{
//                            print("last result at stage 1 is \(lastResult)")
                            break // we want to ch'eck if this number is under limit which 2 or -2 , abs is used to get absoulte value
                        }
                        
                        n += 1
                        if (n >= maxIteration) {
                            let finalX = CGFloat(actualX)
//                            + canvasWidth/4
                            let finalY = CGFloat(actualY)
//                            + canvasHeight/4
                            mSetPoints.append(.init(x: finalX * 5, y: finalY * 5))
                            print("actual x = \(actualX) , actual y = \(actualY) , final x = \(finalX)  final y =\(finalY)")
                            print("last result at final 1 is \(lastResult)")
                            break
                        }
                    }
                    
                }
            }
            
             print(" \n 💥 \n hallo, poins set are , \(mSetPoints)")
            
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
//            ctx.cgContext.translateBy(x: 0, y: canvasHeight/2)
//            ctx.cgContext.rotate(by: -(2 * .pi)/3)
//            ctx.cgContext.move(to: .zero)
//            ctx.cgContext.addLine(to: .init(x: 200, y: -90))
//            ctx.cgContext.addLine(to: .init(x: 100, y: -100))
            
            for i in 0..<mSetPoints.count {
                let point = mSetPoints[i]
                if i == 0 {
                    ctx.cgContext.move(to: .init(x: point.x, y: -(point.y)))
                    print("initial point is \(point)")
                }else{
                    ctx.cgContext.addLine(to: .init(x: point.x, y: -(point.y)))

                }
            }
            
           
            
            
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.drawPath(using: .stroke)
            
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
        return iv
    }
    
    private func getRandomColor() -> UIColor {
        let color = [UIColor.red , .blue , .green , .systemPink , .orange , .yellow].randomElement() ?? .brown
        return color
    }
}



extension ViewController : UIScrollViewDelegate{
    //    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    //        return .init()
    //    }
}
    
