import SwiftUI

// Модель данных для клиента
struct Client: Identifiable {
    let id = UUID()
    let name: String
    let isActive: Bool
    let isMale: Binding<Bool> // Упрощенно для выбора аватарки-эмодзи
}

struct ClientsListView: View {
    // Входные данные на основе изображения
    let clients = [
        Client(name: "Иванов Иван Иванович", isActive: true, isMale: .constant(true)),
        Client(name: "Петрова Мария Сергеевна", isActive: true, isMale: .constant(false)),
        Client(name: "Сидоров Петр Александрович", isActive: false, isMale: .constant(true)),
        Client(name: "Козлова Анна Викторовна", isActive: true, isMale: .constant(false)),
        Client(name: "Морозов Дмитрий Николаевич", isActive: true, isMale: .constant(true))
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Color(red: 0.96, green: 0.96, blue: 0.98)
//                    .ignoresSafeArea()
                Color.red
                VStack(spacing: 16) {
                    HStack {
                        TextField("Поиск", text: $searchText)

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.95))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ForEach(clients.indices, id: \.self) { index in
                            let client = clients[index]
                            
                            NavigationLink(destination: Text("Профиль: \(client.name)")) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.92, green: 0.92, blue: 0.94))
                                            .frame(width: 44, height: 44)
                                        Text(client.isMale.wrappedValue ? "👨‍💼" : "👩‍💼")
                                            .font(.system(size: 24))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(client.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(client.isActive ? Color.green : Color.gray)
                                                .frame(width: 8, height: 8)
                                            Text(client.isActive ? "Активен" : "Неактивен")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.8))
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                            }
                            
                            if index < clients.count - 1 {
                                Divider()
                                    .padding(.leading, 74)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(14)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            .navigationTitle("Клиенты")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
#Preview {
    ClientsListView()
}
