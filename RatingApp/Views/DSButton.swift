//
//  DSButton.swift
//  RatingApp
//
//  Created by Raj Raval on 11/11/20.
//

import UIKit

class DSButton: UIButton {

    required init(text: String) {
        super.init(frame: .zero)
        backgroundColor = .systemPurple
        setTitle(text, for: .normal)
        titleLabel?.textColor = .white
        layer.cornerRadius = 13
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
