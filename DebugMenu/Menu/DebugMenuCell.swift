// 
//  DebugMenuCell.swift
//
//  Created by Renaud Cousin on 3/3/21.
//


import Foundation
import UIKit

final class DebugMenuCell: UICollectionViewCell {
    private lazy var imageBackground: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var iconView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var itemTintColor: UIColor?
    private var itemBackgroundColor: UIColor?

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = nil
    }

    func configure(with item: DebugMenuAction) {
        itemTintColor = item.tintColor
        itemBackgroundColor = item.backgroundColor

        iconView.image = item.icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = item.label

        setSelectedState(item.selectionHandler())
    }

    func setSelectedState(_ selected: Bool) {
        iconView.tintColor = selected ? itemBackgroundColor : itemTintColor
        imageBackground.backgroundColor = selected ? itemTintColor : itemBackgroundColor
    }

    override func layoutSubviews() {
        if iconView.superview == nil {
            setupLayout()
        }
        super.layoutSubviews()
        imageBackground.layer.cornerRadius = imageBackground.bounds.width * 0.5
        imageBackground.layoutIfNeeded()
    }

    private func setupLayout() {
        contentView.addSubview(imageBackground)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)

        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let imageInset: CGFloat = 8

        NSLayoutConstraint.activate([
            imageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBackground.widthAnchor.constraint(equalTo: imageBackground.heightAnchor),
            imageBackground.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/4),
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor),

            iconView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor),
            iconView.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: imageInset),
            iconView.leadingAnchor.constraint(equalTo: imageBackground.leadingAnchor, constant: imageInset),

            titleLabel.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
