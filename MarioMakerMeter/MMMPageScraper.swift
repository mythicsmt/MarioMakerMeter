//
//  MMMPageScraper.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 2/21/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import Foundation

protocol MMMPageScraperDelegate {
    func didGetUploadedCourses(courseInfo: [MMMCourseInfo], profileName: String, pageNumber: Int, nextPageNumber: Int) -> Void
    func failedGetUploadedCourses(errorDescription: String, profileName: String, pageNumber: Int) -> Void
}

class MMMPageScraper {
    let oacCourseError = MMMOpenAndCloseStrings(prefix: "<div class=\"error-description\">", suffix: "</div>")
    
    let oacCourseCards = MMMOpenAndCloseStrings(prefix: "<div class=\"course-card", suffix: ">Bookmark</label>")
    
    let oacCourseTitle = MMMOpenAndCloseStrings(prefix: "<div class=\"course-title\">", suffix: "</div>")
    let oacCourseImage = MMMOpenAndCloseStrings(prefix: "class=\"course-image\" src=\"", suffix: "\" />")
    let oacCourseID = MMMOpenAndCloseStrings(prefix: "href=\"/courses/", suffix: "\">More Info</a>")
    let oacCourseTypography = MMMOpenAndCloseStrings(prefix:  "<div class=\"typography typography-", suffix: "\">")
    let oacCourseLikes = MMMOpenAndCloseStrings(prefix: "course-stats-wrapper\"><div class=\"liked-count \">", suffix: "<div class=\"played-count \">")
    let oacCoursePlays = MMMOpenAndCloseStrings(prefix: "<div class=\"played-count \">", suffix: "<div class=\"shared-count \">")
    
    let oacCourseClearsAndAttempts = MMMOpenAndCloseStrings(prefix: "<div class=\"tried-count \">", suffix: "<div class=\"course-image-full-wrapper\">")
    let oacCourseClears = MMMOpenAndCloseStrings(prefix: "<div class=\"label\">Clears</div>", suffix: "slash")
    let oacCourseAttempts = MMMOpenAndCloseStrings(prefix: "slash", suffix: "</div></div></div>")
    
    let oacCourseNextPageStep1 = MMMOpenAndCloseStrings(prefix: "<span class=\"next\"><a rel=\"next\" class=\"link button\" href=\"/profile/", suffix: ">&rsaquo;")
    let oacCourseNextPageStep2 = MMMOpenAndCloseStrings(prefix: "page=", suffix: "#")
    
    let profileBaseURL = "https://supermariomakerbookmark.nintendo.net/profile/"
    let pageBase = "?page="
    var delegate: MMMPageScraperDelegate?
    
    init(delegate: MMMPageScraperDelegate) {
        self.delegate = delegate
    }

    func getCoursesForProfile(profileName: String, pageNumber: Int) {
        if let url = NSURL(string:profileBaseURL + profileName + pageBase + String(pageNumber)) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: parseSessionCompletion(profileName, pageNumber: pageNumber))
            
            task.resume()
        }
    }
    
    func parseSessionCompletion(profileName: String, pageNumber: Int)(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let error = error {
            self.delegate?.failedGetUploadedCourses(error.localizedDescription, profileName: profileName, pageNumber: pageNumber)
            return
        }
        
        if let html = String(data: data!, encoding: NSASCIIStringEncoding) {
            if let errorDescription = self.oacCourseError.findNextInString(html) {
                self.delegate?.failedGetUploadedCourses(errorDescription, profileName: profileName, pageNumber: pageNumber)
                return
            }
            
            if let courseCards = self.oacCourseCards.findAllInString(html) {
                var courseInfoArray = [MMMCourseInfo]()
                for courseCard in courseCards {
                    if let newCourseInfo = getCourseInfo(courseCard) {
                        courseInfoArray.append(newCourseInfo)
                    }
                }
                
                var nextPageNumber = pageNumber
                if let nextPageNumberStep1 = self.oacCourseNextPageStep1.findNextInString(html) {
                    if let nextPageNumberStep2 = self.oacCourseNextPageStep2.findNextInString(nextPageNumberStep1) {
                        if let nextPageNumberInt = Int(nextPageNumberStep2) {
                            nextPageNumber = nextPageNumberInt
                        }
                    }
                }
                
                self.delegate?.didGetUploadedCourses(courseInfoArray, profileName: profileName, pageNumber: pageNumber, nextPageNumber: nextPageNumber)
            } else {
                self.delegate?.failedGetUploadedCourses("Found 0 courses for \(profileName)", profileName: profileName, pageNumber: pageNumber)
            }
        }
    }
    
    func getCourseInfo(courseCard: String) -> MMMCourseInfo? {
        var newCourseInfo: MMMCourseInfo?
        
        guard let courseTitle = self.oacCourseTitle.findNextInString(courseCard) else { return nil }
        guard let courseImage = self.oacCourseImage.findNextInString(courseCard) else { return nil }
        guard let courseID = self.oacCourseID.findNextInString(courseCard) else { return nil }
        guard let typographicCourseLikes = self.oacCourseLikes.findNextInString(courseCard) else { return nil }
        guard let courseLikes = extractTypographyToInt(typographicCourseLikes) else { return nil }

        let typographicCoursePlays = self.oacCoursePlays.findNextInString(courseCard)
        guard let coursePlays = extractTypographyToInt(typographicCoursePlays) else { return nil }
        
        var typographicCourseClears, typographicCourseAttempts: String?
        if let typographicCourseClearsAndAttempts = self.oacCourseClearsAndAttempts.findNextInString(courseCard) {
            typographicCourseClears = self.oacCourseClears.findNextInString(typographicCourseClearsAndAttempts)
            typographicCourseAttempts = self.oacCourseAttempts.findNextInString(typographicCourseClearsAndAttempts)
        }
        
        guard let courseClears = extractTypographyToInt(typographicCourseClears) else { return nil }
        guard let courseAttempts = extractTypographyToInt(typographicCourseAttempts) else { return nil }
        
        newCourseInfo = MMMCourseInfo(courseTitle: courseTitle,
                                      courseImage: courseImage,
                                      courseID: courseID,
                                      courseLikes: courseLikes,
                                      coursePlays: coursePlays,
                                      courseClears: courseClears,
                                      courseAttempts: courseAttempts)
        
        return newCourseInfo
    }

    func extractTypographyToInt(stringWithTypographyTags: String?) -> Int? {
        if let stringWithTypographyTags = stringWithTypographyTags {
            if let typographyStringArray = self.oacCourseTypography.findAllInString(stringWithTypographyTags) {
                if let typographyAsInt = Int(typographyStringArray.joinWithSeparator("")) {
                    return typographyAsInt
                }
            }
        }
        
        return nil
    }
}
