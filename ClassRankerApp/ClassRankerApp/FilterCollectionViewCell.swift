//
//  FilterCollectionViewCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/4/22.
//

import Foundation
import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let id = "FilterCellId"
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    var filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-Regular", size: 15)
        label.textColor =  UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        for subView in [backView, filterLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            filterLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            filterLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
            filterLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            filterLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(filter: String) {
        filterLabel.text = filter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
