// 
//  DebugMenuViewController.swift
//
//  Created by Renaud Cousin on 3/3/21.
//


import Foundation
import UIKit

extension DebugMenuAction {
    static let settings = DebugMenuAction(systemImageName: "slider.horizontal.3",
                                          label: "Settings",
                                          tintColor: .white,
                                          backgroundColor: .systemGray,
                                          action: {
                                            print("Navigate to settings")
                                          })
    static let action1 = DebugMenuAction(systemImageName: "circle.dashed",
                                         label: "Action 1",
                                         action: {
                                            print("Action 1")
                                         })
    static let action2 = DebugMenuAction(systemImageName: "circle.lefthalf.fill",
                                         label: "Action 2",
                                         action: {
                                            print("Action 2")
                                         })
}

final class DebugMenuViewController: UIViewController {
    private enum Constants {
        static let collectionHeight: CGFloat = 80
    }

    private var globalActions: [DebugMenuSection] = [
        DebugMenuSection(title: "Global",
                         actions: [
                            .settings
                         ]),
        DebugMenuSection(title: "Actions",
                         actions: [
                            .action1,
                            .action2
                         ])
    ]
    var contextualizedMenuActions: [DebugMenuSection] = []
    private var menuSections: [DebugMenuSection] {
        return contextualizedMenuActions + globalActions
    }

    private var displayCompletion: (() -> Void)?

    private let backgroundBlur = UIVisualEffectView()
    private lazy var dismissGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        return gesture
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.register(DebugMenuCell.self,
                            forCellWithReuseIdentifier: String(describing: DebugMenuCell.self))
        collection.register(DebugMenuSectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: DebugMenuSectionHeader.self))
        return collection
    }()
    private var displayAnimator: UIViewPropertyAnimator?
    private var observationToken: NSKeyValueObservation?

    override func viewDidLoad() {
        view.backgroundColor = .clear
        setupCollection()
        setupConstraints()
        backgroundBlur.addGestureRecognizer(dismissGesture)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observationToken?.invalidate()
        backgroundBlur.removeGestureRecognizer(dismissGesture)
    }


    // MARK: Public
    func reload() {
        collectionView.reloadData()
    }

    func toggleDisplay(_ visible: Bool,
                       completion: (() -> Void)? = nil) {
        if displayAnimator == nil {
            setupAnimator()
        }
        self.displayCompletion = completion
        displayAnimator?.isReversed = !visible
        displayAnimator?.startAnimation()
    }


    // MARK: Private
    private func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        collectionView.layer.cornerRadius = 20
    }

    private func setupConstraints() {
        view.addSubview(backgroundBlur)
        backgroundBlur.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundBlur.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundBlur.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBlur.topAnchor.constraint(equalTo: view.topAnchor),

            collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionHeight),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func setupAnimator() {
        self.collectionView.transform = CGAffineTransform(translationX: 0,
                                                          y: Constants.collectionHeight + self.view.safeAreaInsets.bottom + 8)
        displayAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                 dampingRatio: 0.7,
                                                 animations: {
                                                    self.backgroundBlur.effect = UIBlurEffect(style: .systemThinMaterialDark)
                                                    self.collectionView.transform = .identity
                                                 })
        displayAnimator?.pausesOnCompletion = true
        observationToken = displayAnimator?.observe(\.isRunning,
                                                    changeHandler: { [unowned self] (animator, change) in
                                                        guard !animator.isRunning else {
                                                            return
                                                        }
                                                        self.displayCompletion?()
                                                        self.displayCompletion = nil
                                                    })
    }

    @objc private func dismissMenu() {
        DebugMenu.shared.toggleDisplay()
    }
}

extension DebugMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = self.collectionView(collectionView,
                                        layout: collectionViewLayout,
                                        insetForSectionAt: indexPath.section)
        let size = collectionView.bounds.size.height - inset.top - inset.bottom
        return CGSize(width: size,
                      height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else {
            return CGSize(width: 1,
                          height: collectionView.bounds.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 8
        return UIEdgeInsets(top: inset,
                            left: inset,
                            bottom: inset,
                            right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = menuSections[indexPath.section].actions[indexPath.row]
        item.action()
        reload()
        DebugMenu.shared.toggleDisplay()
    }
}

extension DebugMenuViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return menuSections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return menuSections[section].actions.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DebugMenuCell.self),
                                                            for: indexPath) as? DebugMenuCell else {
            return UICollectionViewCell()
        }
        let item = menuSections[indexPath.section].actions[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: String(describing: DebugMenuSectionHeader.self),
                                                                      for: indexPath) as? DebugMenuSectionHeader else {
            return UICollectionReusableView()
        }
        let name = menuSections[indexPath.section].title
        v.configure(with: name)
        return v
    }
}

private final class DebugMenuSectionHeader: UICollectionReusableView {
    func configure(with title: String) {
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
}
