//
//  ViewController.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 1/3/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import UIKit

class MMMViewController: UIViewController, MMMPageScraperDelegate, UITextFieldDelegate {
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pageScraper: MMMPageScraper?
    var courseInfoArray = [MMMCourseInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageScraper = MMMPageScraper(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileNameEdited(sender: AnyObject) {
        if let profileName = profileName.text where profileName != "" {
            searchButton.enabled = true
        } else {
            searchButton.enabled = false
        }
        
    }
    
    func didGetUploadedCourses(courseInfo: [MMMCourseInfo], profileName: String, pageNumber: Int, nextPageNumber: Int) {
        courseInfoArray.appendContentsOf(courseInfo)
        
        if pageNumber != nextPageNumber {
            self.pageScraper?.getCoursesForProfile(profileName, pageNumber: nextPageNumber)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.endSearch()
                self.performSegueWithIdentifier("ShowCourseData", sender: self)
            }
        }
    }
    
    func failedGetUploadedCourses(errorDescription: String, profileName: String, pageNumber: Int) {
        //print(errorDescription + " Profile: \(profileName). Page Number: \(pageNumber).")
        
        if errorDescription == "The server encountered an error. Please wait awhile and try again." {
            self.pageScraper?.getCoursesForProfile(profileName, pageNumber: pageNumber)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.endSearch()
                })
                
                alertController.addAction(alertAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {           textField.resignFirstResponder()
        searchProfile(searchButton)
        return true
    }
    
    @IBAction func searchProfile(sender: UIButton) {
        if let profileName = profileName.text where profileName != "" {
            beginSearch()
            pageScraper?.getCoursesForProfile(profileName, pageNumber: 1)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please enter a Profile Name.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.endSearch()
            })
            
            alertController.addAction(alertAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    func beginSearch() {
        profileName.enabled = false
        searchButton.enabled = false
        courseInfoArray.removeAll()
        activityIndicator.startAnimating()
    }
    
    func endSearch() {
        self.profileName.enabled = true
        if let profileName = profileName.text where profileName != "" {
            self.searchButton.enabled = true
        }
        self.activityIndicator.stopAnimating()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCourseData" {
            if let destinationCollectionViewController = segue.destinationViewController as? MMMCourseInfoViewController {
                destinationCollectionViewController.courseInfoArray = self.courseInfoArray
            } else {
                let alertController = UIAlertController(title: "Error", message: "Unexpected error occured.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.endSearch()
                })
                
                alertController.addAction(alertAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

