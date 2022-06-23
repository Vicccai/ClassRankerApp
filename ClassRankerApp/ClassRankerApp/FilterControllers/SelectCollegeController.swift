//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/5/22.
//

import UIKit
import SwiftUI

class SelectCollegeController: UIViewController, ObservableObject {
    
    weak var delegate: RankViewController?
    
    var nextFrameHeight : CGFloat = 0
    
    let contentView = UIHostingController(rootView: SelectCollegeView(selected: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.backgroundColor = .gray
        contentView.rootView.present = { college in
            let vc = SelectDistrController()
            vc.selectedCollege = college
            vc.delegate = self.delegate
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion: nil)
        }
        contentView.rootView.setHeight = { height in
            self.nextFrameHeight = height
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
        let presenter = SelectMenuPresentation(presentedViewController: presented, presenting: presenting)
        presenter.height = self.nextFrameHeight
        presenter.blur = 0
        return presenter
    }
}

struct SelectCollegeView: View {
    
    var present: ((String) -> Void)?
    
    var setHeight: ((CGFloat) -> Void)?
    
    let colleges = FilterData.colleges
    
    @State var selected: String
    
    var body: some View {
        ScrollView{
            VStack(spacing: 5){
                HStack {
                    Text("Select College")
                        .font(Font.custom("Proxima Nova Bold", size: 17))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                ForEach(colleges, id: \.self) { college in
                    HStack {
                        Button {
                            self.selected = college
                            self.setHeight?(FilterData.menuHeight[college]!)
                            self.present?(college)
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
