import SwiftUI

struct Tabview : View {
    @Binding var isLogin : Bool
    @State var tabbarColor: UIColor = .gray
    
    var body: some View {
  
                TabView {
                    ContentView(tabbarColor : $tabbarColor)
                        .tabItem{
                            Image(systemName: "globe.asia.australia")
                            Text("Explore")
                        }
                    SearchView(tabbarColor : $tabbarColor)
                        .tabItem {
                            Image(systemName : "magnifyingglass")
                            Text("Search")
                        }
                    AccountView(isLogin : $isLogin,tabbarColor : $tabbarColor)
                        .tabItem {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Account")
                        }
                }.onAppear {
                    UITabBar.appearance().unselectedItemTintColor = .gray
                }
                .accentColor(.pink)

    }
}


//struct Tabview_Previews: PreviewProvider {
//    static var previews: some View {
//        Tabview()
//            .environmentObject(EventViewModel())
//    }
//}
