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
    weak var delegate: DiscussionView?
    var comment: Comment?
    
    var username: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        label.font = UIFont(name: "Proxima Nova Bold", size: 14)
        return label
    }()
    
    var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 12)
        return label
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        deleteButton.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
        for subView in [username, commentLabel, deleteButton, deleteLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            username.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            commentLabel.topAnchor.constraint(equalTo: username.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            deleteButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: -10),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            deleteLabel.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            deleteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configure(comment: Comment) {
        self.comment = comment
        username.text = comment.username
        commentLabel.text = comment.description
        if Globals.guest.boolValue ==  true {
            deleteButton.isHidden = true
            deleteLabel.isHidden = true
        }
        else if Globals.user.username != comment.username {
            deleteButton.isHidden = true
            deleteLabel.isHidden = true
        }
        else {
            deleteButton.isHidden = false
            deleteLabel.isHidden = false
        }
    }
    
    @objc func deleteComment() {
        delegate?.deleteComment(comment: comment!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
