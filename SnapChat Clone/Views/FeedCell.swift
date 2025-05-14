//
//  FeedCell.swift
//  SnapChat Clone
//
//  Created by XECE on 13.05.2025.
//

import UIKit
import SDWebImage

class FeedCell: UITableViewCell {

    let feedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit // Resmin boyutunu düzgün ayarla
        iv.clipsToBounds = true
        return iv
    }()
    
    let feedUserNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 24) // Kalın font
        lbl.font = UIFont.italicSystemFont(ofSize: 20) // İtalik font
        lbl.textColor = UIColor.systemGreen
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(feedUserNameLabel)
        contentView.addSubview(feedImageView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(feedUserNameLabel)
        contentView.addSubview(feedImageView)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            feedUserNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            feedUserNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            feedUserNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            feedImageView.topAnchor.constraint(equalTo: feedUserNameLabel.bottomAnchor, constant: 8),
            feedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedImageView.heightAnchor.constraint(equalToConstant: 250), // Resmin yüksekliği
            feedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.image = nil
        feedUserNameLabel.text = ""
    }

    func configure(with snap: Snap) {
        feedUserNameLabel.text = snap.username
        if let urlString = snap.imageUrlArray.first,
           let url = URL(string: urlString) {
            feedImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        }
    }
}
