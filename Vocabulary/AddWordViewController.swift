
import UIKit

class AddWordViewController: UIViewController {
    
    private let networkService = NetworkService()

    private enum Constants {
        enum wordTextField {
            static let horizontalSpacing: CGFloat = 20
            static let topSpacing: CGFloat = 90
        }
        enum transcriptionTextField {
            static let horizontalSpacing: CGFloat = 20
            static let topSpacing: CGFloat = 40
        }
        enum translationTextField {
            static let horizontalSpacing: CGFloat = 20
            static let topSpacing: CGFloat = 40
        }
        enum addWordButton {
            static let topSpacing: CGFloat = 20
        }
    }
   
    private lazy var addWordButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перевести", for: .normal)
        let action: UIAction = UIAction {[weak self]_ in
            guard
                let self = self,
                let translateWord = self.wordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                !translateWord.isEmpty
            else { return }
            self.translate(string: translateWord)
            
        }
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private let wordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите новое слово"
        textField.font = .systemFont(ofSize: 34)
        textField.becomeFirstResponder()
        textField.tintColor = .magenta
        
        return textField
    }()
    
    private let transcriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 34)
        textField.placeholder = "Транскрипция"
        
        return textField
    }()
    
    private let translationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 34)
        textField.placeholder = "Перевод"
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(wordTextField)
        view.addSubview(transcriptionTextField)
        view.addSubview(translationTextField)
        view.addSubview(addWordButton)
        setupTitleLabelConstraints()
        translate(string: "world")
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate(
                [
                    wordTextField.leadingAnchor
                        .constraint(
                            equalTo: view.leadingAnchor,
                            constant: Constants.wordTextField.horizontalSpacing
                        ),
                    wordTextField.trailingAnchor
                        .constraint(
                            equalTo: view.trailingAnchor,
                            constant: -Constants.wordTextField.horizontalSpacing
                        ),
                    wordTextField.topAnchor
                        .constraint(
                            equalTo: view.topAnchor,
                            constant: Constants.wordTextField.topSpacing
                        ),
                    
                    transcriptionTextField.leadingAnchor
                        .constraint(
                            equalTo: view.leadingAnchor,
                            constant: Constants.transcriptionTextField.horizontalSpacing
                        ),
                    transcriptionTextField.trailingAnchor
                        .constraint(
                            equalTo: view.trailingAnchor,
                            constant: -Constants.transcriptionTextField.horizontalSpacing
                        ),
                    transcriptionTextField.topAnchor
                        .constraint(
                            equalTo: wordTextField.bottomAnchor,
                            constant: Constants.transcriptionTextField.topSpacing
                        ),
                    
                    translationTextField.leadingAnchor
                        .constraint(
                            equalTo: view.leadingAnchor,
                            constant: Constants.translationTextField.horizontalSpacing
                        ),
                    translationTextField.trailingAnchor
                        .constraint(
                            equalTo: view.trailingAnchor,
                            constant: -Constants.translationTextField.horizontalSpacing
                        ),
                    translationTextField.topAnchor
                        .constraint(
                            equalTo: transcriptionTextField.bottomAnchor,
                            constant: Constants.translationTextField.topSpacing
                        ),
                    
                    addWordButton.topAnchor
                        .constraint(
                            equalTo: translationTextField.bottomAnchor,
                            constant: Constants.addWordButton.topSpacing
                        ),
                    addWordButton.centerXAnchor
                        .constraint(
                            equalTo: view.centerXAnchor
                        )
                ]
            )
    }
    
    private func translate(string: String) {
        self.networkService.getTranslation(word: string) { result in
            switch result {
            case .success(let responseData):
                print("Перевод: \(responseData.translatedText)")
                DispatchQueue.main.async {
                    self.translationTextField.text = "Перевод: \(responseData.translatedText)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.translationTextField.text = "Ошибка: \(error)"
                }
                print("Ошибка: \(error)")
            }
        }
    }
}
