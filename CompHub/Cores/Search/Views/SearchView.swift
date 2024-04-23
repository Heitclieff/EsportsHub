import SwiftUI

struct SearchView: View {
    @State private var searchIsActive = false
    @ObservedObject var query = SearchModel()
    @State var searchText = "" 	
    @Binding var tabbarColor : UIColor
    
    var body: some View {
        NavigationView {
            NavigationStack {
                if searchText.isEmpty {
                    SuggestionsView()
                        .navigationTitle("Search")
                }
                else {
                    SearchResultView(results : query.results)
                        .navigationTitle("Search")
                }
            }
        }
        .searchable(text: $searchText  , prompt: "Event or Games")
        .onChange(of: searchText) { NewQuery in
            self.query.results = []
            self.query.SearchFromQuery(searchQuery: NewQuery)
        }
        .onAppear {
            self.tabbarColor = .gray
        }
    }
}


struct SuggestionsView: View {

    var body: some View {
        VStack (alignment : .leading) {
            Text("Suggestion")
                .fontWeight(.semibold)
                .padding(.leading)
            List {
                Text("Valorant Champions")
                Text("Leauge of Legends")
                Text("Dota2")
            }
            .listStyle(PlainListStyle())
        }

    }
}

struct SearchResultView: View {
    var results: [EventTask]
    
    var body: some View {
        List (results) { result in
            NavigationLink {
                EventView(event: result)
            } label: {
                Text(result.title)
            }
            
        }
        .listStyle(InsetGroupedListStyle())
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//            .environmentObject(SearchModel())
//    }
//}
	


