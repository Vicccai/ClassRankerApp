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
    var popupMenuHeight: CGFloat = 0
    var courses: [Course] = []
//    let courses = [
//        Course(number: "CS 1110", name: "Intro to Python", rating: 9.7, distribution: "MQR-AS", favorite: false, descr: "pretty good course. walker white? 10/10. other teacher? literally no idea. space invaders was fun. made me like cs. not that i would admit that.", credits: 4, reqs: "be prepared to get yelled at", overallRating: 5.0, workloadRating: 5.0, difficultyRating: 2.5, professors: "Walker White, Daisy Something"),
//        Course(number: "CS 2110", name: "Object Oriented Programming", rating: 8.4, distribution: "MQR-AS", favorite: true, descr: "welp. made lots of kids hate cs. slightly more boring than 1110 but idk it was still fun and i would die for gries. i repeat, i would DIE FOR GRIES.", credits: 4, reqs: "CS1110 or be smart in high school and take it then", overallRating: 4.8, workloadRating: 4.5, difficultyRating: 4.3, professors: "gries <3"),
//        Course(number: "MATH 1110", name: "Calc 1", rating: 4.2, distribution:
//            "MQR-AS", favorite: false, descr: "took calc in high school because i hated myself. probably not a terrible course.", credits: 3, reqs: "don't take in high school", overallRating: 3.5, workloadRating: 2.3, difficultyRating: 1.2, professors: "literally no clue"),
//        Course(number: "CS 1234", name: "Made up CS LA-AS", rating: 4.2, distribution:
//            "LA-AS", favorite: false, descr: "made this up so ill make this up too. idk. probably pretty fun bc its cs. probably pretty hard bc its cs. probably in duffield because again, it's cs.", credits: 3, reqs: "probably 2110 like everything else", overallRating: 3.2, workloadRating: 2.1, difficultyRating: 5.6, professors: "Victor Cai")
//    ]
    
    var filteredCourses: [Course] = [] // based on SearchBar
    
    var selectedLevel: Int = 0 {
        didSet {
            if selectedLevel == 0 {
                levelButton.setTitle("  Level  ", for: .normal)
                levelButton.backgroundColor = .white
            } else {
                levelButton.setTitle("  \(String(selectedLevel))  ", for: .normal)
                levelButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
            }
            getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
        }
    }
    var selectedDistr: [String] = [] {
        didSet {
            if selectedDistr == [] {
                distrButton.backgroundColor = .white
            } else {
                distrButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
            }
        }
    }
    
    var selectedSort: String = "" {
        didSet {
            if selectedSort == "" {
                sortButton.setTitle("  Sort by...  ", for: .normal)
                sortButton.backgroundColor = .white
            } else {
                sortButton.setTitle("  \(selectedSort)  ", for: .normal)
                sortButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
            }
            getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
        }
    }
    
    var matchAll: Bool = true {
        didSet {
            getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
        }
    }
    
    var shownCourses: [Course] = [] // courses that are actually shown, combo of search and dropdown
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    static func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("  \(title)  ", for: .normal)
        button.titleLabel?.font =  UIFont(name: "Proxima Nova Regular", size: 15)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
        button.backgroundColor = .white
        return button
    }
    
    let levelButton: UIButton = {
        let button = makeButton(title: "Level")
        button.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        return button
    }()
    let distrButton: UIButton = {
        let button = makeButton(title: "Distribution")
        button.addTarget(self, action: #selector(distrButtonTapped), for: .touchUpInside)
        return button
    }()
    let sortButton: UIButton = {
        let button = makeButton(title: "Sort by...")
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
   
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
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)], for: .normal)
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
        
        for subView in [levelButton, sortButton, distrButton, coursesView, favFilter, favStar] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        navigationItem.hidesBackButton = true
        setupConstraints()
        getCourses()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            favFilter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favFilter.heightAnchor.constraint(equalToConstant: 27.5),
            favFilter.widthAnchor.constraint(equalToConstant: 27.5),
            favFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            favStar.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            favStar.centerXAnchor.constraint(equalTo: favFilter.centerXAnchor),
            favStar.heightAnchor.constraint(equalToConstant: 20),
            favStar.widthAnchor.constraint(equalToConstant: 20),
            
            levelButton.leadingAnchor.constraint(equalTo: favFilter.trailingAnchor, constant: 10),
            levelButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            levelButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            levelButton.widthAnchor.constraint(equalToConstant: 55),
            
            distrButton.leadingAnchor.constraint(equalTo: levelButton.trailingAnchor, constant: 10),
            distrButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            distrButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            levelButton.widthAnchor.constraint(equalToConstant: 95),
            
            sortButton.leadingAnchor.constraint(equalTo: distrButton.trailingAnchor, constant: 10),
            sortButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            sortButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            levelButton.widthAnchor.constraint(equalToConstant: 76),
            
            coursesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coursesView.topAnchor.constraint(equalTo: favFilter.bottomAnchor, constant: padding),
            coursesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coursesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    func getCourses() {
        NetworkManager.getAllCourses { courses in
            self.shownCourses = courses.courses
            self.coursesView.reloadData()
        }
    }
    
    func getCoursesByAttributes(level: Int, distributions: [String], matchAll: Bool, sort: Int) {
        NetworkManager.getCourseByAttributes(level: level, distributions: distributions, matchAll: matchAll, sort: sort) { courses in
            self.shownCourses = courses.courses
            self.coursesView.reloadData()
        }
    }
    
    @objc func levelButtonTapped() {
        //print(levelButton.frame.width)
        popupMenuHeight = FilterData.menuHeight["Levels"]!
        let vc = SelectLevelController()
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    @objc func distrButtonTapped() {
        //print(distrButton.frame.width)
        popupMenuHeight = FilterData.menuHeight["Colleges"]!
        let vc = SelectCollegeController()
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    @objc func sortButtonTapped() {
        popupMenuHeight = FilterData.menuHeight["Sort"]!
        let vc = SelectSortController()
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
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
                    cell.favButton.setImage(UIImage(named: "Star 1"), for: .normal)
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
    
//    func calculateShownCourses() {
//        if !isFiltering && selectedLevel == "" && selectedDistr == "" {
//            shownCourses = courses
//        } else if isFiltering && selectedLevel == "" && selectedDistr == "" {
//            shownCourses = filteredCourses
//        } else {
//            // check if search bar is actively filtering
//            let coursesToFilterFrom = isFiltering ? filteredCourses : courses
//            // filter based on distribution
//            let distributionCourses = coursesToFilterFrom.filter({ course in
//                if selectedDistr == "" { return true }
//                let distrArray = course.distributions
//                let distrNames = distrArray.map { $0.name }
//                return distrNames.contains(selectedDistr)
//            })
//            // filter based on major
//            let finalFilteredCourses = distributionCourses.filter({ course in
//                return selectedLevel == "" ? true : course.subject.contains(selectedLevel)
//            })
//            shownCourses = finalFilteredCourses
//        }
//        coursesView.reloadData()
//    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCourses = shownCourses.filter({ course in
            let courseNumber = course.subject + " " + String(course.number)
            return (courseNumber.lowercased().contains(searchText.lowercased()) ||
            course.title.lowercased().contains(searchText.lowercased()))
        })
        coursesView.reloadData()
    }
}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCourses.count
        } else {
            return shownCourses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoursesTableViewCell.id) as? CoursesTableViewCell else { return UITableViewCell() }
        if isFiltering {
            cell.configure(course: filteredCourses[indexPath.row], index: indexPath.row)
        } else {
            cell.configure(course: shownCourses[indexPath.row], index: indexPath.row)
        }
        return cell
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var course: Course
        if isFiltering {
            course = filteredCourses[indexPath.item]
        } else {
            course = shownCourses[indexPath.item]
        }
        let descriptionViewController = DescriptionViewController()
        descriptionViewController.configure(course: course)
        descriptionViewController.delegate = self
        navigationController?.pushViewController(descriptionViewController, animated: true)
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
        let presenter = SelectMenuPresentation(presentedViewController: presented, presenting: presenting)
        presenter.height = popupMenuHeight
        return presenter
    }
}
