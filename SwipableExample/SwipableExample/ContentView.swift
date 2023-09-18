//
//  ContentView.swift
//  SwipableExample
//
//  Created by Nicolas Anjoran on 18/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(1...100).map { "Item \($0)" }, id: \.self) { item in
                    Swipable {
                        Button {
                            print("Button tapped")
                        } label: {
                            HStack {
                                Image(systemName: "person.crop.circle.fill").font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text("Person Name").foregroundColor(.primary)
                                    Text("Job name").font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                    .swipeLeading(icon: Image(systemName: "text.line.first.and.arrowtriangle.forward"), color: Color.purple) {
                        print("Leading Action!!!!")
                    }
                    .swipeTrailing(icon: Image(systemName: "text.line.last.and.arrowtriangle.forward"), color: Color.blue) {
                        print("Trailing Action!!!!")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
