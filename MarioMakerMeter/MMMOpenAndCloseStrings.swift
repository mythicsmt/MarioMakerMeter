//
//  MMMOpenAndCloseStrings.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 3/12/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import Foundation

struct MMMOpenAndCloseStrings {
    var prefix, suffix: String
    
    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }
    
    func findNextInString(var stringToSearch: String) -> String? {
        
        if let rangeFindStart = stringToSearch.rangeOfString(prefix) {
            stringToSearch = stringToSearch[rangeFindStart.startIndex..<stringToSearch.endIndex]
            if let rangeFindEnd = stringToSearch.rangeOfString(suffix) {
                let getMatch = stringToSearch[stringToSearch.startIndex.advancedBy(prefix.characters.count)..<rangeFindEnd.startIndex]
                return getMatch.stringByDecodingHTMLEntities
            }
        }
        
        return nil
    }
    
    func findAllInString(var stringToSearch: String) -> [String]? {
        var stringMatches: [String]?
        
        while let rangeFindStart = stringToSearch.rangeOfString(prefix) {
            stringToSearch = stringToSearch[rangeFindStart.startIndex..<stringToSearch.endIndex]
            
            if let rangeFindEnd = stringToSearch.rangeOfString(suffix) {
                
                let getMatch = stringToSearch[stringToSearch.startIndex.advancedBy(prefix.characters.count)..<rangeFindEnd.startIndex]
                
                if stringMatches == nil {
                    stringMatches = [String]()
                }
                
                stringMatches?.append(getMatch.stringByDecodingHTMLEntities)
                
                stringToSearch = stringToSearch[rangeFindEnd.endIndex..<stringToSearch.endIndex]
            } else {
                break
            }
        }
        
        return stringMatches
    }
}