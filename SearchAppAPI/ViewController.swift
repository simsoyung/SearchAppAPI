//
//  ViewController.swift
//  SearchAppAPI
//
//  Created by 심소영 on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var disposeBag = DisposeBag()
    let viewModel = APIViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func bind(){
        let recentText = PublishSubject<String>()
        let input = APIViewModel.Input(previousSearchText: recentText, searchText: searchBar.rx.text.orEmpty, searchButtonTap: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.appList
            .bind(to: tableView.rx.items(cellIdentifier: TableViewCell.identifier, cellType: TableViewCell.self)){
                (row, element, cell) in
                cell.appNameLabel.text = element.trackName
                let url = URL(string: element.artworkUrl60)
                cell.appIconImageView.kf.setImage(with: url)
                cell.configure(data: element)
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(
//            tableView.rx.modelSelected(String.self),
//            tableView.rx.itemSelected
//        )
//        .debug()
//        .map{ "검색어는 \($0.0), \($0.1)"}
//        .subscribe(with: self) { owenr, value in
//            //print(value)
//            recentText.onNext(value)
//        }
//        .disposed(by: disposeBag)
        tableView.rx.modelSelected(App.self)
            .map{ $0.trackName }
            .subscribe(with: self) { owner, value in
                print("선택된 검색어: \(value)")
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: CollectionViewCell.id, cellType: CollectionViewCell.self)){
                (row, element, cell) in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
    }
    
    func configure(){
        view.backgroundColor = .white
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        view.addSubview(scrollView)
        view.addSubview(searchBar)
        scrollView.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
}

