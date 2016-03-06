//
//  MMMCourseInfoTableViewController.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 3/5/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import UIKit

class MMMCourseInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableCourseList: UITableView!
    var courseInfoArray: [MMMCourseInfo] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseInfoArray.count
        //        return tupleCourseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Course"
        let cell = tableCourseList.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MMMCourseTableViewCell
        
        cell.courseTitle.text = courseInfoArray[indexPath.row].courseTitle
        cell.courseID.text = courseInfoArray[indexPath.row].courseID
        cell.courseLikes.text = String(courseInfoArray[indexPath.row].courseLikes)
        cell.coursePlays1.text = String(courseInfoArray[indexPath.row].coursePlays)
        cell.coursePlays2.text = String(courseInfoArray[indexPath.row].coursePlays)
        cell.courseClears1.text = String(courseInfoArray[indexPath.row].courseClears)
        cell.courseClears2.text = String(courseInfoArray[indexPath.row].courseClears)
        cell.courseAttempts.text = String(courseInfoArray[indexPath.row].courseAttempts)

        //cell.courseTitle.text = courseInfoArray[indexPath.row].courseTitle
        //cell.courseTitle.text = courseInfoArray[indexPath.row].courseTitle
        //cell.courseTitle.text = courseInfoArray[indexPath.row].courseTitle
        //cell.courseTitle.text = courseInfoArray[indexPath.row].courseTitle
        
        
        
        
        
        //        cell.LevelName.text = tupleCourseList[indexPath.row].0
        //      loadImageFromURL(tupleCourseList[indexPath.row].1, toCell: cell)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}
