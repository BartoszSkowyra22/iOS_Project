//
//  DropView.swift
//  iOS_Projekt
//
//  Created by Bartosz Skowyra on 29/05/2024.
//

import SwiftUI

struct DropView: View {
    @Binding var dropItems: [String]
    @State private var count: CGFloat = 1.0
    
    var body: some View {
        
        
        VStack {
            Text("Twoje odczucie: ")
                .font(.system(size: 20))
                .padding()
            
            VStack{
                List {
                    ForEach(dropItems, id: \.self) { item in
                        Text(item)
                            .scaleEffect(count)
                            .onTapGesture {
                                count += 0.2
                            }
                            .onLongPressGesture {
                                count = 1.0
                            }
                    }
                    .onDelete(perform: removeRows)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
        }
    }
    
    private func removeRows(at offsets: IndexSet) {
        dropItems.remove(atOffsets: offsets)
    }
}

