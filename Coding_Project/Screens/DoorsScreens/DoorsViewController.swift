//
//  DoorsViewController.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/14/23.
//

import UIKit
import SnapKit

    // MARK: - DoorsViewController

class DoorsViewController: BaseViewController {
    
    // MARK: - Layout

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        return tableView
    }()

    private lazy var welcomeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Welcome"
        label.font = CustomFont.getFont(with: 35, and: .bold)

        return label
    }()

    private lazy var myDoorsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "My doors"
        label.textColor = Colors.mainLabel.color
        label.font = CustomFont.getFont(with: 20, and: .bold)

        return label
    }()

    private lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Constants.logoHomeImage

        return iv
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Doors"
        label.textColor = Colors.mainLabel.color
        label.font = CustomFont.getFont(with: 20, and: .bold)

        return label
    }()

    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .custom)

        button.configuration = .plain()
        button.setImage(Constants.iconSettingsImage, for: .normal)
        button.addTarget(self, action: #selector(didTapToSettings), for: .touchUpInside)

        return button
    }()

    
    // MARK: - Properties
    
    private let navigator: NavigatorProtocol
    
    private let doorsData: DoorsTableViewDataSourceProtocol = DoorsData()
    
    // MARK: - Init

    init(navigator: NavigatorProtocol) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        getMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Private Extension

private extension DoorsViewController {
    @objc
    func didTapToSettings() {
        
    }
}

// MARK: - Private MapKit Extension

private extension DoorsViewController {
    func getMockData() {
        tableView.showActivityIndicator()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tableView.layer.opacity = 0
            self?.doorsData.getMockDate()
            self?.tableView.reloadData()
            self?.tableView.hideActivityIndicatorView()

            UIView.animate(withDuration: 1) {
                self?.tableView.layer.opacity = 1
            }
        }
    }
    func setupUI() {
        view.backgroundColor = .white

        tableView.registerCellProgramically(type: DoorCell.self)
        tableView.showsVerticalScrollIndicator = false
    }

    func setupLayout() {
        view.addSubview(appNameLabel)
        view.addSubview(settingButton)
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(myDoorsLabel)
        view.addSubview(tableView)

        appNameLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.width.equalTo(86)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerY.equalTo(settingButton.snp.centerY)
        }

        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
            $0.height.width.equalTo(45)
        }

        logoImageView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom)
            $0.trailing.equalToSuperview()
        }

        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp.bottom).inset(-63)
            $0.leading.equalToSuperview().inset(24)
        }

        myDoorsLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).inset(-31)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(myDoorsLabel.snp.bottom).inset(-26)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - TableViewDataSource & TableViewDelegate

extension DoorsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doorsData.countDoors
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: DoorCell.self, for: indexPath) as! DoorCell
        var door = doorsData.getDoor(with: indexPath.row)

        cell.config(with: door)
        cell.actionClosusre = {  [weak self] action in
            self?.handleAction(with: action, door: &door, tableView: tableView, indexPath: indexPath)
        }

        return  cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    private func handleAction(
        with type: DoorCellAction,
        door: inout Door,
        tableView: UITableView,
        indexPath: IndexPath
    ) {
        switch type {
        case .unlock:
            tableView.performBatchUpdates {
                door.changeDoorStatus()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

