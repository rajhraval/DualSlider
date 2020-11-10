//
//  RatingViewCell.swift
//  RatingApp
//
//  Created by Raj Raval on 09/11/20.
//

import UIKit

class RatingViewCell: UITableViewCell {
    
    var lowerRatingLabel: UILabel!
    var upperRatingLabel: UILabel!
    var dateLabel: UILabel!
    var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        addSubview(stackView)
        
        lowerRatingLabel = UILabel()
        lowerRatingLabel.font = UIFont.preferredFont(forTextStyle: .body)
        lowerRatingLabel.textColor = .label
        stackView.addArrangedSubview(lowerRatingLabel)
        
        upperRatingLabel = UILabel()
        upperRatingLabel.font = UIFont.preferredFont(forTextStyle: .body)
        upperRatingLabel.textColor = .label
        stackView.addArrangedSubview(upperRatingLabel)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        dateLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
