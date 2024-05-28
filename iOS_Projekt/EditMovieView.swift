//
//  EditMovieView.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 28/05/2024.
//

import Foundation
import SwiftUI
import CoreData

struct EditMovieView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Movie.name, ascending: true)], animation: .default)
    
    private var movies: FetchedResults<Movie>
    var movie:Movie
    @State var editMovieName: String = ""
    @State var editMovieYear: String = ""
    @State var editMovieDuration: String = ""
    @State var editMovieRating: String = ""
    
    var body: some View {
        VStack{
            TextField("Podaj nową nazwę filmu", text: $editMovieName)
            TextField("Podaj nowy rok premiery", text: $editMovieYear)
                .keyboardType(.numberPad)
            TextField("Podaj nowy czas trwania", text: $editMovieDuration)
                .keyboardType(.numberPad)
            TextField("Podaj nową ocenę", text: $editMovieRating)
                .keyboardType(.numberPad)
            
            Button(action: ({
                movie.name = self.editMovieName
                movie.year = Int16(self.editMovieYear) ?? 0
                movie.duration = Int16(self.editMovieDuration) ?? 0
                movie.rating = Double(self.editMovieRating) ?? 0
                //MARK: dog.toBreed = self.dog.toBreed
                do {
                    try self.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
                }
            })) {
                Text("Edytuj")
            }
        }
    }
}
