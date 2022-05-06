//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit
import Alamofire
import iOSDropDown
//import DropDown

class RankViewController: UIViewController {
    
    let padding: CGFloat = 15
    
    let courses = [
        Course(number: "CS 1110", name: "Intro to Python", rating: 9.7, distribution: "MQR-AS", favorite: false, descr: "pretty good course. walker white? 10/10. other teacher? literally no idea. space invaders was fun. made me like cs. not that i would admit that.", credits: 4, reqs: "be prepared to get yelled at", overallRating: 5.0, workloadRating: 5.0, difficultyRating: 2.5, professors: "Walker White, Daisy Something"),
        Course(number: "CS 2110", name: "Object Oriented Programming", rating: 8.4, distribution: "MQR-AS", favorite: true, descr: "welp. made lots of kids hate cs. slightly more boring than 1110 but idk it was still fun and i would die for gries. i repeat, i would DIE FOR GRIES.", credits: 4, reqs: "CS1110 or be smart in high school and take it then", overallRating: 4.8, workloadRating: 4.5, difficultyRating: 4.3, professors: "gries <3"),
        Course(number: "MATH 1110", name: "Calc 1", rating: 4.2, distribution:
            "MQR-AS", favorite: false, descr: "took calc in high school because i hated myself. probably not a terrible course.", credits: 3, reqs: "don't take in high school", overallRating: 3.5, workloadRating: 2.3, difficultyRating: 1.2, professors: "literally no clue"),
        Course(number: "CS 1234", name: "Made up CS LA-AS", rating: 4.2, distribution:
            "LA-AS", favorite: false, descr: "made this up so ill make this up too. idk. probably pretty fun bc its cs. probably pretty hard bc its cs. probably in duffield because again, it's cs.", credits: 3, reqs: "probably 2110 like everything else", overallRating: 3.2, workloadRating: 2.1, difficultyRating: 5.6, professors: "Victor Cai")
    ]
    
    var filteredCourses: [Course] = [] // based on SearchBar
    
    var selectedMajor: String = ""
    var selectedDistr: String = ""
    
    var shownCourses: [Course] = [] // courses that are actually shown, combo of search and dropdown
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var filterCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let filters = ["Subject", "Distribution", "Sort by..."]
    
    static func makeFilterButton(label: String) -> UIButton {
        let button = UIButton()
        button.setTitle(label, for: .normal)
        return button
    }
    
    let subjectFilter: UIButton = makeFilterButton(label: "Subject")
    let distrFilter: UIButton = makeFilterButton(label: "Distribution")
    let sortFilter: UIButton = makeFilterButton(label: "sort")
   
    lazy var coursesView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoursesTableViewCell.self, forCellReuseIdentifier: CoursesTableViewCell.id)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var favStar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Star 1")
        return image
    }()
    
    var favFilter: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(filterFavs), for: .touchUpInside)
        return button
    }()
    
//    var majorDropDown: DropDownContainer = {
//        let view = DropDownContainer(placeholder: "Major", optionArray: ["", "CS", "MATH", "hello", "hi", "testing"])
//        return view
//    }()
//
//    var distrDropDown: DropDownContainer = {
//        let view = DropDownContainer(placeholder: "Distribution", optionArray:  ["", "MQR-AS", "LA-AS"])
//        return view
//    }()
//
//    var favDropDown: DropDownContainer = {
//        let view = DropDownContainer(placeholder: "Filter by...", optionArray: ["", "Rating", "Favorites", "My Favorites"])
//        return view
//    }()
//
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
       
        // title stuff
        navigationItem.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00),
            .font: UIFont(name: "Proxima Nova Bold", size: 35)!
        ]
        navigationItem.backButtonTitle = ""
        
        // search bar stuff
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Classes"
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.tintColor = .systemBlue
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // filters
        filterCollection.dataSource = self
        filterCollection.delegate = self
        
        for subView in [filterCollection, coursesView, favFilter, favStar] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        navigationItem.hidesBackButton = true
        
//        setupDropdown()
        setupConstraints()
        calculateShownCourses()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            majorDropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            majorDropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            majorDropDown.heightAnchor.constraint(equalToConstant: 30),
//            majorDropDown.widthAnchor.constraint(equalToConstant: (view.bounds.width-50) / 3),
//
//            distrDropDown.leadingAnchor.constraint(equalTo: majorDropDown.trailingAnchor, constant: 10),
//            distrDropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            distrDropDown.heightAnchor.constraint(equalToConstant: 30),
//            distrDropDown.widthAnchor.constraint(equalToConstant: (view.bounds.width-50) / 3),
//
//            favDropDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            favDropDown.topAnchor.constraint(equalTo: distrDropDown.topAnchor),
//            favDropDown.heightAnchor.constraint(equalToConstant: 30),
//            favDropDown.widthAnchor.constraint(equalToConstant: (view.bounds.width-50) / 3),
            
            favFilter.centerYAnchor.constraint(equalTo: filterCollection.centerYAnchor),
            favFilter.heightAnchor.constraint(equalToConstant: 27.5),
            favFilter.widthAnchor.constraint(equalToConstant: 27.5),
            favFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            favStar.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            favStar.centerXAnchor.constraint(equalTo: favFilter.centerXAnchor),
            favStar.heightAnchor.constraint(equalToConstant: 20),
            favStar.widthAnchor.constraint(equalToConstant: 20),
            
            filterCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterCollection.leadingAnchor.constraint(equalTo: favFilter.trailingAnchor, constant: 12.5),
            filterCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterCollection.heightAnchor.constraint(equalToConstant: 45),
            
            coursesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coursesView.topAnchor.constraint(equalTo: filterCollection.bottomAnchor),
            coursesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coursesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
//    func setupDropdown() {
////        majorDropDown.dropDown.listDidDisappear {
////            self.selectedMajor = self.majorDropDown.dropDown.text!
////            self.calculateShownCourses()
////        }
//        majorDropDown.dropDown.didSelect { major, _, _ in
//            self.selectedMajor = major
//            self.calculateShownCourses()
//        }
//        distrDropDown.dropDown.didSelect { distr, _, _ in
//            self.selectedDistr = distr
//            self.calculateShownCourses()
//        }
//    }
    
    @objc func filterFavs() {
        // for now hard codes them as red -- I got confused with your filter system but I think we should add a field to course called "favorite" and when we click on the red star it changes it to a favorited course. when the fav filter is pressed, it appends to shownCourses all the courses that are favoritied, makes them red, and then appends the rest of the non favorites
        
        // storing original order
//        let originalOrder = shownCourses
        
        // if you're turning on the filter
        if favStar.image == UIImage(named: "Star 1") {
            // changing colors
            favStar.image = UIImage(named: "Star 2")
            let cells = self.coursesView.visibleCells as! Array<CoursesTableViewCell>
            for cell in cells {
                if cell.favorite == true {
                    cell.backView.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
                    cell.favButton.setImage(UIImage(named: "Star 3"), for: .normal)
                    cell.numberLabel.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
                    cell.nameLabel.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
                    cell.ratingLabel.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
                }
            }
            // sorting data
//            var favoriteCoursesFirst: [Course] = []
//            for course in shownCourses {
//                if course.favorite == true {
//                    favoriteCoursesFirst.append(course)
//                }
//            }
//            for course in shownCourses {
//                if course.favorite == false {
//                    favoriteCoursesFirst.append(course)
//                }
//            }
//            shownCourses = favoriteCoursesFirst
//            coursesView.reloadData()
            
          // if youre turning off the filter
        } else {
            // returning the data
//            shownCourses = originalData
//            coursesView.reloadData()
            
            // changing colors back
            favStar.image = UIImage(named: "Star 1")
            let cells = self.coursesView.visibleCells as! Array<CoursesTableViewCell>
            for cell in cells {
                if cell.favorite == true {
                    cell.backView.backgroundColor = .white
                    cell.favButton.setImage(UIImage(named: "Star 2"), for: .normal)
                    cell.numberLabel.textColor = .black
                    cell.nameLabel.textColor = .black
                    cell.ratingLabel.textColor = .black
                }
            }
        }
    }
    
    func calculateShownCourses() {
        if !isFiltering && selectedMajor == "" && selectedDistr == "" {
            shownCourses = courses
        } else if isFiltering && selectedMajor == "" && selectedDistr == "" {
            shownCourses = filteredCourses
        } else {
            // check if search bar is actively filtering
            let coursesToFilterFrom = isFiltering ? filteredCourses : courses
            // filter based on distribution
            let distributionCourses = coursesToFilterFrom.filter({ course in
                if selectedDistr == "" { return true }
                let distrArray = course.distribution
                return distrArray.contains(selectedDistr)
            })
            // filter based on major
            let finalFilteredCourses = distributionCourses.filter({ course in
                return selectedMajor == "" ? true : course.number.contains(selectedMajor)
            })
            shownCourses = finalFilteredCourses
        }
        coursesView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCourses = courses.filter({ course in
            course.name.lowercased().contains(searchText.lowercased()) ||
            course.number.lowercased().contains(searchText.lowercased())
        })
        calculateShownCourses()
    }
}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoursesTableViewCell.id) as? CoursesTableViewCell else { return UITableViewCell() }
        cell.configure(course: shownCourses[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.item]
        let descriptionViewController = DescriptionViewController()
        descriptionViewController.configure(courseNumber: course.number, courseName: course.name, courseRating: course.rating, descr: course.descr, credits: course.credits, reqs: course.reqs, distrs: course.distribution, overall: course.overallRating, workload: course.workloadRating, difficulty: course.difficultyRating, profs: course.professors)
        descriptionViewController.delegate = self
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }
}

extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.id, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(filter: filters[indexPath.item])
        return cell
    }
}

extension RankViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = filters[indexPath.item]
        label.sizeToFit()
        let height = filterCollection.frame.height
        return CGSize(width: label.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = SelectCollegeController()
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            present(vc, animated: true, completion: nil)
        }
    }
}

extension RankViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension RankViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return SelectCollegePresentation(presentedViewController: presented, presenting: presenting)
        }
}
