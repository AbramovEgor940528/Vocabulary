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
    
    private enum Constraint {
        enum RoundBackgroundView {
            static let lateralSpacing: CGFloat = 8
            static let verticalSpacing: CGFloat = 4
            static let height: CGFloat = 120
        }
        enum WordLabel {
            static let topSpacing: CGFloat = 40
            static let bottomSpacing: CGFloat = 60
            static let leadingSpacing: CGFloat = 16
            static let trailingSpacing: CGFloat = 8
        }
        enum TranscriptionLabel {
            static let topSpacing: CGFloat = 42
            static let bottomSpacing: CGFloat = 64
            static let lateralSpacing: CGFloat = 8
        }
        enum TranslationLabel {
            static let topSpacing: CGFloat = 0
            static let trailingSpacing: CGFloat = 8
            static let leadingSpacing: CGFloat = 16
        }
        enum AddButton {
            static let side: CGFloat = 40
            static let trailingSpacing: CGFloat = 12
        }
        enum PlayButton {
            static let side: CGFloat = 40
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
//        let action = UIAction { _ in
//        print("Нажали кнопку добавить")
//        }
//        button.addAction (action, for: .touchUpInside)
        
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
        contentView.isUserInteractionEnabled = false
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
        wordLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            roundBackgroundView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constraint.RoundBackgroundView.verticalSpacing),
            roundBackgroundView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constraint.RoundBackgroundView.verticalSpacing),
            roundBackgroundView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constraint.RoundBackgroundView.lateralSpacing),
            roundBackgroundView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constraint.RoundBackgroundView.lateralSpacing),
            roundBackgroundView.heightAnchor.constraint(
                equalToConstant: Constraint.RoundBackgroundView.height),
            
            wordLabel.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraint.WordLabel.topSpacing),
            wordLabel.leadingAnchor.constraint(
                equalTo: roundBackgroundView.leadingAnchor,
                constant: Constraint.WordLabel.leadingSpacing),
            wordLabel.trailingAnchor.constraint(
                equalTo: transcriptionLabel.leadingAnchor,
                constant: -Constraint.WordLabel.trailingSpacing),
            
            transcriptionLabel.topAnchor.constraint(
                equalTo: roundBackgroundView.topAnchor,
                constant: Constraint.TranscriptionLabel.topSpacing),
            transcriptionLabel.leadingAnchor.constraint(
                equalTo: wordLabel.trailingAnchor,
                constant: Constraint.TranscriptionLabel.lateralSpacing),
            transcriptionLabel.trailingAnchor.constraint(
                equalTo: playButton.leadingAnchor,
                constant: -Constraint.TranscriptionLabel.lateralSpacing),
            transcriptionLabel.lastBaselineAnchor.constraint(
                equalTo: wordLabel.lastBaselineAnchor),
            
            translationLabel.topAnchor.constraint(
                equalTo: wordLabel.bottomAnchor,
                constant: Constraint.TranslationLabel.topSpacing),
            translationLabel.leadingAnchor.constraint(
                equalTo: roundBackgroundView.leadingAnchor,
                constant: Constraint.TranslationLabel.leadingSpacing),
            translationLabel.trailingAnchor.constraint(
                equalTo: playButton.leadingAnchor,
                constant: -Constraint.TranslationLabel.trailingSpacing),
            
            playButton.heightAnchor.constraint(
                equalToConstant: Constraint.PlayButton.side),
            playButton.widthAnchor.constraint(
                equalToConstant: Constraint.PlayButton.side),
            playButton.centerYAnchor.constraint(
                equalTo: roundBackgroundView.centerYAnchor),
            playButton.trailingAnchor.constraint(
                equalTo: addButton.leadingAnchor,
                constant: -Constraint.PlayButton.trailingSpacing),
            
            addButton.heightAnchor.constraint(
                equalToConstant: Constraint.AddButton.side),
            addButton.widthAnchor.constraint(
                equalToConstant: Constraint.AddButton.side),
            addButton.centerYAnchor.constraint(
                equalTo: roundBackgroundView.centerYAnchor),
            addButton.trailingAnchor.constraint(
                equalTo: roundBackgroundView.trailingAnchor,
                constant: -Constraint.AddButton.trailingSpacing)
        ])
    }
}
