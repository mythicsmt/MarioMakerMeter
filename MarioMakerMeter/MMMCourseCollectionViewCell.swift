//
//  MMMCourseTableViewCell.swift
//  MarioMakerMeter
//
//  Created by Tim Winter on 1/12/16.
//  Copyright © 2016 Tim Winter. All rights reserved.
//

import UIKit

class MMMCourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseID: UILabel!
    @IBOutlet weak var courseLikes: UILabel!
    @IBOutlet weak var coursePlays: UILabel!
    @IBOutlet weak var courseClears: UILabel!
    @IBOutlet weak var courseAttempts: UILabel!
    @IBOutlet weak var coursePopularity: UILabel!
    @IBOutlet weak var courseClearRate: UILabel!
    @IBOutlet weak var courseDifficulty: UILabel!
}
