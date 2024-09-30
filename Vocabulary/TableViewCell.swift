//
//  TableViewCell.swift
//  Vocabulary
//
//  Created by Егор Абрамов on 15.09.2024.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    struct Model {
        let word: String
        let transcription: String
        let translation: String
        let backgroundColour: UIColor
    }
    
    private enum Constraints {
        enum roundBackgroundView {
            static let lateralSpacing: CGFloat = 8
            static let verticacSpacing: CGFloat = 4
            static let height: CGFloat = 120
        }
        enum wordLabel {
            static let topSpacing: CGFloat = 40
            static let bottomSpacing: CGFloat = 60
            static let leadingSpacing: CGFloat = 16
            static let trailingSpacing: CGFloat = 8
        }
        enum transcriptionLabel {
            static let topSpacing: CGFloat = 42
            static let bottomSpacing: CGFloat = 64
            static let lateralSpacing: CGFloat = 8
        }
        enum translationLabel {
            static let topSpacing: CGFloat = 60
            static let bottomSpacing: CGFloat = 36
            static let leadingSpacing: CGFloat = 16
        }
        enum addButton {
            static let verticacSpacing: CGFloat = 40
            static let trailingSpacing: CGFloat = 12
        }
        enum playButton {
            static let verticacSpacing: CGFloat = 40
            static let trailingSpacing: CGFloat = 12
        }
    }
    
    private enum FontSize {
        static let wordLabel: CGFloat = 18
        static let transcriptionLabel: CGFloat = 12
        static let translationLabel: CGFloat = 20
    }
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: FontSize.wordLabel, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    private let transcriptionLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .systemFont(ofSize: FontSize.transcriptionLabel, weight: .regular)
        lable.textColor = .gray
        lable.textAlignment = .left
        
        return lable
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: FontSize.translationLabel, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    private var roundBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus"), for: .normal)
        
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play"), for: .normal)
        
        return button
    }()
    
    func configCell(model: Model) {
        wordLabel.text = model.word
        transcriptionLabel.text = model.transcription
        translationLabel.text = model.translation
        roundBackgroundView.backgroundColor = model.backgroundColour
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCell() {
        addSubview(roundBackgroundView)
        roundBackgroundView.addSubview(wordLabel)
        roundBackgroundView.addSubview(transcriptionLabel)
        roundBackgroundView.addSubview(translationLabel)
        roundBackgroundView.addSubview(addButton)
        roundBackgroundView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            roundBackgroundView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constraints.roundBackgroundView.verticacSpacing),
            roundBackgroundView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constraints.roundBackgroundView.verticacSpacing),
            roundBackgroundView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constraints.roundBackgroundView.lateralSpacing),
            roundBackgroundView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constraints.roundBackgroundView.lateralSpacing),
            roundBackgroundView.heightAnchor.constraint(
                equalToConstant: Constraints.roundBackgroundView.height),
            
            wordLabel.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraints.wordLabel.topSpacing),
            wordLabel.bottomAnchor.constraint(
                equalTo: roundBackgroundView.bottomAnchor,
                constant: -Constraints.wordLabel.bottomSpacing),
            wordLabel.leadingAnchor.constraint(
                equalTo: roundBackgroundView.leadingAnchor,
                constant: Constraints.wordLabel.leadingSpacing),
            wordLabel.trailingAnchor.constraint(
                equalTo: transcriptionLabel.leadingAnchor,
                constant: -Constraints.wordLabel.trailingSpacing),
            
            transcriptionLabel.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraints.transcriptionLabel.topSpacing),
            transcriptionLabel.bottomAnchor.constraint(
                equalTo: roundBackgroundView.bottomAnchor,
                constant: -Constraints.transcriptionLabel.bottomSpacing),
            transcriptionLabel.leadingAnchor.constraint(
                equalTo: wordLabel.trailingAnchor,
                constant: Constraints.transcriptionLabel.lateralSpacing),
            transcriptionLabel.trailingAnchor.constraint(
                equalTo: playButton.leadingAnchor,
                constant: -Constraints.transcriptionLabel.lateralSpacing),
            
            translationLabel.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraints.translationLabel.topSpacing),
            translationLabel.leadingAnchor.constraint(
                equalTo: roundBackgroundView.leadingAnchor,
                constant: Constraints.translationLabel.leadingSpacing),
            translationLabel.bottomAnchor.constraint(
                equalTo: roundBackgroundView.bottomAnchor,
                constant: -Constraints.translationLabel.bottomSpacing),
//            translationLabel.trailingAnchor.constraint(
//                equalTo: playButton.leadingAnchor,
//                constant: -8),
            
            addButton.topAnchor.constraint(
                equalTo:roundBackgroundView.topAnchor,
                constant: Constraints.addButton.verticacSpacing),
            addButton.bottomAnchor.constraint(
                equalTo: roundBackgroundView.bottomAnchor,
                constant: -Constraints.addButton.verticacSpacing),
            addButton.trailingAnchor.constraint(
                equalTo: roundBackgroundView.trailingAnchor,
                constant: -Constraints.addButton.trailingSpacing),
            
            playButton.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraints.playButton.verticacSpacing),
            playButton.bottomAnchor.constraint(
                equalTo: roundBackgroundView.bottomAnchor,
                constant: -Constraints.playButton.verticacSpacing),
            playButton.trailingAnchor.constraint(
                equalTo: addButton.leadingAnchor,
                constant: -Constraints.playButton.trailingSpacing),
            
        ])
    }
}

//добавить лейблы  и кнопки на ячейки
// при нажатии на кнопки печатать плай и адд
// добавить кнопку "добавить слово" и при нажатии на эту кнопку печатать добавить слово
// подумать как в зависимости от порядка ячейки передавать цвет
