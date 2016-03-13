//
//  MMMCourseInfoTableViewController.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 3/5/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import UIKit

class MMMCourseInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var courseInfoArray: [MMMCourseInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseInfoArray.count
    }
    
    func loadCellImageFromURL(url: String, inout cell: MMMCourseCollectionViewCell) {
        if let imageURL = NSURL(string: url) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: {
                (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                guard let data = data where error == nil else { return }
                
                dispatch_async(dispatch_get_main_queue()) {
                    cell.courseImage.image = UIImage(data: data)
                }
            })
            
            task.resume()
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "Course"
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MMMCourseCollectionViewCell
       
        let courseInfoElement = courseInfoArray[indexPath.row]
        
        cell.courseTitle.text = courseInfoElement.courseTitle
        cell.courseImage.image = nil
        
        loadCellImageFromURL(courseInfoElement.courseImage, cell: &cell)
        
        cell.courseID.text = courseInfoElement.courseID
        cell.courseLikes.text = String(courseInfoElement.courseLikes)
        cell.coursePlays.text = String(courseInfoElement.coursePlays)
        cell.courseClears.text = String(courseInfoElement.courseClears)
        cell.courseAttempts.text = String(courseInfoElement.courseAttempts)

        let rawPopularity = (courseInfoElement.coursePlays == 0 ? 0 : 100 * Double(courseInfoElement.courseLikes) / Double(courseInfoElement.coursePlays))
        let rawPopularityString = String(format: "%.5f", rawPopularity)
        cell.coursePopularity.text = rawPopularityString.substringToIndex(rawPopularityString.startIndex.advancedBy(4)) + "%"
        
        
        let rawClearRate = (courseInfoElement.courseAttempts == 0 ? 0 : 100 * Double(courseInfoElement.courseClears) / Double(courseInfoElement.courseAttempts))
        let rawClearRateString = String(format: "%.5f", rawClearRate)
        cell.courseClearRate.text = rawClearRateString.substringToIndex(rawClearRateString.startIndex.advancedBy(4)) + "%"
        

        let rawDifficulty = (courseInfoElement.coursePlays == 0 ? 0 : 100 * Double(courseInfoElement.courseClears) / Double(courseInfoElement.coursePlays))
        let rawDifficultyString = String(format: "%.5f", rawDifficulty)
        cell.courseDifficulty.text = rawDifficultyString.substringToIndex(rawDifficultyString.startIndex.advancedBy(4)) + "%"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
