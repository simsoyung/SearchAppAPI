//
//  DetailViewController.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: UIViewController {
    
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
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        return button
    }()
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.text = "새로운 소식"
        return label
    }()
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let textView1: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 15, weight: .regular)
        text.textColor = .black
        return text
    }()
    let textView2: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 15, weight: .regular)
        text.textColor = .black
        return text
    }()
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let disposeBag = DisposeBag()
    let detailViewModel = DetailViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
    private func configureView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [appNameLabel, appIconImageView, subLabel, downloadButton, headerLabel, versionLabel, collectionView, textView1, textView2].forEach {
            contentView.addSubview($0) }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        appIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(100)
        }
        appNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.height.equalTo(24)
        }
        subLabel.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp.bottom).offset(16)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.height.equalTo(16)
        }
        downloadButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(8)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(16)
        }
        textView1.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textView1.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(350)
        }
        textView2.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
        textView1.isEditable = false
        textView2.isEditable = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
    func configure(data: [App]) {
        detailViewModel.updateAppData(data: data)
    }
    private func bind() {
        detailViewModel.appData
            .subscribe(with: self ) { owner, value in
                guard let data = value.first else { return }
                if let url = URL(string: data.artworkUrl60) {
                    owner.appIconImageView.kf.setImage(with: url)
                }
                owner.appNameLabel.text = data.trackName
                owner.subLabel.text = data.artistName
                owner.versionLabel.text = "버전 \(data.version)"
                owner.textView1.text = data.releaseNotes
                owner.textView2.text = data.description
            }
            .disposed(by: disposeBag)
        
        detailViewModel.screenshots
            .bind(to: collectionView.rx.items(cellIdentifier: CustomCollectionViewCell.identifier, cellType: CustomCollectionViewCell.self)) { row, data, cell in
                if let url = URL(string: data) {
                    cell.imageView.kf.setImage(with: url)
                }
            }
            .disposed(by: disposeBag)
    }
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let totalSpacing = (spacing * 2) + (spacing * 2)
        let itemWidth = (screenWidth - totalSpacing) / 1.5
        layout.itemSize = CGSize(width: itemWidth, height: 350)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}
