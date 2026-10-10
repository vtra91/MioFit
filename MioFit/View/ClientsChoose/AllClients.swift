import SwiftUI

struct ClientsListView: View {
    @State private var searchText = ""
    @StateObject private var VM = AllClientsVM()
    
    var body: some View {
        ScrollView {
            NavigationStack {
                ZStack {
                    Color(red: 0.96, green: 0.96, blue: 0.98)
                        .ignoresSafeArea()
                    VStack(spacing: 16) {
                        VStack(spacing: 0) {
                            ForEach(Array(VM.characters.enumerated()), id: \.element.id) { index, character in
                                
                                NavigationLink(destination: Text("Профиль: \(character.name)")) {
                                    
                                    HStack(spacing: 14) {
                                        
                                        // 1. АВАТАРКА (AsyncImage загружает картинку по URL)
                                        AsyncImage(url: URL(string: character.image)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } else if phase.error != nil {
                                                // Если ошибка загрузки или нет интернета
                                                Text("").font(.system(size: 24))
                                            } else {
                                                // Пока грузится
                                                ProgressView()
                                            }
                                        }
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1))
                                        
                                        // Если хочешь вернуть ЭМОДЗИ вместо картинки, замени блок выше на этот:
                                        /*
                                         ZStack {
                                         Circle().fill(Color(red: 0.92, green: 0.92, blue: 0.94)).frame(width: 44, height: 44)
                                         Text(character.gender == "Male" ? "👨‍💼" : (character.gender == "Female" ? "👩‍💼" : "👽"))
                                         .font(.system(size: 24))
                                         }
                                         */
                                        
                                        // 2. ИМЯ И СТАТУС
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(character.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                            
                                            HStack(spacing: 6) {
                                                // Определяем цвет и текст статуса
                                                let isAlive = character.status == "Alive"
                                                let isDead = character.status == "Dead"
                                                let statusColor: Color = isAlive ? .green : (isDead ? .red : .gray)
                                                let statusText: String = isAlive ? "Жив" : (isDead ? "Мертв" : "Неизвестно")
                                                
                                                Circle()
                                                    .fill(statusColor)
                                                    .frame(width: 8, height: 8)
                                                
                                                Text(statusText)
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
                                
                                // 3. РАЗДЕЛИТЕЛЬ (рисуем только если это не последний элемент)
                                if index < VM.characters.count - 1 {
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
                .searchable(text: $searchText, prompt: "Поиск")
                
            }
        }
        .onAppear {
            VM.collectRMCharacters()
        }
    }
}
#Preview {
    ClientsListView()
}
