//
//  SelectDistrController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/5/22.
//

import UIKit
import SwiftUI

class SelectDistrController: UIViewController {
    
    weak var delegate: RankViewController?
    
    var selectedCollege: String?
    
    let contentView = UIHostingController(rootView: SelectDistrView(selected: Set()))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.distributions = FilterData.distributions[selectedCollege!]
        contentView.rootView.dismiss = {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
        contentView.rootView.update = { distr in
            self.delegate?.selectedDistr = distr
        }
        contentView.rootView.updateMatchAll = { bool in
            self.delegate?.matchAll = bool
        }
        contentView.rootView.college = selectedCollege
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
    var distributions: [String]?
    
    var college: String?
    
    var dismiss: (() -> Void)?
    
    var update: (([String]) -> Void)?
    
    var updateMatchAll: ((Bool) -> Void)?
    
    @State var selected: Set<String>
    
    @State var all: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Distributions")
                    .font(Font.custom("Proxima Nova Regular", size: 15))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    let abbrev = FilterData.abbrev[college!]!
                    let distr = selected.map { "\($0)-\(abbrev)" }
                    update!(distr)
                    updateMatchAll!(all)
                    self.dismiss?()
                } label: {
                    Text("Done")
                }
            }
            .padding(.horizontal)
            Picker("Hello", selection: $all) {
                Text("Match All").tag(true)
                Text("Match Any").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            ForEach(distributions!, id: \.self) { distribution in
                HStack {
                    Button {
                        if (self.selected.contains(distribution)) {
                            self.selected.remove(distribution)
                        } else {
                            self.selected.insert(distribution)
                        }
                    } label: {
                        if selected.contains(distribution) {
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
                        .font(Font.custom("Proxima Nova Regular", size: 15))
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        
    }
}
