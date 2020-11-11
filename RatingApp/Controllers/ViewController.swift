//
//  ViewController.swift
//  RatingApp
//
//  Created by Raj Raval on 07/11/20.
//

import UIKit

class ViewController: UIViewController {

    var openSheetButton: DSButton!
    var historyBarButton: UIButton!
    var ratingImageView: UIImageView!

    let rvc = RatingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Rating"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createHistoryBarButton())
        
        createCustomButton()
        createImageView()
    }
    
    // MARK: Custom UIBarButtonItem
    
    func createHistoryBarButton() -> UIButton {
        historyBarButton = UIButton(type: .system)
        historyBarButton.setImage(UIImage(systemName: "clock"), for: .normal)
        historyBarButton.setTitle("History", for: .normal)
        historyBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        historyBarButton.sizeToFit()
        historyBarButton.addTarget(self, action: #selector(openRatingHistory), for: .touchUpInside)
        return historyBarButton
    }
   
    // MARK: UIBarButtonItem Action

    @objc func openRatingHistory() {
        let rhvc = RatingHistoryViewController()
        navigationController?.pushViewController(rhvc, animated: true)
    }
 
    // MARK: Custom UIButton
    
    func createCustomButton() {
        openSheetButton = DSButton(text: "Rating: \(rvc.previousLowerValue ?? 1) - \(rvc.previousUpperValue ?? 9)")
        openSheetButton.translatesAutoresizingMaskIntoConstraints = false
        openSheetButton.addTarget(self, action: #selector(openRatingController), for: .touchUpInside)
        view.addSubview(openSheetButton)
        
        openSheetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        openSheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        openSheetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14).isActive = true
        openSheetButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc func openRatingController() {
        let rvc = RatingViewController()
        let navigationBarOnModal = UINavigationController(rootViewController: rvc)
        present(navigationBarOnModal, animated: true)
    }
    
    // MARK: RatingImageView
    
    func createImageView() {
        ratingImageView = UIImageView()
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.image = UIImage(named: "Rating")
        ratingImageView.contentMode = .scaleAspectFit
        view.addSubview(ratingImageView)
        
        ratingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        ratingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        ratingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
}
