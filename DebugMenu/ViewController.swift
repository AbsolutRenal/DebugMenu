//
//  ViewController.swift
//  DebugMenu
//
//  Created by Renaud Cousin on 4/30/21.
//

import UIKit

class ViewController: UIViewController {
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Go to ViewController 2", for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setup()
    }

    private func setup() {
        view.backgroundColor = .systemTeal

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        title = "ViewController 1"

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func didTap() {
        self.navigationController?.pushViewController(ViewController2(),
                                                      animated: true)
    }
}

