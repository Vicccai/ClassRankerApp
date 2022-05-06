//
//  DropDownContainer.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/29/22.
//

import UIKit
import iOSDropDown

class DropDownContainer: UIView {

    private let padding: CGFloat = 5

    var dropDown: DropDown = {
        let dropdown = DropDown()
        dropdown.arrowSize = 20
        dropdown.arrowColor = .clear
        dropdown.font = .systemFont(ofSize: 12)
        dropdown.tintColor = .systemGray
        dropdown.selectedRowColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.2)
        dropdown.cornerRadius = 15
        dropdown.checkMarkEnabled = false
        return dropdown
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Triangle")
        image.alpha = 0.4
        return image
    }()

    init(placeholder: String, optionArray: [String]) {
        super.init(frame: CGRect())
        dropDown.placeholder = placeholder + "     "
        dropDown.optionArray = optionArray

        for subView in [dropDown, image] {
            addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        backgroundColor = .systemBackground

        layer.borderWidth = 0.8
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 15

        dropDown.listWillDisappear {
            self.dropDown.resignFirstResponder()
        }

        setAnimations(for: dropDown)

        setupConstraints()

    }

    func setAnimations(for: DropDown) {
        // set animations for little arrow
        dropDown.listWillAppear {
            UIView.animate(withDuration: 0.5) {
                self.image.transform = self.image.transform.rotated(by: .pi)
            }
        }
        dropDown.listWillDisappear {
            UIView.animate(withDuration: 0.5, delay: 0.2) {
                self.image.transform = self.image.transform.rotated(by: .pi)
            }
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            dropDown.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2*padding),
            dropDown.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dropDown.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            dropDown.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2*padding),

            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2*padding),
            image.centerYAnchor.constraint(equalTo: dropDown.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 12),
            image.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
