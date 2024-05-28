//
//  Movie+CoreDataProperties.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 28/05/2024.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var name: String?
    @NSManaged public var duration: Int16
    @NSManaged public var year: Int16
    @NSManaged public var rating: Double
    @NSManaged public var toCategory: Category?

}

extension Movie : Identifiable {

}
