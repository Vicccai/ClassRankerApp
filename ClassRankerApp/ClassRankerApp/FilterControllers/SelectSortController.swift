//
//  SelectSortController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/6/22.
//

import UIKit
import SwiftUI

class SelectSortController: UIViewController {
    
    weak var delegate: RankViewController?
    
    let contentView = UIHostingController(rootView: SelectSortView(selected: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.sorts = FilterData.sort
        contentView.rootView.dismiss = {
            self.presentingViewController?.dismiss(animated: true)
        }
        contentView.rootView.update = { sort in
            self.delegate?.selectedSort = sort
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

struct SelectSortView: View {
    var sorts: [String]?
    
    var dismiss: (() -> Void)?
    
    var update: ((String) -> Void)?
    
    @State var selected: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                HStack {
                    Text("Sort by...")
                        .font(Font.custom("Proxima Nova Bold", size: 17))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        self.update!(selected)
                        self.dismiss?()
                    } label: {
                        Text("Done")
                    }
                }
                .padding(.horizontal)
                ForEach(sorts!, id: \.self) { sort in
                    HStack {
                        Button {
                            self.selected = sort
                        } label: {
                            if sort == selected {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        Text(sort)
                            .foregroundColor(.white)
                            .font(Font.custom("Proxima Nova Regular", size: 17))
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}
