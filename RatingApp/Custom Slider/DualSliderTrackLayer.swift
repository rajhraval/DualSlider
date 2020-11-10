//
//  DualSliderTrackLayer.swift
//  RatingApp
//
//  Created by Raj Raval on 08/11/20.
//

import UIKit

class DualSliderTrackLayer: CALayer {
    weak var dualSlider: DualSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = dualSlider else {
            return
        }
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        ctx.setFillColor(slider.sliderTrackTintColor.cgColor)
        ctx.fillPath()
        ctx.setFillColor(slider.sliderTrackHightTintColor.cgColor)
        
        let lowerValuePosition = slider.positonForValue(slider.lowerValue)
        let upperValuePosition = slider.positonForValue(slider.upperValue)
        
        let rect = CGRect(x: lowerValuePosition, y: 0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        ctx.fill(rect)
    }
}
