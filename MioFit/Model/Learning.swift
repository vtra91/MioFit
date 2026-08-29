import SwiftUI

struct Learning: View {
    @State var isOn = false
    @State var stack = [String]()
    @Environment(\.dismiss) var dismiss
    var body: some View {
                ZStack {
                    Color.red
                    VStack {
                        NavigationStack(path: $stack) {
                            Form {
                                Text("dsfadf")
                                NavigationLink("aaa", value: "hahaha")
                                List {
                                    Text("123")
                                    Circle() .frame(width: 30)
                                    Text("45")
                                    Button("haha") {
                                        stack = ["Бутерброд", "Счаем"]
                                    }
        
        
                                }
        
                                Section(header: Toggle(isOn: $isOn) { Text("123")}) {
                                    Text("123")
                                    Circle() .frame(width: 30)
                                    Text("45")
                                }
                            }
                            .navigationDestination(for: String.self) { screen in
                                Text("\(screen) LOL")
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar {
                                        ToolbarItem(placement: .principal) {
                                            Button(action: {dismiss()}, label:{Image(systemName: "trash")})
                                        }
                                    }
                                    .navigationTitle("хуитаа")
        
                        }
//                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("TITle")
        
        
        
                        }
        
                    }
                }

    }
    init() {
        let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont(name: "AmericanTypewriter-CondensedBold", size: 35) ?? UIFont()]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont(name: "AmericanTypewriter-CondensedBold", size: 20) ?? UIFont()]
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            UINavigationBar.appearance().compactAppearance = navBarAppearance
        }
}

#Preview {
    Learning()
}
