//
//  TriviaScreenViewController.swift
//  aliTest
//
//  Created by Rita on 01.12.2023.
//

import UIKit

class TriviaScreenViewController: UIViewController {
    
    let label = UILabel()
    let button = UIButton(type: .system)
    private let dataFetcherService = DataFetcherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        fetchData(number: "random", type: "trivia")
        setupLabel()
        setupConstraints()
        setupButton()
    }
    
    func setupLabel() {
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(25)
    }
    
    func setupButton() {
        button.layer.cornerRadius = 10
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .darkGray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 70),
            button.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func fetchData(number: String, type: String) {
        dataFetcherService.fetchData(number: number, type: type, completion: { answer in
            guard let answer = answer else { return }
            self.label.text = answer
        })
    }
    
    @objc func refreshButtonTapped() {
        fetchData(number: "random", type: "trivia")
    }
}
