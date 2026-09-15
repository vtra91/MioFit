//import Foundation
//import Combine
//import SwiftUI
//
//struct LoginModel: Identifiable {
//    let id = UUID()
//    var name: String
//}
//
//final class LoginVM: ObservableObject {
//    @Published var name: String = ""
//    @Published var namesList = [LoginModel]()
//    func addName(_ name: String) {
//        self.name = name
//        let newName = LoginModel(name: name)
//        namesList.append(newName)
//    }
//}
//
//struct Learning: View {
//    @StateObject var vm = LoginVM()
//    @StateObject var path = MioRouter()
//    var body: some View {
//        NavigationStack(path: $path.path) {
//            Form {
//                ForEach(vm.namesList) { i in
//                    Section {
//                        NavigationLink(value: "Пиво") {
//                            Text(i.name)
//                                .foregroundStyle(.black)
//                        }
//                           
//                    }
//                }
//            }
//            .navigationDestination(for: String.self) { i in
//                Image(systemName: "trash")
//                    .background {
//                        Color.red
//                    }
//                    .clipShape(Circle())
//            }
//            
//            Button("Добавь меня!") {
//                vm.addName("Женя")
//            }
//        }
//    }
//}
//
//#Preview {
//    Learning()
//}
