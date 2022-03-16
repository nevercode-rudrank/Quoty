//
//  ContentView.swift
//  Shared
//
//  Created by Rudrank Riyam on 16/03/22.
//

import SwiftUI
import QuoteKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(Authors.demoAuthors) { author in
                    NavigationLink(destination: AuthorDetailView(author: author)) {
                        AuthorRow(author: author)
                    }
                }
            }
            .navigationTitle("Authors")
#if os(macOS)
            .frame(minWidth: 300)
#endif
        }
    }
}

struct AuthorDetailView: View {
    @State private var quotes: Quotes?
    var author: Author

    var body: some View {
        ScrollView(showsIndicators: false) {
            AsyncImage(url: QuoteKit.authorImage(with: author.slug)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }

            Text(author.name)
                .font(.largeTitle)
                .padding(.bottom)

            Text(author.bio)
                .font(.title2)
                .lineSpacing(2)
                .padding(.bottom)

            Text("Quotes")
                .font(.largeTitle)
                .padding()

            if let quotes = quotes {
                ForEach(quotes.results) { quote in
                    Text(quote.content)
                        .font(.callout)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

        }
        .padding(.horizontal)
        .task {
            do {
                quotes = try await QuoteKit.quotes(authors: [author.slug])
            } catch {

            }
        }
    }
}

struct AuthorRow: View {
    var author: Author

    var body: some View {
        HStack {
            AsyncImage(url: QuoteKit.authorImage(with: author.slug)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)

            Text(author.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Authors {
    static var demoAuthors: [Author] {
        if let path = Bundle.main.path(forResource: "Authors", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let model = try JSONDecoder().decode(Authors.self, from: data)
                return model.results
            } catch let error {
                print("parse error: \(error.localizedDescription)")
                return []
            }
        } else {
            print("Invalid filename/path.")
            return []
        }
    }
}
