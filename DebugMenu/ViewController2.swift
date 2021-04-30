//
//  ViewController2.swift
//  DebugMenu
//
//  Created by Renaud Cousin on 4/30/21.
//

import Foundation
import UIKit

class ViewController2: UIViewController {
    private var toggle: Bool = false {
        didSet {
            updateLabel()
        }
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Back to ViewController 1", for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    private lazy var toggleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setup()
        updateLabel()
    }

    private func setup() {
        view.backgroundColor = .systemGreen

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleLabel)

        title = "ViewController 1"

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            toggleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleLabel.centerYAnchor.constraint(equalTo: button.bottomAnchor, constant: 40)
        ])
    }

    private func updateLabel() {
        toggleLabel.text = "Toggle: \(toggle ? "true" : "false")"
    }

    @objc private func didTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewController2: DebugMenuContextualizedDataSource {
    var menuActions: [DebugMenuSection] {
        return [
            DebugMenuSection(title: "ViewController 2 specific",
                                 actions: [
                                    DebugMenuAction(systemImageName: "command.circle",
                                                    label: "Toggle",
                                                    tintColor: .white,
                                                    backgroundColor: .systemIndigo,
                                                    action: {
                                                        self.toggle.toggle()
                                                    }, selectionHandler: {
                                                        return self.toggle
                                                    }),
                                    DebugMenuAction(systemImageName: "trash.circle",
                                                    label: "Delete",
                                                    tintColor: .white,
                                                    backgroundColor: .systemRed,
                                                    action: {
                                                        print("Delete action")
                                                    })
                                 ])]
    }


}
