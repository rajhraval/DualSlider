//
//  DualSlider.swift
//  RatingApp
//
//  Created by Raj Raval on 07/11/20.
//

import UIKit

class DualSlider: UIControl {

    var minimumValue: CGFloat = 0.0 {
        didSet {
            updateSliderLayerFrames()
        }
    }
    
    var maximumValue: CGFloat = 1.0 {
        didSet {
            updateSliderLayerFrames()
        }
    }
    
    var lowerValue: CGFloat = 0.1 {
        didSet {
            updateSliderLayerFrames()
        }
    }
    
    var upperValue: CGFloat = 0.9 {
        didSet {
            updateSliderLayerFrames()
        }
    }
    
    var pointerImage: UIImage = UIImage(named: "teardrop")!
    
    var sliderTrackTintColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            sliderTrackLayer.setNeedsDisplay()
        }
    }
    
    var sliderTrackHightTintColor: UIColor = .systemPurple {
        didSet {
            sliderTrackLayer.setNeedsDisplay()
        }
    }
    
    private let sliderTrackLayer = DualSliderTrackLayer()
    private let lowerPointerImageView = UIImageView()
    private let upperPointerImageView = UIImageView()
    private var previousPointerLocation = CGPoint()
    
    // MARK: Updating frames when pointers change
    
    override var frame: CGRect {
        didSet {
            updateSliderLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        sliderTrackLayer.dualSlider = self
        sliderTrackLayer.contentsScale = UIScreen.main.scale
        sliderTrackLayer.cornerRadius = 30
        layer.addSublayer(sliderTrackLayer)
        
        lowerPointerImageView.image = pointerImage
        addSubview(lowerPointerImageView)
        
        upperPointerImageView.image = pointerImage
        addSubview(upperPointerImageView)
        
        updateSliderLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Calculate positon of pointers
    
    private func updateSliderLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderTrackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        sliderTrackLayer.setNeedsDisplay()
        lowerPointerImageView.frame = CGRect(origin: pointerOriginValue(lowerValue), size: pointerImage.size)
        upperPointerImageView.frame = CGRect(origin: pointerOriginValue(upperValue), size: pointerImage.size)
        CATransaction.commit()
    }
    
    /// Scales the given value according the bound's context
    
    public func positonForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    // MARK: Returns the position of the upper and lower pointers to center it on the slider
    
    private func pointerOriginValue(_ value: CGFloat) -> CGPoint {
        let x = positonForValue(value) - pointerImage.size.width / 2
        return CGPoint(x: x, y: (bounds.height - pointerImage.size.height) / 2)
    }
    
    // MARK: Slider Touch-Handlers
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousPointerLocation = touch.location(in: self)
        if lowerPointerImageView.frame.contains(previousPointerLocation) {
            lowerPointerImageView.isHighlighted = true
        } else if upperPointerImageView.frame.contains(previousPointerLocation) {
            upperPointerImageView.isHighlighted = true
        }
        return lowerPointerImageView.isHighlighted || upperPointerImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let currentPointerLocation = touch.location(in: self)
        let newLocation = currentPointerLocation.x - previousPointerLocation.x
        let newLocationValue = (maximumValue - minimumValue) * newLocation / bounds.width
        previousPointerLocation = currentPointerLocation
        
        if lowerPointerImageView.isHighlighted {
            lowerValue += newLocationValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: maximumValue)
        } else if upperPointerImageView.isHighlighted {
            upperValue += newLocationValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        updateSliderLayerFrames()
        sendActions(for: .valueChanged) // Follows Target-Action Pattern
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerPointerImageView.isHighlighted = false
        upperPointerImageView.isHighlighted = false
    }
    
}
