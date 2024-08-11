//
//  TableViewCell.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    var disposeBag = DisposeBag()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    let collectionView: UICollectionView
    
    var screenshots: [String] = [] {
        didSet {
            bind()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let totalSpacing = (spacing * 2) + (spacing * 2)
        let itemWidth = (screenWidth - totalSpacing) / 3
        layout.itemSize = CGSize(width: itemWidth, height: 250)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configure()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private func configure() {
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        contentView.addSubview(collectionView)
        appIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }

        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    private func bind(){
        Observable.just(screenshots)
            .bind(to: collectionView.rx.items(cellIdentifier: CustomCollectionViewCell.identifier, cellType: CustomCollectionViewCell.self)) { row, element, cell in
                if let url = URL(string: element) {
                    cell.imageView.kf.setImage(with: url)
                }
            }
            .disposed(by: disposeBag)
    }
}



