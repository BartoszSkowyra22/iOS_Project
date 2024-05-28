//
//  ContentView.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 28/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.name, ascending: true)], animation: .default)
    private var movies: FetchedResults<Movie>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @State private var movieName: String = ""
    @State private var movieYear: String = ""
    @State private var movieDuration: String = ""
    @State private var movieRating: Double = 0
    @State private var selectedCategory: Category?
    //KONIEC przeklejonego
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Nazwa Filmu", text: $movieName)
                    TextField("Rok Premiery", text: $movieYear)
                        .keyboardType(.numberPad)
                    TextField("Czas Trwania", text: $movieDuration)
                        .keyboardType(.numberPad)
                    VStack {
                        HStack {
                            Text("Ocena: \(String(format: "%.1f", movieRating))")
                            Spacer()
                        }
                        Slider(value: $movieRating, in: 0...10, step: 0.1)
                    }
                    
                    Picker("Kategoria", selection: $selectedCategory) {
                        Text("Wybierz").tag(nil as Category?)
                        ForEach(categories, id: \.self) { category in
                            Text(category.name ?? "Nieznane").tag(category as Category?)
                        }
                    }
                    if categories.count == 0 {
                        Button("Dodaj Kategorie") {
                            addCategory()
                        }
                    }
                    
                    Button("Dodaj Film") {
                        addMovie()
                    }
                }
                
                List {
                    ForEach(categories) { category in
                        Section(header: Text("\(category.name ?? "Nieznane")")) {
                            ForEach(category.moviesArray) { movie in
                                NavigationLink(destination: EditMovieView(movie: movie)) {
                                    //MARK: Poprawić wyświetlanie
                                    Text("\(movie.name ?? "Nieznane") - powstał w \(movie.year)")
                                }
                            }
                            .onDelete(perform: deleteMovie)
                        }
                    }
                }
                .navigationTitle("Filmy")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func addMovie() {
        guard let year = Int16(movieYear), let duration = Int16(movieDuration), let rating = Double?(movieRating), let category = selectedCategory else {
            return
        }
        
        let newMovie = Movie(context: viewContext)
        newMovie.name = movieName
        newMovie.year = year
        newMovie.duration = duration
        newMovie.rating = rating
        newMovie.toCategory = category
        
        do {
            try viewContext.save()
            movieName = ""
            movieYear = ""
            movieDuration = ""
            movieRating = 0
            selectedCategory = nil
        } catch {
            let nsError = error as NSError
            fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteMovie(offsets: IndexSet) {
        withAnimation {
            offsets.map { movies[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addCategory() {
        let categories = ["Komedia", "Film romantyczny", "Film akcji", "Horror"]
        for categoryName in categories {
            let newCategory = Category(context: viewContext)
            newCategory.name = categoryName
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Nierozpoznany błąd \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private extension Category {
    var moviesArray: [Movie] {
        return (toMovie?.allObjects as? [Movie]) ?? []
    }
}


//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
