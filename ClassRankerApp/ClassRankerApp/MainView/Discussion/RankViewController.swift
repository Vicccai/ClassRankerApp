//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//
import UIKit
import Alamofire
import iOSDropDown
import SwiftUI

class RankViewController: UIViewController {
    
    let padding: CGFloat = 15
    var popupMenuHeight: CGFloat = 0
    var courses: [Course] = []
    var suppressObservers = true //clear button don't refetch data
    
    var filteredCourses: [Course] = [] // based on SearchBar
    
    var showFavorites: Bool = false
    
    var filteredFirst: Bool = false
    
    var selectedLevel: Int = 0 {
        didSet {
            favStar.image = UIImage(named: "Star 1")
            showFavorites = false
            if !self.suppressObservers {
                if selectedLevel == 0 {
                    levelButton.setTitle("  Level  ", for: .normal)
                    levelButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
                    levelButton.backgroundColor = .white
                } else {
                    levelButton.setTitle("  \(String(selectedLevel))  ", for: .normal)
                    levelButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
                    levelButton.setTitleColor(.white, for: .normal)
                }
                getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
            }
            coursesView.reloadData()
        }
    }
    
    var selectedDistr: [String] = [] {
        didSet {
            favStar.image = UIImage(named: "Star 1")
            showFavorites = false
            if !self.suppressObservers {
                if selectedDistr == [] {
                    distrButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
                    distrButton.backgroundColor = .white
                } else {
                    distrButton.setTitleColor(.white, for: .normal)
                    distrButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
                }
            }
            coursesView.reloadData()
        }
    }
    
    var selectedSort: String = "" {
        didSet {
            favStar.image = UIImage(named: "Star 1")
            showFavorites = false
            if !self.suppressObservers {
                if selectedSort == "" {
                    sortButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
                    sortButton.setTitle("  Sort by...  ", for: .normal)
                    sortButton.backgroundColor = .white
                } else {
                    sortButton.setTitleColor(.white, for: .normal)
                    sortButton.setTitle("  \(selectedSort)  ", for: .normal)
                    sortButton.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
                }
                getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
            }
            coursesView.reloadData()
        }
    }
    
    var matchAll: Bool = true {
        didSet {
            if !self.suppressObservers {
                getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
            }
        }
    }
    
    @objc func clearButtonTapped() {
        suppressObservers = true
        levelButton.setTitle("  Level  ", for: .normal)
        levelButton.backgroundColor = .white
        levelButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
        distrButton.backgroundColor = .white
        distrButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
        sortButton.setTitle("  Sort by...  ", for: .normal)
        sortButton.backgroundColor = .white
        sortButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00), for: .normal)
        suppressObservers = false
        favStar.image = UIImage(named: "Star 1")
        showFavorites = false
        searchController.searchBar.text = ""
        selectedDistr = []
        selectedLevel = 0
        selectedSort = ""
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
    
    let clearButton: UIButton = {
        let button = makeButton(title: "Clear")
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    
    var roosterImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Dance")
        view.contentMode = .scaleAspectFit
        return view
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
    
    var exitImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "exit")
        return image
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(exitAlert), for: .touchUpInside)
        return button
    }()
    
    @objc func exitAlert(){
        let alert = UIAlertController(title: "Return to Sign In?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { (action) in
            if Globals.guest == false {
                NetworkManager.logout(user: Globals.user) { user in
                    print("suceeded")
                }
            }
            Globals.favCourses = []
            Globals.guest = false
            Globals.user = User(username: "", session_token: "")
            self.clearButtonTapped()
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    class spinnerController: UIViewController {
        let spinner = UIActivityIndicatorView(style: .large)
        
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    func createSpinnerView() -> RankViewController.spinnerController{
        let child = spinnerController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        return child
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //notifications
        NotificationCenter.default.addObserver(self, selector: #selector(getCourses), name: NSNotification.Name(rawValue: "CoursesLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(calculateFavs), name: NSNotification.Name(rawValue: "FavoritesLoaded"), object: nil)
        
        //get favorites
        //getFavorites()
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        view.isMultipleTouchEnabled = false
        // title stuff
        navigationItem.title = "Courses"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00),
            .font: UIFont(name: "Proxima Nova Bold", size: 35)!
        ]
        
        navigationItem.backButtonTitle = ""
        
        // search bar stuff
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00), .font : UIFont(name: "ProximaNova-Regular", size: 16)!], for: .normal)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Filtered Classes"
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        for subView in [roosterImageView, clearButton, levelButton, sortButton, distrButton, coursesView, favFilter, favStar, exitButton, exitImage] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        navigationItem.hidesBackButton = true
        setupConstraints()
        getCourses()
        suppressObservers = false
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
            
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.widthAnchor.constraint(equalToConstant: 40),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            exitImage.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
            exitImage.centerXAnchor.constraint(equalTo: exitButton.centerXAnchor),
            exitImage.heightAnchor.constraint(equalToConstant: 40),
            exitImage.widthAnchor.constraint(equalToConstant: 40),
            
            levelButton.leadingAnchor.constraint(equalTo: favFilter.trailingAnchor, constant: 10),
            levelButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            levelButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            
            distrButton.leadingAnchor.constraint(equalTo: levelButton.trailingAnchor, constant: 10),
            distrButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            distrButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            
            sortButton.leadingAnchor.constraint(equalTo: distrButton.trailingAnchor, constant: 10),
            sortButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            sortButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            
            clearButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 10),
            clearButton.centerYAnchor.constraint(equalTo: favFilter.centerYAnchor),
            clearButton.heightAnchor.constraint(equalTo: favFilter.heightAnchor),
            
            coursesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coursesView.topAnchor.constraint(equalTo: favFilter.bottomAnchor, constant: padding),
            coursesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coursesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            
            roosterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            roosterImageView.heightAnchor.constraint(equalToConstant: 250),
            roosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            roosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }

    @objc func getCourses() {
        shownCourses = Globals.courses
        getFavorites()
    }
    @objc func calculateFavs() {
        for i in 0..<shownCourses.count {
            if Globals.favCourses.contains(shownCourses[i]) {
                Globals.courses[i].favorite = true
                shownCourses[i].favorite = true
            }
        }
        coursesView.reloadData()
    }
    
    func getCoursesByAttributes(level: Int, distributions: [String], matchAll: Bool, sort: Int) {
        let child = createSpinnerView()
        searchController.searchBar.backgroundColor = UIColor(white: 0, alpha: 0)
        NetworkManager.getCourseByAttributes(level: level, distributions: distributions, matchAll: matchAll, sort: sort) { courses in
            self.shownCourses = courses.courses
            for i in 0..<self.shownCourses.count {
                if Globals.favCourses.contains(self.shownCourses[i]) {
                    self.shownCourses[i].favorite = true
                }
            }
            let text = self.searchController.searchBar.text
            if text != "" {
                self.filterContentForSearchText(searchText: text!)
            }
            self.coursesView.reloadData()
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
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
        
        // if you're turning on the filter
        if favStar.image == UIImage(named: "Star 1") {
            // changing colors
            favStar.image = UIImage(named: "Star 2")
            
          // if youre turning off the filter
        } else {
            // changing colors back
            favStar.image = UIImage(named: "Star 1")
            if isFiltering && !filteredFirst{
                getCoursesByAttributes(level: selectedLevel, distributions: selectedDistr, matchAll: matchAll, sort: FilterData.sortNumber[selectedSort]!)
            }
        }
        showFavorites = !showFavorites
        coursesView.reloadData()
    }
    
    func getFavorites() {
        if Globals.guest.boolValue == false {
            NetworkManager.getFavoritesByUser(user: Globals.user) { favorites in
                Globals.favCourses = favorites.favorites
                NotificationCenter.default.post(name: Notification.Name("FavoritesLoaded"), object: nil)
            }
        }
    }
    
    func getFinalCourses() -> [Course] {
        var finalCourses = shownCourses
        if showFavorites {
            finalCourses = Globals.favCourses
        }
        if isFiltering && !filteredFirst{
            finalCourses = finalCourses.filter(filteredCourses.contains)
        }
        return finalCourses
    }
//    func calculateShownCourses() {
//        if !isFiltering && selectedMajor == "" && selectedDistr == "" {
//            shownCourses = courses
//        } else if isFiltering && selectedMajor == "" && selectedDistr == "" {
//            shownCourses = filteredCourses
//        } else {
//            // check if search bar is actively filtering
//            let coursesToFilterFrom = isFiltering ? filteredCourses : courses
//            // filter based on distribution
//            let distributionCourses = coursesToFilterFrom.filter({ course in
//                if selectedDistr == "" { return true }
//                let distrArray = course.distribution
//                return distrArray.contains(selectedDistr)
//            })
//            // filter based on major
//            let finalFilteredCourses = distributionCourses.filter({ course in
//                return selectedMajor == "" ? true : course.number.contains(selectedMajor) 90754247d7fa145307213813919e776ea25898b9:ClassRankerApp/ClassRankerApp/RankViewController.swift
//            })
//            shownCourses = finalFilteredCourses
//        }
//        coursesView.reloadData()
//    }
//
//    func filterContentForSearchText(searchText: String) {
//        filteredCourses = courses.filter({ course in
//            course.name.lowercased().contains(searchText.lowercased()) ||
//            course.number.lowercased().contains(searchText.lowercased())
//        })
//        calculateShownCourses()
//    }
    
    //create function that takes course name from what it is delegating from and make the change here
    func isFavoriteCourse(course: Course, favorite: Bool) {
//        guard let courseIndex = shownCourses.firstIndex (where: { course in
//            course.title == courseName
//        }) else { return }
        if Globals.guest.boolValue == true {
            let alert = UIAlertController(title: "Please Login", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        //add or remove course from favCourses
        var c = course
        if !showFavorites && favorite { //add
            c.favorite = true
            NetworkManager.addToFavoritesForUser(user: Globals.user, course: c) { _ in
            }
            Globals.favCourses.append(c)
        } else { //remove
            c.favorite = false
            NetworkManager.removeFromFavoritesForUser(user: Globals.user, course: c) { _ in
            }
            if let index = Globals.favCourses.firstIndex(of: c) {
                Globals.favCourses.remove(at: index)
            }
        }
        if let shownIndex = shownCourses.firstIndex(of: course) {
            shownCourses[shownIndex].favorite = favorite
        }
        if let filteredIndex = filteredCourses.firstIndex(of: course) {
            filteredCourses[filteredIndex].favorite = favorite
        }
        // refilter here
        coursesView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        if showFavorites {
            filteredFirst = false
            filteredCourses = Globals.favCourses.filter({ course in
                let courseNumber = course.subject + " " + String(course.number)
                return (courseNumber.lowercased().contains(searchText.lowercased()) ||
                course.title.lowercased().contains(searchText.lowercased()))
            })
        }
        else {
            filteredFirst = true
            filteredCourses = shownCourses.filter({ course in
                let courseNumber = course.subject + " " + String(course.number)
                return (courseNumber.lowercased().contains(searchText.lowercased()) ||
                course.title.lowercased().contains(searchText.lowercased()))
            })
        }
        coursesView.reloadData()
    }

}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering && !showFavorites{
            return filteredCourses.count
        } else {
            return getFinalCourses().count
        }
//        if showFavorites && Globals.favCourses.count > 1 {
//            return Globals.favCourses.count
//        } else if isFiltering {
//            return filteredCourses.count
//        } else {
//            return shownCourses.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoursesTableViewCell.id) as? CoursesTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isFiltering && !showFavorites{
            cell.configure(sort: selectedSort, course: filteredCourses[indexPath.row], index: indexPath.row)
        } else {
            cell.configure(sort: selectedSort, course: getFinalCourses()[indexPath.row], index: indexPath.row)
        }
        return cell
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course: Course
        if isFiltering && !showFavorites{
            course = filteredCourses[indexPath.item]
        } else {
            course = getFinalCourses()[indexPath.item]
        }
        let descriptionViewController = DescriptionViewController()
        descriptionViewController.delegate = self
        descriptionViewController.configure(course: course)
        NetworkManager.getCommentsByCourse(course: course) { comments in
            descriptionViewController.comments = comments.comments
            self.navigationController?.pushViewController(descriptionViewController, animated: true)
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
        let presenter = SelectMenuPresentation(presentedViewController: presented, presenting: presenting)
        presenter.height = popupMenuHeight
        return presenter
    }
}
