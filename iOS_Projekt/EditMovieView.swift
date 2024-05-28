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
    @State var editMovieRating: Double = 0
    
    
    //    Text("Nazwa filmu: \(movie.name ?? "Brak nazwy")")
    //        .font(.system(size: 23))
    //    Text("Kategoia: \(movie.toCategory?.name ?? "Brak kategorii")")
    //    Text("Rok premiery: \(movie.year)")
    //    Text("Czas trwania: \(movie.duration) minut ")
    //    Text("Ocena: \(String(format: "%.1f", movie.rating))")
    //    NavigationLink(destination: EditMovieView(movie: movie)) {
    //        Text("Edytuj dane")
    //    }
    
    var body: some View {
        VStack{
            //MARK: Walidacja edycji - zapis tylko, gdy są wszystkie dane wypełnione, zmiana kategorii, walidacja roku i czasu
            //MARK: Dodać odświeżanie stron po edycji
            //MARK: Porozrzucać na pliki
            //MARK: Zmienić przycisk zapisu
            //MARK: Po zapisaniu przechodzi do innego widoku
            Text("Podaj nową nazwę filmu:")
            TextField("\(movie.name ?? "Brak nazwy")", text: $editMovieName)
                .font(.system(size: 20))
            
            Text("Podaj nowy rok premiery")
            TextField("\(movie.year)", text: $editMovieYear)
                .keyboardType(.numberPad)
                .font(.system(size: 20))
            
            Text("Podaj nowy czas trwania")
            TextField("\(movie.duration)", text: $editMovieDuration)
                .keyboardType(.numberPad)
                .font(.system(size: 20))
            
            Text("Podaj nową ocenę (poprzednia: \(String(format: "%.1f", movie.rating)))")
            VStack {
                HStack {
                    Text("Ocena: \(String(format: "%.1f", editMovieRating))")
                    Spacer()
                }
                Slider(value: $editMovieRating, in: 0...10, step: 0.1)
            }
            //            TextField("\(String(format: "%.1f", movie.rating))", text: $editMovieRating)
            //                .keyboardType(.numberPad)
            //                .font(.system(size: 20))
            
            Button(action: ({
                movie.name = self.editMovieName
                movie.year = Int16(self.editMovieYear) ?? 0
                movie.duration = Int16(self.editMovieDuration) ?? 0
                movie.rating = Double(self.editMovieRating)
                //MARK: Edycja kategorii
                do {
                    try self.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
                }
            })) {
                Text("Zapisz")
            }
            
        }
        .padding()
    }
}
