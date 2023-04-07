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
        
        let img = getShapeWithCoordinate( canvasWidth: self.canvasWidth, canvasHeight: self.canvasHeight)
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
    
    private func getShapeWithCoordinate(canvasWidth : CGFloat , canvasHeight : CGFloat) -> UIImageView{
        let rendere = UIGraphicsImageRenderer(size: .init(width: canvasWidth, height: canvasHeight))
        let img = rendere.image { ctx in
            
            ctx.cgContext.translateBy(x: canvasWidth/2, y: canvasHeight/2)
            let maxAbsLimit = 2.0
            
            for actualX in stride(from: -Double(canvasWidth/2), to: Double(canvasWidth/2), by: 0.5) {
                for actualY in stride(from: -Double(canvasHeight/2), to: Double(canvasHeight/2), by: 0.5) {
                    
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
                            let finalX = CGFloat(actualX)
                            let finalY = CGFloat(actualY)
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
    
