//
//  SelectDistrController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/5/22.
//

import UIKit
import SwiftUI

class SelectDistrController: UIViewController {
    
    let contentView = UIHostingController(rootView: SelectDistrView(selected: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.dismiss = {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
        view.addSubview(contentView.view)
        setupConstraints()
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

struct SelectDistrView: View {
    let distributions: [String] = [
        "ALC",
        "BIO",
        "ETM",
        "GLC",
        "HST",
        "PHS",
        "SCD",
        "SDS"
    ]
    
    var dismiss: (() -> Void)?
    
    @State var selected: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Distributions")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    self.dismiss?()
                } label: {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            ForEach(distributions, id: \.self) { distribution in
                HStack {
                    Button {
                        self.selected = distribution
                    } label: {
                        if distribution == selected {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                        } else {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 10, height: 10)
                        }
                    }
                    Text(distribution)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        
    }
}
