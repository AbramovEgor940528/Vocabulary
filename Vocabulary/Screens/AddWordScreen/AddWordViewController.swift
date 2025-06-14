
import UIKit

final class AddWordViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private enum Constants {
        static let horizontalSpacing: CGFloat = 20
        static let topSpacing: CGFloat = 90
        static let textFieldSpacing: CGFloat = 40
        static let buttonTopSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 60
    }
    
    private var translationTimer: Timer?
    
    private lazy var wordStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.textFieldSpacing
        return stack
    }()
    
    private lazy var wordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите новое слово"
        textField.font = .systemFont(ofSize: 34)
        textField.becomeFirstResponder()
        textField.tintColor = .magenta
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    private let transcriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 34)
        textField.placeholder = "Транскрипция"
        textField.isHidden = true
        
        return textField
    }()
    
    private let translationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 34)
        textField.placeholder = ""
        
        return textField
    }()
    
    private let addWordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить слово", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 60/2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = .init(top: 12, left: 24, bottom: 12, right: 24)
        button.alpha = 0
        button.addTarget(self, action: #selector (addWordButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        wordStackView.addArrangedSubview(wordTextField)
        wordStackView.addArrangedSubview(transcriptionTextField)
        wordStackView.addArrangedSubview(translationTextField)
        
        view.addSubview(wordStackView)
        view.addSubview(addWordButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            wordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing),
            wordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing),
            wordStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topSpacing),
            
            addWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addWordButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Constants.buttonTopSpacing),
            addWordButton.heightAnchor.constraint(equalToConstant:
                                                    Constants.buttonHeight
                                                 )
        ])
    }
    
    private func translate(string: String) {
        self.networkService.getTranslation(word: string) { result in
            switch result {
            case .success(let responseData):
                DispatchQueue.main.async {
                    self.translationTextField.text = responseData.translatedText
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.animate(withDuration: 2.0) {
                            self.addWordButton.alpha = 1
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.translationTextField.text = "Ошибка: \(error)"
                    self.addWordButton.alpha = 0
                }
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        translationTimer?.invalidate()
        
        translationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            guard let self = self,
                  let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !text.isEmpty else {
                return
            }
            self.translate(string: text)
        }
    }
    
    @objc private func addWordButtonTapped() {
        guard let wordText = wordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let transcriptionText = transcriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let translationText = translationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !wordText.isEmpty, !translationText.isEmpty else {
            
            return
        }
        
        let newWord = WordModel(word: wordText, transcription: transcriptionText, translation: translationText)
//        globalWords.append(newWord)
        CoreDataStack.shared.saveWord(word: wordText, transсription: transcriptionText, translation: translationText)
        
        wordTextField.text = ""
        transcriptionTextField.text = ""
        translationTextField.text = ""
        addWordButton.alpha = 0
        
        self.dismiss(animated: true) {
            print("Закрыли экран - AddWordViewController")
            print(Thread.isMainThread)
        }
    }
}
