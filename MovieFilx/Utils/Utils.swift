//
//  Utils.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 3/3/25.
//

import Foundation

func formatDate(from dateString: String?) -> String? {
    guard let dateString = dateString else{ return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}
