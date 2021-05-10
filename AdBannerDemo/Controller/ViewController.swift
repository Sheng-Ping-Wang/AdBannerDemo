//
//  ViewController.swift
//  AdBannerDemo
//
//  Created by Wang Sheng Ping on 2021/5/8.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties
    
    let fullSizeWidth = UIScreen.main.bounds.width
    let mainView = MainView()
    var bannerViews: [UIImageView] = []
    var mySections: [MySections] = [.banner, .others]
    var timer = Timer()
    var xOffset: CGFloat = 0
    var currentPage = 0 {
        didSet{
            xOffset = fullSizeWidth * CGFloat(self.currentPage)
            mainView.mytableView.reloadData()
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.mytableView.delegate = self
        mainView.mytableView.dataSource = self
        setTimer()
    }
    
    //MARK: - Functions
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(swipeLeft), userInfo: nil, repeats: true)
    }

    @objc func swipeLeft() {
        self.currentPage += 1
        if self.currentPage > bannerViews.count - 1 {
            self.currentPage = 0
        }
    }

    func swipeRight() {
        self.currentPage -= 1
        if currentPage < 0 {
            currentPage = bannerViews.count - 1
        }
    }

    @objc func pageControlDidTap() {
        timer.invalidate()
        swipeLeft()
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch mySections[section] {
        case .banner:
            return 1
        case .others:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mySections[indexPath.section] {
        case .banner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
            
            self.bannerViews = cell.bannerViews
            cell.myScrollView.delegate = self
            cell.pageControl.currentPage = self.currentPage
            cell.pageControl.addTarget(self, action: #selector(pageControlDidTap), for: .touchUpInside)
            UIView.animate(withDuration: 1) {
                cell.myScrollView.contentOffset.x = self.xOffset
            }
            return cell
            
        case .others:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mySections[indexPath.section] {
        case .banner:
            return 300
        case .others:
            return tableView.estimatedRowHeight
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == mainView.mytableView{
            //do nothing
        }else{
            let translatedPoint = scrollView.panGestureRecognizer.translation(in:scrollView)
            print(translatedPoint.x)
            if translatedPoint.x < 0 {
                swipeLeft()
            }else{
                swipeRight()
            }
            print(currentPage)
        }
    }
}

//MARK: Secntion Enum

extension ViewController {
    enum MySections {
        case banner, others
    }
}
