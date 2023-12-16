//
//  TriviaScreenViewController.swift
//  aliTest
//
//  Created by Rita on 01.12.2023.
//

import UIKit
import CoreData

class TypesScreenViewController: UIViewController {
    
    let factsLabel = UILabel()
    let typeYourNumLabel = UILabel()
    var screenTypeLabel = UILabel()
    
    private let dataFetcherService = DataFetcherService()
    var screenType: Types!
    
    var favoriteItem: Favorite?
    
    let textField = UITextField()
    let refreshButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    let favoriteButton = UIButton(type: .system)
    
    lazy var stackView = UIStackView(arrangedSubviews: [typeYourNumLabel,textField, doneButton])
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var textFieldNumbers = String()
    var isFavoriteButtonFilled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        title = screenType.title
        
        fetchData(number: "random", type: screenType.rawValue)
        
        setupStackViewElements()
        setupRefreshButton()
        setupFavoriteButton()
        configureStackView()
        setupConstraints()
        setupScreenTypeLabel()
        setupFactsLabel()
        setupKeyboardLayout()
        
        textField.delegate = self
    }
    
    func setupStackViewElements() {
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.textColor = .black
        textField.keyboardType = .numbersAndPunctuation
        
        doneButton.layer.cornerRadius = 10
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        doneButton.tintColor = UIColor.lightGray
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.black.cgColor
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        typeYourNumLabel.text = "Type your number"
    }
    
    func setupFavoriteButton() {

        if isFavorite() {
            isFavoriteButtonFilled = true
            updateButtonUI(isFavorite: isFavoriteButtonFilled)
        } else {
            isFavoriteButtonFilled = false
            updateButtonUI(isFavorite: isFavoriteButtonFilled)
        }

        favoriteButton.tintColor = UIColor.systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    func setupRefreshButton() {
        refreshButton.layer.cornerRadius = 10
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        refreshButton.tintColor = .black
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.borderColor = UIColor.black.cgColor
        
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    func setupFactsLabel() {
        factsLabel.numberOfLines = 0
        factsLabel.textAlignment = .center
        factsLabel.font = factsLabel.font.withSize(25)
    }
    
    func setupScreenTypeLabel() {
        screenTypeLabel.text = "\(screenType.rawValue.capitalized) Facts"
        screenTypeLabel.backgroundColor = .opaqueSeparator
        screenTypeLabel.textAlignment = .center
        screenTypeLabel.font = screenTypeLabel.font.withSize(25)
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
    }
    
    func setupConstraints() {
        factsLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        screenTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(refreshButton)
        view.addSubview(factsLabel)
        view.addSubview(stackView)
        view.addSubview(screenTypeLabel)
        view.addSubview(favoriteButton)
        
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            
            textField.widthAnchor.constraint(equalToConstant: 70),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            favoriteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            
            factsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            factsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            factsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            screenTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            screenTypeLabel.heightAnchor.constraint(equalToConstant: 70),
            
            refreshButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 70),
            refreshButton.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func fetchData(number: String, type: String) {
        dataFetcherService.fetchData(number: number, type: type, completion: { [weak self] answer in
            guard let self = self, let answer = answer else { return }
            self.factsLabel.text = answer
            self.setupFavoriteButton()
        })
    }
    
    @objc func favoriteButtonTapped() {
            if isFavoriteButtonFilled {
                removeFromFavorites()
                isFavoriteButtonFilled = false
            } else {
                addToFavorites()
                isFavoriteButtonFilled = true
            }

//            isFavoriteButtonFilled.toggle()
            updateButtonUI(isFavorite: isFavoriteButtonFilled)
        }

        func isFavorite() -> Bool {
            guard let factsText = factsLabel.text else {
                return false
            }

            let fetchRequest = Favorite.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "favoritesFacts == %@", factsText)

            do {
                let result = try context.fetch(fetchRequest)
                favoriteItem = result.first
                isFavoriteButtonFilled = !result.isEmpty
                return isFavoriteButtonFilled
            } catch {
                print("Failed to fetch favorite item: \(error)")
                return false
            }
        }

        func addToFavorites() {
            if isFavorite() {
                return
            }

            let newFavorite = Favorite(context: context)
            newFavorite.favoritesFacts = factsLabel.text

            do {
                try context.save()
                favoriteItem = newFavorite
            } catch {
                print("Failed to save favorite item: \(error)")
            }
        }

        func removeFromFavorites() {
            guard let existingFavorite = favoriteItem else {
                return
            }

            context.delete(existingFavorite)

            do {
                try context.save()
            } catch {
                print("Failed to remove favorite item: \(error)")
            }
        }

        func updateButtonUI(isFavorite: Bool) {
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
    
    @objc func refreshButtonTapped() {
        fetchData(number: "random", type: screenType.rawValue)
        textField.text = ""
        textFieldNumbers = ""
        doneButton.tintColor = UIColor.lightGray
        isFavoriteButtonFilled = false
        updateButtonUI(isFavorite: isFavoriteButtonFilled)
    }
    
    @objc func doneButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        fetchData(number: textFieldNumbers, type: screenType.rawValue)
    }
}

extension TypesScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textFieldNumbers = textField.text!
        doneButtonTapped()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textFieldNumbers = textField.text!
        doneButtonTapped()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        doneButton.tintColor = UIColor.black
        return true
    }
}
