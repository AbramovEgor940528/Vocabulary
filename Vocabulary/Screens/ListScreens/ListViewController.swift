import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - Properties
    private let colours = [
        UIColor.systemYellow,
        UIColor.systemGreen,
        UIColor.systemPink,
        UIColor.systemBlue,
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
            static let topSpacing: CGFloat = 20
        }
    }
    
    private var words: [WordModel] = []
    
    // MARK: - UI Components
    
    private lazy var addWordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedString.buttonTitle, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Layout.AddButton.cornerRadius
        let action = UIAction { _ in
            let vc = AddWordViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            print("Нажали кнопку добавить слово")
        }
        button.addAction (action, for: .touchUpInside)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readWords()
        tableView.reloadData()
        print(CoreDataStack.shared.readWords())
        print("Элементы ", CoreDataStack.shared.readWords().count )
    }
    
    // MARK: - Data Operations
    
    private func readWords() {
        let wordEntities: [WordEntity] = CoreDataStack.shared.readWords()
        words = wordEntities.map {
            WordModel(
                word: $0.word ?? "N/A",
                transcription: $0.transcription ?? "N/A",
                translation: $0.translation ?? "N/A"
            )
        }
    }
    
    // MARK: - UI Configuration
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(addWordButton)
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
                equalTo: view.safeAreaLayoutGuide.topAnchor
             //*   constant: Layout.TableViewConstraints.TopSpacing
            ),
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
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "\(ListTableViewCell.self)")
    }
    
    private func setupView() {
        addSubviews()
        makeConstraints()
        setupNavBar()
        view.backgroundColor = .systemBackground
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func didTapCell(at index: Int) {
        print("Индекс ячейки \(index)")
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
//            guard let self else { return }
//            
//            let deletedElement = self.words.remove(at: indexPath.row)
//            
//            CoreDataStack.shared.deleteWord(word: deletedElement.word)
//            
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//            completion(true)
//        }
//    
//        deleteAction.backgroundColor = .systemRed
//        deleteAction.image = UIImage(systemName: "trash.fill")
//        
//        
//        let config = UISwipeActionsConfiguration(actions: [deleteAction])
//        config.performsFirstActionWithFullSwipe = true
//        
//        return config
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            let deletedElement = self?.words.remove(at: indexPath.row)
            
            CoreDataStack.shared.deleteWord(word: deletedElement!.word)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        // Получаем размер ячейки
        let cell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
        let cellHeight = cell.bounds.height
        
        // Создаем view для кнопки (ширина 60, высота как у ячейки)
        let actionSize = CGSize(width: 60, height: cellHeight ) // -8 для небольших отступов
        deleteAction.image = UIGraphicsImageRenderer(size: actionSize).image { _ in
            makeDeleteActionView(size: actionSize).drawHierarchy(in: CGRect(origin: .zero, size: actionSize), afterScreenUpdates: true)
        }
        
        // Настройка фона (прозрачный, так как используем кастомное view)
        deleteAction.backgroundColor = .systemBackground
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    private func makeDeleteActionView(size: CGSize) -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        view.backgroundColor = .systemRed
        
        let imageView = UIImageView(image: UIImage(systemName: "trash.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds.insetBy(dx: 0, dy: 10) // Отступы сверху/снизу
        
        view.addSubview(imageView)
        view.layer.cornerRadius = 12 // Закругление углов
        view.layer.masksToBounds = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell
        else {
            return UITableViewCell()
        }
        
        configCell(cell: cell, dataSource: words[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    private func configCell(cell: ListTableViewCell, dataSource: WordModel, index: Int) {
        cell.configCell(
            model:
                ListTableViewCell
                .Model(
                    word: dataSource.word,
                    transcription: dataSource.transcription,
                    translation: dataSource.translation,
                    backgroundColour: getbackgroundColour(
                        index
                    )
                )
        )
        
        cell.addActionCallback = {
            print("Ячейка с индексом \(index). Кнопка - Добавить")
        }
        cell.playActionCallback = {
            print("Ячейка с индексом \(index). Кнопка - Воспроизвести")
        }
    }
    
    private func getbackgroundColour(_ index: Int) -> UIColor {
        return colours[index % colours.count]
    }
}
