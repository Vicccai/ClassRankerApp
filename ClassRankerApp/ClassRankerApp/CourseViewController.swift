//
//  CourseViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit

class CourseViewController: UIViewController {
    
    var course: Course?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        if let course = course {
            self.title = course.number
        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
