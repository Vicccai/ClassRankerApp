//
//  SelectLevelController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/6/22.
//

import UIKit
import SwiftUI

class SelectLevelController: UIViewController {
    
    weak var delegate: RankViewController?
    
    let contentView = UIHostingController(rootView: SelectLevelView(selected: 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.levels = FilterData.levels
        contentView.rootView.dismiss = {
            self.presentingViewController?.dismiss(animated: true)
        }
        contentView.rootView.update = { level in
            self.delegate?.selectedLevel = level
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

struct SelectLevelView: View {
    var levels: [String]?
    
    var dismiss: (() -> Void)?
    
    var update: ((Int) -> Void)?
    
    @State var selected: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                HStack {
                    Text("Select Level")
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
                ForEach(levels!, id: \.self) { level in
                    HStack {
                        Button {
                            self.selected = Int(level)!
                        } label: {
                            if Int(level)! == selected {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        Text(level)
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
