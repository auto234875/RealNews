//
//  StoriesViewController.swift
//  Real News
//
//  Created by John Smith on 12/30/16.
//  Copyright © 2016 John Smith. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TableViewTag:Int{
    case searchTableView = 1
    case storiesTableView = 2
}
class StoriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate{
    var searchBarHeight:CGFloat {
        return 44.0 + padding.cellDouble.rawValue
    }
    static let purchased = Variable(false)
    let inAppPurchaseView = UIView()
    let inAppPurchaseGestureRecognizer = UITapGestureRecognizer()
    var order = SearchOrder.popular
    let activityIndicator = UIActivityIndicatorView()
    let searchStatusLabel = UILabel()
    let searchTableView = UITableView()
    let searchBar = HNSearchBar()
    var searchDisposable:Disposable!
    var searchPage:Int = 0
    var searchStories:[StoryCellViewModel?] = [StoryCellViewModel?]()
    var savedStoriesID:[Int]?
    var originFrame:CGRect?
    var Stories:[StoryCellViewModel?] = [StoryCellViewModel?]()
    let disposeBag = DisposeBag()
    let storiesTableView = UITableView()
    let refreshControl = UIRefreshControl()
    var storyDisposable:Disposable!
    var storiesType:StoriesType? {
        didSet{
            title = storiesType!.title
            tabBarItem.image = storiesType!.icon
            
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        searchStatusLabel.textAlignment = .center
        searchStatusLabel.text = "Nothing found"
        searchStatusLabel.font = UIFont.standard
        searchStatusLabel.textColor = UIColor.lightAppTextColor
        searchStatusLabel.backgroundColor = UIColor.clear
        searchStatusLabel.frame = .zero
        storiesTableView.tag = TableViewTag.storiesTableView.rawValue
        storiesTableView.tableFooterView = UIView()
        storiesTableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        storiesTableView.backgroundColor = UIColor.clear
        view.addSubview(storiesTableView)
        
        searchTableView.tag = TableViewTag.searchTableView.rawValue
        searchTableView.tableFooterView = searchStatusLabel
        searchTableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.backgroundColor = UIColor.clear
        activityIndicator.color = UIColor.lightAppTextColor
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)
        storyDisposable = loadStories()
        refreshControl.tintColor = UIColor.appTextColor
        storiesTableView.addSubview(refreshControl)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.storyDisposable.dispose()
                self.Stories.removeAll()
                self.storiesTableView.reloadData()
                self.storyDisposable = self.loadStories()
                self.refreshControl.endRefreshing()
            })
        }).addDisposableTo(disposeBag)
        
        searchBar.searchOptionTitle.value = "SORT BY"
        searchBar.addGestureRecognizer(inAppPurchaseGestureRecognizer)
        inAppPurchaseGestureRecognizer.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
                getInfo(.autoRenewablePurchase, self: self)
            
        }).addDisposableTo(disposeBag)

        StoriesViewController.purchased.asObservable().subscribe(onNext:{[unowned self](purchased)->Void in
            if purchased{
                self.searchBar.removeGestureRecognizer(self.inAppPurchaseGestureRecognizer)
                self.searchBar.enable.value = true
            }
        }).addDisposableTo(disposeBag)
        
        let dismissKeyBoard = UITapGestureRecognizer()
        dismissKeyBoard.cancelsTouchesInView = false
        searchTableView.addGestureRecognizer(dismissKeyBoard)
        dismissKeyBoard.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
            self.searchBar.pause.value = false
        }).addDisposableTo(disposeBag)
        
        let resetSearchBar = UITapGestureRecognizer()
        resetSearchBar.cancelsTouchesInView = false
        storiesTableView.addGestureRecognizer(resetSearchBar)
        resetSearchBar.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
            if self.searchBar.showSearchSettings.value{
                self.searchBar.showSearchSettings.value = false
            }
        }).addDisposableTo(disposeBag)
        
        searchBar.searchOrder.asObservable().subscribe(onNext:{[unowned self](searchOrder)->Void in
            self.order = searchOrder
        }).addDisposableTo(disposeBag)
        searchBar.isActive.asObservable().subscribe(onNext:{[unowned self](isActive)->Void in
            if isActive {
                self.storiesTableView.removeFromSuperview()
                self.view.addSubview(self.searchTableView)
            }else{
                self.searchTableView.removeFromSuperview()
                self.view.addSubview(self.storiesTableView)
                self.searchStories.removeAll()
                self.searchTableView.reloadData()
                }
        }).addDisposableTo(disposeBag)
        
        setupSearch()
        
        
    }
    private func setupSearch(){
        
        searchBar.text.asObservable().map({[unowned self](text)->Observable<StoryCellViewModel?> in
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.searchTableView.tableFooterView!.frame = .zero
                self.activityIndicator.stopAnimating()
            })
            guard let observable = searchStory(cellWidth: self.view.bounds.width - padding.cell.rawValue*2, searchTerm: text, order: self.order) else{
                return Observable.empty()
            }
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.activityIndicator.startAnimating()
            })
            return observable
        }).flatMapLatest({[unowned self]observable -> Observable<StoryCellViewModel?> in
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.searchStories.removeAll()
                self.searchTableView.reloadData()
            })
            return observable
        }).subscribe(onNext:{[unowned self](story:StoryCellViewModel?)->Void in
            guard let unwrappedStory = story else{
                if self.searchStories.isEmpty{
                    DispatchQueue.main.async(execute: {[unowned self]()->Void in
                        self.searchTableView.tableFooterView!.frame = self.searchTableView.frame
                        self.activityIndicator.stopAnimating()
                    })
                }else{
                    DispatchQueue.main.async(execute: {[unowned self]()->Void in
                        self.searchTableView.tableFooterView!.frame = .zero
                    })
                }
                return
            }
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.searchTableView.tableFooterView!.frame = .zero
                self.activityIndicator.stopAnimating()
                self.searchStories.append(unwrappedStory)
                self.searchTableView.reloadData()
            })
            },onError:{[unowned self] error in
                self.setupSearch()
            }).addDisposableTo(disposeBag)
    }
    func loadStories()->Disposable{
        self.activityIndicator.startAnimating()
        let storyDisposable = newStory(cellWidth: UIScreen.main.bounds.width - padding.cell.rawValue*2,type:storiesType!).subscribe(onNext:{(story:StoryCellViewModel?)->Void in
            guard let unwrappedStory = story else{
                return
            }
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                self.Stories.insert(story, at: unwrappedStory.story.index)
                self.storiesTableView.reloadData()
            })
        })
        return storyDisposable
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        activityIndicator.center = view.center
        searchBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: searchBarHeight)

        let searchTableViewHeight = view.bounds.height - (searchBarHeight + tabBarController!.tabBar.frame.height)
        searchTableView.frame = CGRect(x:0,y:searchBar.frame.maxY,width:view.bounds.width,height:searchTableViewHeight)
        storiesTableView.frame = searchTableView.frame
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == TableViewTag.storiesTableView.rawValue ? Stories.count : searchStories.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! StoryCell
        let viewModel = tableView.tag == TableViewTag.storiesTableView.rawValue ? Stories[indexPath.row]! : searchStories[indexPath.row]!
        
        cell.titleLabel.attributedText = viewModel.titleAttributedText
        cell.authorLabel.attributedText = viewModel.authorAttributedText
        cell.timeLabel.attributedText = viewModel.timeAttributedText
        cell.commentButton.setAttributedTitle(viewModel.commentCount, for: .normal)
        cell.commentButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            let cellRect = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y + self.searchBarHeight).intersection(tableView.frame)
            self.presentCommentViewController(cellRect: cellRect, story: viewModel.story)
        }).addDisposableTo(cell.disposeBag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell") else{
            return StoryCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.tag == TableViewTag.storiesTableView.rawValue ? Stories[indexPath.row]!.rowHeight : searchStories[indexPath.row]!.rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = tableView.tag == TableViewTag.storiesTableView.rawValue ? Stories[indexPath.row]! : searchStories[indexPath.row]!

        let cellRect = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y + searchBarHeight).intersection(tableView.frame)
        
        guard let url = viewModel.story.url else{
            presentCommentViewController(cellRect: cellRect, story: viewModel.story)
            return
        }
        
        let destination = StoryWebBrowserViewController()
        destination.url = url
        destination.story = viewModel.story
        let transitioningDelegate = self.tabBarController! as! SimpleTabBarViewController
        transitioningDelegate.originFrame = cellRect
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = UIModalPresentationStyle.custom
        present(destination, animated: true, completion: nil)
    }
    func presentCommentViewController(cellRect:CGRect,story:Story){
        let commentVC = CommentViewController()
        commentVC.story = story
        commentVC.showStory = true
        let transitioningDelegate = self.tabBarController! as! SimpleTabBarViewController
        transitioningDelegate.originFrame = cellRect
        commentVC.transitioningDelegate = transitioningDelegate
        self.present(commentVC, animated: true, completion: nil)
    }
    
}
