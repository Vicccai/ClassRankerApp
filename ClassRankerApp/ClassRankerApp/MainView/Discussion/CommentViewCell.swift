//
//  CommentViewCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/6/22.
//

import Foundation
import UIKit

class CommentViewCell: UITableViewCell {
    
    static let id = "CommentCellId"
    weak var delegate = DiscussionView()
    
    var username: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.font = UIFont(name: "Proxima Nova Bold", size: 14)
        return label
    }()
    
    var comment: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        return label 
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
        return button
    }()
    
    var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
    
        for subView in [username, comment, deleteButton, deleteLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: contentView.topAnchor),
            username.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            comment.topAnchor.constraint(equalTo: username.bottomAnchor),
            comment.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: 5),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: deleteLabel.trailingAnchor, constant: 5),
            
            deleteLabel.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            deleteLabel.leadingAnchor.constraint(equalTo: username.leadingAnchor)
        ])
    }
    
    func configure(comment: Comment) {
        username.text = comment.username
        self.comment.text = comment.comment
    }
    
    @objc func deleteComment() {
//        delegate?.deleteComment(comment: comment.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
