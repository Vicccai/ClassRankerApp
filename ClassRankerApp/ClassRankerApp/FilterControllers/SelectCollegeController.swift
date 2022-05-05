//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/5/22.
//

import UIKit
import SwiftUI

class SelectCollegeController: UIViewController, ObservableObject {
    let controller = self
    
    let contentView = UIHostingController(rootView: SelectCollegeView(selected: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.present = {
            let vc = SelectDistrController()
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion: nil)
        }
        view.addSubview(contentView.view)
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
}

extension SelectCollegeController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            let presenter = SelectCollegePresentation(presentedViewController: presented, presenting: presenting)
            presenter.blur = 0
            return presenter
        }
}

struct SelectCollegeView: View {
    
    var present: (() -> Void)?
    
    let colleges: [String] = [
        "Arts & Sciences",
        "Art, Architecture & Planning",
        "Engineering",
        "Agirculture and Life Sciences",
        "Human Ecology",
        "Industrial and Labor Relations",
        "Law",
        "Veterinary Medicine"
    ]
    
    @State var selected: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Select College")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            ForEach(colleges, id: \.self) { college in
                HStack {
                    Button {
                        self.selected = college
                        self.present?()
                    } label: {
                        if college == selected {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                        } else {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 10, height: 10)
                        }
                    }
                    Text(college)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        
    }
}
