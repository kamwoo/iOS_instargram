//
//  ExploreViewController.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var collectionView: UICollectionView?
    
    private var tabbedSearchCollectionView: UICollectionView?
    
    private var models = [UserPost]()
    
    private let dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabbedSearch()
        configureExploreCollectionView()
        configureDimmedview()
        configureSearchbar()
    }
    
    private func configureTabbedSearch(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        tabbedSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: layout)
        tabbedSearchCollectionView?.isHidden = true
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureDimmedview(){
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancleSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchbar(){
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureExploreCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0,
                                                   y: view.safeAreaInsets.top,
                                                   width: view.width,
                                                   height: 72)
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didTapCancleSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        query(text: text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCancleSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {self.dimmedView.alpha = 0.4}){done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc private func didTapCancleSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {self.dimmedView.alpha = 0}){ done in
            if done{
                self.dimmedView.isHidden = true
            }
        }
    }
    
    private func query(text: String){
        // search to backend
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as? PhotoCollectionViewCell else{
                                                        return UICollectionViewCell()}
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tabbedSearchCollectionView {
            return 
        }
        let user = User(username: "kam",
                        name: (first: "", last:""),
                        birthDate: Date(),
                        gender: .female,
                        bio: "",
                        counts: UserCount(followers: 1, following: 1, post: 1),
                        joinDate: Date(),
                        profilePhoto: URL(string: "https://www.google.com/")!)
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string:"https://www.google.com/")!,
                            postURL: URL(string: "https://www.google.com/")!,
                            caption: nil,
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],
                            owner: user)
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
}
