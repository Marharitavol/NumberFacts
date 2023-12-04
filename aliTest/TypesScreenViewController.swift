//
//  TriviaScreenViewController.swift
//  aliTest
//
//  Created by Rita on 01.12.2023.
//

import UIKit

class TypesScreenViewController: UIViewController {
    
    let factsLabel = UILabel()
    let refreshButton = UIButton(type: .system)
    
    private let dataFetcherService = DataFetcherService()
    var screenType: Types!
    
    let typeYourNumLabel = UILabel()
    let textField = UITextField()
    let getButton = UIButton(type: .system)
    lazy var stackView = UIStackView(arrangedSubviews: [typeYourNumLabel,textField, getButton])
    
    var textFieldNumbers = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        title = screenType.title
        fetchData(number: "random", type: screenType.rawValue)
        setupStackViewElements()
        setupButton()
        configureStackView()
        setupConstraints()
        textField.delegate = self
    }
    
    func setupStackViewElements() {
        factsLabel.numberOfLines = 0
        factsLabel.textAlignment = .center
        factsLabel.font = factsLabel.font.withSize(25)
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        
        getButton.layer.cornerRadius = 10
        getButton.setTitle("Done", for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        getButton.tintColor = UIColor.darkGray
        getButton.layer.borderWidth = 1
        getButton.layer.borderColor = UIColor.darkGray.cgColor
        
        getButton.addTarget(self, action: #selector(getButtonTapped), for: .touchUpInside)

    }
    
    func setupButton() {
        refreshButton.layer.cornerRadius = 10
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        refreshButton.tintColor = .darkGray
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.borderColor = UIColor.darkGray.cgColor
        
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        typeYourNumLabel.text = "Type your number"
    }
    
    func setupConstraints() {
        factsLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(refreshButton)
        view.addSubview(factsLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            
            textField.widthAnchor.constraint(equalToConstant: 70),
            getButton.widthAnchor.constraint(equalToConstant: 70),
            
            factsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            factsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            factsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            refreshButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 70),
            refreshButton.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func fetchData(number: String, type: String) {
        dataFetcherService.fetchData(number: number, type: type, completion: { answer in
            guard let answer = answer else { return }
            self.factsLabel.text = answer
        })
    }
    
    @objc func refreshButtonTapped() {
        fetchData(number: "random", type: screenType.rawValue)
    }
    
    @objc func getButtonTapped() {
        fetchData(number: textFieldNumbers, type: screenType.rawValue)
    }
}

extension TypesScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textFieldNumbers = textField.text!
        return true
    }
}