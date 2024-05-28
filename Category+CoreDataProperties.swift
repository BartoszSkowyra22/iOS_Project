//
//  Category+CoreDataProperties.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 28/05/2024.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var toMovie: NSSet?

}

// MARK: Generated accessors for toMovie
extension Category {

    @objc(addToMovieObject:)
    @NSManaged public func addToToMovie(_ value: Movie)

    @objc(removeToMovieObject:)
    @NSManaged public func removeFromToMovie(_ value: Movie)

    @objc(addToMovie:)
    @NSManaged public func addToToMovie(_ values: NSSet)

    @objc(removeToMovie:)
    @NSManaged public func removeFromToMovie(_ values: NSSet)

}

extension Category : Identifiable {

}
