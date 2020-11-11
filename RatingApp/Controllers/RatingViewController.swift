//
//  RatingViewController.swift
//  RatingApp
//
//  Created by Raj Raval on 07/11/20.
//

import UIKit
import CoreData

class RatingViewController: UIViewController {
    
    // MARK: Properties
    
    var dualSlider: DualSlider!
    var lowerValueLabel: UILabel!
    var upperValueLabel: UILabel!
    var lowerRatingLabel: UILabel!
    var upperRatingLabel: UILabel!
    var submitButton: DSButton!
    
    var delegate: PreviousRatingDelegate?
    
    // MARK: Slider Values

    var sliderLowerValue: Int = 1 {
        didSet {
            lowerValueLabel.text = "\(sliderLowerValue)"
        }
    }
    
    var sliderUpperValue: Int = 9 {
        didSet {
            upperValueLabel.text = "\(sliderUpperValue)"
        }
    }
    
    var previousLowerValue = UserDefaults.standard.optionalInt(forKey: "lower")
    var previousUpperValue = UserDefaults.standard.optionalInt(forKey: "upper")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Choose Rating"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeSheet))
        
        composeView()
    }
    
    func composeView() {
        createDualSlider()
        createLowerValueLabel()
        createUpperRatingLabel()
        createUpperValueLabel()
        createLowerRatingLabel()
        createSubmitButton()
    }
    
    // MARK: Labels
    
    func createLowerValueLabel() {
        lowerValueLabel = UILabel()
        lowerValueLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerValueLabel.text = "\(sliderLowerValue)"
        lowerValueLabel.textAlignment = .left
        lowerValueLabel.numberOfLines = 0
        lowerValueLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        lowerValueLabel.textColor = .label
        view.addSubview(lowerValueLabel)
        
        lowerValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        lowerValueLabel.bottomAnchor.constraint(equalTo: dualSlider.topAnchor, constant: -30).isActive = true
    }
    
    func createLowerRatingLabel() {
        lowerRatingLabel = UILabel()
        lowerRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerRatingLabel.text = "Lowest Rating"
        lowerRatingLabel.textAlignment = .left
        lowerRatingLabel.numberOfLines = 0
        lowerRatingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        lowerRatingLabel.textColor = .label
        view.addSubview(lowerRatingLabel)
        
        lowerRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        lowerRatingLabel.bottomAnchor.constraint(equalTo: lowerValueLabel.topAnchor, constant: -10).isActive = true
    }
    
    func createUpperRatingLabel() {
        upperRatingLabel = UILabel()
        upperRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        upperRatingLabel.text = "Highest Rating"
        upperRatingLabel.textAlignment = .right
        upperRatingLabel.numberOfLines = 0
        upperRatingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        upperRatingLabel.textColor = .label
        view.addSubview(upperRatingLabel)
        
        upperRatingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        upperRatingLabel.topAnchor.constraint(equalTo: dualSlider.bottomAnchor, constant: 30).isActive = true
    }
    
    func createUpperValueLabel() {
        upperValueLabel = UILabel()
        upperValueLabel.translatesAutoresizingMaskIntoConstraints = false
        upperValueLabel.text = "\(sliderUpperValue)"
        upperValueLabel.textAlignment = .right
        upperValueLabel.numberOfLines = 0
        upperValueLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        upperValueLabel.textColor = .label
        view.addSubview(upperValueLabel)
        
        upperValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        upperValueLabel.topAnchor.constraint(equalTo: upperRatingLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    
    // MARK: Custom DualSlider
    
    func createDualSlider() {
        dualSlider = DualSlider(frame: .zero)
        dualSlider.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 2 * 30, height: 30)
        dualSlider.center = view.center
        dualSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addSubview(dualSlider)
    }
    
    @objc func sliderValueChanged(_ dualSlider: DualSlider) {
        sliderLowerValue = Int((dualSlider.lowerValue * 10).rounded(.up))
        sliderUpperValue = Int((dualSlider.upperValue * 10).rounded(.up))
        //print("\(sliderLowerValue), \(sliderUpperValue)") 
    }
    
    // MARK: Buttons
    
    func createSubmitButton() {
        submitButton = DSButton(text: "Submit")
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(createSubmitAction), for: .touchUpInside)
        view.addSubview(submitButton)
        
        submitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        submitButton.topAnchor.constraint(equalTo: upperValueLabel.bottomAnchor, constant: 50).isActive = true
    }
    
    @objc func createSubmitAction() {
        if (sliderLowerValue == 1 && sliderUpperValue == 10) || (sliderLowerValue == 0 && sliderUpperValue == 10) || (sliderLowerValue == sliderUpperValue) {
            showAlert(title: "Invalid Range", message: "Please try to set a range either from 1 to 9 or 2 to 10.", handler: nil)
        } else {
            saveRating()
            UserDefaults.standard.set(sliderLowerValue, forKey: "lower")
            UserDefaults.standard.set(sliderUpperValue, forKey: "upper")
            showAlert(title: "Rating Saved!", message: "Your rating is saved. Check your rating history for more info.", handler: { _ in
                self.closeSheet()
                self.dualSlider.lowerValue = CGFloat(1 / 10)
                self.dualSlider.upperValue = CGFloat(9 / 10)
            })
        }
    }
    
    // MARK: Core Data
    
    func saveRating() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RatingItem", in: managedContext)!
        let rating = NSManagedObject(entity: entity, insertInto: managedContext)
        rating.setValue(Date(), forKey: "date")
        rating.setValue(Int16(sliderLowerValue), forKey: "lowerValue")
        rating.setValue(Int16(sliderUpperValue), forKey: "upperValue")
        
        do {
            try managedContext.save()
            //print("Rating is Saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @objc func closeSheet() {
        dismiss(animated: true)
    }
    
    // MARK: Alert Helper
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(ac, animated: true)
    }
}

// MARK: Extension

extension UserDefaults {
    
    public func optionalInt(forKey defaultName: String) -> Int? {
       let defaults = self
       if let value = defaults.value(forKey: defaultName) {
           return value as? Int
       }
       return nil
   }
    
}

// MARK: Protocol

protocol PreviousRatingDelegate {
    func getLowerValue(lowerValue: Int) -> String
    func getUpperValue(upperValue: Int) -> String
}
