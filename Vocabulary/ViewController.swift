//
//  ViewController.swift
//  Vocabulary
//
//  Created by Егор Абрамов on 11.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    static var reuseIdentifier: String = "Cell"
    
   private let colours = [
        UIColor.purple,
        UIColor.green,
        UIColor.systemPink,
        UIColor.blue,
        UIColor.cyan,
    ]
    
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
        button.addTarget(self, action: #selector(tapAddWord(_ :)), for: .touchUpInside)
        
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(addWordButton)
    }
    
    private func setupNavBar() {
        title = "Словарь"
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
    
    private func setupView() {
        addSubviews()
        makeConstraints()
        setupNavBar()
        view.backgroundColor = .systemBackground
    }
    
    
    
    @objc func tapAddButton(_ sender: UIButton) {
        print("Нажали кнопку добавить")
    }
    
    @objc func tapAddWord(_ sender: UIButton) {
        print("Нажали кнопку Добавить слово")
    }
    
    @objc func tapPlayButton(_ sender: UIButton) {
        print("Нажали кнопку Воспроизвести слово")
    }
}  

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }
        cell.playButton.addTarget(self, action: #selector(tapPlayButton(_ :)), for: .touchUpInside)
        cell.addButton.addTarget(self, action: #selector(tapAddButton(_ :)), for: .touchUpInside)
        
        configCell(cell: cell, dataSource: words[indexPath.row])
       
//        switch indexPath.row % colours.count {
//                case 0:
//            cell.configCell(model: <#T##TableViewCell.Model#>)
//        default:
//            <#code#>
//        }
        
        return cell
    }
    
    private func configCell(cell: TableViewCell, dataSource: DataSource) {
        cell.configCell(
            model:
                TableViewCell.Model(
                    word: dataSource.word,
                    transcription: dataSource.transcription,
                    translation: dataSource.translation,
                    backgroundColour: .cyan
                )
        )
    }
}
