//
//  UIView.swift
//  AdBannerDemo
//
//  Created by Wang Sheng Ping on 2021/5/8.
//

import UIKit
import SnapKit

class MainView: UIView {

    //MARK: - IBOutlets
    
    let mytableView: UITableView = {
        let tv = UITableView()
        tv.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Add Subviews
    
    func setSubviews() {
        self.addSubview(mytableView)
    }
    
    //MARK: - Set Layouts

    func setLayouts() {
        mytableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
}
