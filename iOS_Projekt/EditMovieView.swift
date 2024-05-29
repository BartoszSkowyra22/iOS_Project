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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    var movie:Movie
    @State var editMovieName: String = ""
    @State var editMovieYear: String = ""
    @State var editMovieDuration: String = ""
    @State var editMovieRating: Double = 0
    @State private var editSelectedCategory: Category?
    
    
    @State private var yearError: String = ""
    @State private var durationError: String = ""
    @State private var isYearCorrect: Bool = true
    @State private var isDurationCorrect: Bool = true
    @State private var showingAlert = false
    
    
    var body: some View {
        VStack{
            //MARK: Walidacja edycji - zmiana kategorii
            //MARK: Zapisywanie emotek
            //MARK: Porozrzucać na pliki
            Text("Podaj nową nazwę filmu:")
            TextField("\(movie.name ?? "Brak nazwy")", text: $editMovieName)
                .font(.system(size: 20))
            
            Text("Podaj nowy rok premiery")
            TextField("\(movie.year)", text: $editMovieYear)
                .keyboardType(.numberPad)
                .onChange(of: editMovieYear, initial: false) {
                    validateYear()
                }
            
            if !isYearCorrect {
                Text(yearError).foregroundColor(.red)
            }
            
            Text("Podaj nowy czas trwania")
            TextField("\(movie.duration)", text: $editMovieDuration)
                .keyboardType(.numberPad)
                .onChange(of: editMovieDuration, initial: false) {
                    validateDuration()
                }
            
            if !isDurationCorrect {
                Text(durationError).foregroundColor(.red)
            }
            
            Text("Podaj nową ocenę (poprzednia: \(String(format: "%.1f", movie.rating)))")
            VStack {
                HStack {
                    Text("Ocena: \(String(format: "%.1f", editMovieRating))")
                    Spacer()
                }
                Slider(value: $editMovieRating, in: 0...10, step: 0.1)
            }
            
            Picker("Kategoria", selection: $editSelectedCategory) {
                //Text("Wybierz").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name ?? "Nieznane").tag(category as Category?)
                }
            }
            .pickerStyle(.segmented)
            .onAppear {
                if editSelectedCategory == nil {
                    editSelectedCategory = movie.toCategory
                }
            }
            
            
            if isYearCorrect && isDurationCorrect {
                Button("Zapisz"){
                    editMovie()
                }
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Zapisano"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
            }
            
        }
        .padding()
    }
    
    private func editMovie() {
        
        if self.editMovieName != ""{
            movie.name = self.editMovieName
        }
        
        if self.editMovieYear != "" {
            movie.year = Int16(self.editMovieYear) ?? 0
        }
        
        if self.editMovieDuration != "" {
            movie.duration = Int16(self.editMovieDuration) ?? 0
        }
        
        if self.editMovieRating != 0 {
            movie.rating = Double(self.editMovieRating)
        }
        
        if self.editSelectedCategory != movie.toCategory {
            movie.toCategory = self.editSelectedCategory
        }
        
        
        do {
            try self.viewContext.save()
            
            isYearCorrect = true
            isDurationCorrect = true
            showingAlert = true
            yearError = ""
            durationError = ""
            
        } catch {
            let nsError = error as NSError
            fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func validateYear() {
        if let year = Int(editMovieYear), year >= 1900, year <= 2024 {
            yearError = ""
            isYearCorrect = true
        } else {
            yearError = "Rok premiery musi być liczbą z przedziału 1900-2024"
            isYearCorrect = false
        }
    }
    
    private func validateDuration() {
        if let duration = Int(editMovieDuration), duration >= 1, duration <= 200 {
            durationError = ""
            isDurationCorrect = true
        } else {
            durationError = "Czas trwania musi być liczbą w przedziale 1-200"
            isDurationCorrect = false
        }
    }
}
