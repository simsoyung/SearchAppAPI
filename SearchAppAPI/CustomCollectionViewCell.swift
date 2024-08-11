//
//  CustomCollectionViewCell.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/10/24.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "노량")
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
