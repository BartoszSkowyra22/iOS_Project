//
//  MovieView.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 28/05/2024.
//

import SwiftUI
import CoreData

struct MovieView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Movie.name, ascending: true)], animation: .default)
    //MOVIE VIEW
    private var movies: FetchedResults<Movie>
    var movie:Movie
    //    @State var editMovieName: String = ""
    //    @State var editMovieYear: String = ""
    //    @State var editMovieDuration: String = ""
    //    @State var editMovieRating: String = ""
    
    @State var dropItems: [String] = []
    @State var items: [String] = DraggableItemModel.items
    
    var body: some View {
        VStack{
            if let categoryName = movie.toCategory?.name {
                switch categoryName {
                case "Kreskówka":
                    Image("kreskowka")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                case "Film romantyczny":
                    Image("romantyczny")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                case "Film akcji":
                    Image("akcja")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                case "Horror":
                    Image("horror")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                default:
                    Image("")
                }
            }
            Spacer()
            Text("Nazwa filmu: \(movie.name ?? "Brak nazwy")")
                .font(.system(size: 23))
            Text("Kategoia: \(movie.toCategory?.name ?? "Brak kategorii")")
            Text("Rok premiery: \(movie.year)")
            Text("Czas trwania: \(movie.duration) minut ")
            Text("Ocena: \(String(format: "%.1f", movie.rating))")
            NavigationLink(destination: EditMovieView(movie: movie)) {
                Text("Edytuj dane")
            }
            VStack {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .scaleEffect(CGFloat(2.0))
                            .foregroundColor(.white)
                            .draggable(item)
                    }
                    .frame(minWidth: 60, minHeight: 60)
                    .background(Color.gray)
                    .cornerRadius(10)
                }
                
                DropView(dropItems: $dropItems)
                    .dropDestination(for: String.self) { droppedItem, location in
                        dropItems += droppedItem
                        return true
                    }
            }
            .padding()
        }
        
    }
}

