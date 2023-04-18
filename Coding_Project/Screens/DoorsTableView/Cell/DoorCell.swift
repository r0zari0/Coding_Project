//
//  DoorCell.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/17/23.
//

import UIKit

enum DoorCellAction {
    case unlock
}

class DoorCell: UITableViewCell {

    // MARK: Layout

    private lazy var borderView: UIView = {
        let view = UIView()

        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.borderColor.color.cgColor
        view.layer.cornerRadius = 15

        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let iv = UIImageView()

        return iv
    }()

    private lazy var textVStack: UIStackView = {
        let vStack = UIStackView()
        vStack.spacing = 2
        vStack.axis = .vertical

        return vStack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.getFont(with: 16, and: .bold)
        label.textColor = Colors.mainLabel.color

        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.getFont(with: 14, and: .regular)
        label.textColor = Colors.gray.color

        return label
    }()

    private lazy var doorImageView: UIImageView = {
        let iv = UIImageView()
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        iv.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unlockDoor))
        iv.addGestureRecognizer(tapGesture)

        return iv
    }()

    private lazy var lockButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Colors.mainLabel.color, for: .normal)
        button.titleLabel?.font = CustomFont.getFont(with: 15, and: .bold)
        button.addTarget(self, action: #selector(unlockDoor), for: .touchUpInside)

        return button
    }()

    private lazy var circleProgressView: CircleView = {
        let view = CircleView()

        return view
    }()

    // MARK: - Properties

    var actionClosusre: ValueClosure<DoorCellAction>?

    private var unlockTask: Task<Void, Error>?

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        unlockTask?.cancel()
    }


    // MARK: - Methods

    @discardableResult
    func config(with model: Door) -> DoorCell {
        logoImageView.image = UIImage(named: model.status.mainImageName)!
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
        lockButton.setTitle(model.status.text, for: .normal)
        lockButton.layer.opacity = model.status.opacity
        lockButton.isEnabled = model.status.unlockIsEnable
        doorImageView.isUserInteractionEnabled = model.status.unlockIsEnable

        setDoorImage(with: model.status.doorImageName)
        setNextStatusIfNeeded(with: model.status)

        return self
    }
}

// MARK: - Action

private extension DoorCell {
    func setDoorImage(with doorImageName: String) {
        if !doorImageName.isEmpty {
            circleProgressView.isHidden = true
            circleProgressView.layer.removeAnimation(forKey: "rotationAnimation")

            doorImageView.isHidden = false
            doorImageView.image = UIImage(named: doorImageName)
        } else {
            circleProgressView.isHidden = false
            doorImageView.isHidden = true
            circleProgressView.layer.add(createRotationAnimation(), forKey: "rotationAnimation")
        }
    }

    func setNextStatusIfNeeded(with status: Door.DoorStatus) {
        switch status {
        case .locked:
            print("Nothing")
        case .unlocked, .unlocking:
            unlockTask?.cancel()

            unlockTask = Task {
                do {
                    try await Task.sleep(seconds: 3)
                    actionClosusre?(.unlock)
                } catch {
                    print(error)
                }
            }
        }
    }

    @objc
    func unlockDoor() {
        actionClosusre?(.unlock)
    }
}

// MARK: - Private Extension

private extension DoorCell {
    func setupUI() {
        selectionStyle = .none
        doorImageView.isHidden = true
    }

    func createRotationAnimation() -> CABasicAnimation {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity

        return rotationAnimation
    }

    func setupLayout() {
        textVStack.addArrangedSubview(titleLabel)
        textVStack.addArrangedSubview(subTitleLabel)
        
        contentView.addSubview(borderView)
        borderView.addSubview(logoImageView)
        borderView.addSubview(textVStack)
        borderView.addSubview(doorImageView)
        borderView.addSubview(lockButton)
        borderView.addSubview(circleProgressView)

        borderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }

        logoImageView.snp.makeConstraints {
            $0.height.width.equalTo(41)
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalTo(textVStack.snp.leading).inset(-18)
        }

        textVStack.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView.snp.centerY)
            $0.trailing.equalTo(doorImageView.snp.leading).inset(-16)
        }

        doorImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.top.equalToSuperview().inset(18)

        }

        circleProgressView.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(27)
            $0.height.width.equalTo(43)
        }

        lockButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).inset(-14)
            $0.height.equalTo(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
