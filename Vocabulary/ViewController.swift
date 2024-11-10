//
//  ViewController.swift
//  Vocabulary
//
//  Created by Егор Абрамов on 11.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let colours = [
        UIColor.systemYellow,
        UIColor.systemGreen,
        UIColor.systemPink,
        UIColor.systemBlue,
        UIColor.cyan,
    ]
    private enum Colours {
        static let yellow = UIColor.systemYellow
        static let green = UIColor.systemGreen
        static let pink = UIColor.systemPink
        static let blue = UIColor.systemBlue
        static let cyan = UIColor.cyan
    }
    
    private enum Layout {
        enum AddButton {
            static let height: CGFloat = 48
            static let cornerRadius: CGFloat = height/2
            static let bottomSpacing: CGFloat = 104
            static let widthButton: CGFloat = 206
        }
        enum TableViewConstraints {
            static let lateralSpacing: CGFloat = 8
            static let TopSpacing: CGFloat = 20
        }
    }
    
    private lazy var addWordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("AddWord", comment: ""), for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Layout.AddButton.cornerRadius
        let action = UIAction { _ in
        print("Нажали кнопку добавить слово")
        }
        button.addAction (action, for: .touchUpInside)
        
        return button
    }()
    
    private struct DataSource {
        let word: String
        let transcription: String
        let translation: String
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let words: [DataSource] = [
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение"),
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение"),
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение"),
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение"),
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение"),
        DataSource(word: "application", transcription: "æplɪˈkeɪʃn", translation: "приложение")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(addWordButton)
    }
    
    enum LocalizedString {
        static let dictionaryTitle = NSLocalizedString("DictionaryTitle", comment: "")
    
    }
    
    private func setupNavBar() {
        title = LocalizedString.dictionaryTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Layout.TableViewConstraints.TopSpacing),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.TableViewConstraints.lateralSpacing),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.TableViewConstraints.lateralSpacing),
            
            addWordButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Layout.AddButton.bottomSpacing),
            addWordButton.heightAnchor.constraint(
                equalToConstant: Layout.AddButton.height),
            addWordButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            addWordButton.widthAnchor.constraint(equalToConstant: Layout.AddButton.widthButton)
        ])
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
    }
    
    private func setupView() {
        addSubviews()
        makeConstraints()
        setupNavBar()
        view.backgroundColor = .systemBackground
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func didTapCell(at index: Int) {
        print("Индекс ячейки \(index)")
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }

        configCell(cell: cell, dataSource: words[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    private func configCell(cell: TableViewCell, dataSource: DataSource, index: Int) {
        cell.configCell(
            model:
                TableViewCell.Model(
                    word: dataSource.word,
                    transcription: dataSource.transcription,
                    translation: dataSource.translation,
                    backgroundColour: getbackgroundColour(index)
                )
        )
    }
    
    private func getbackgroundColour(_ index: Int) -> UIColor {
        
        return colours[index % 5]
    }

}
