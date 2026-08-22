import SwiftUI

struct SettingsView: View {
    @State private var username = ""
    @State private var isNotificationsEnabled = false
    @State private var selectedTheme = "Светлая"
    
    let themes = ["Светлая", "Темная", "Системная"]
    
    var body: some View {
        NavigationStack {
            Form {
                // Секция 1: Профиль пользователя
                Section(header: Text("Профиль")) {
                    TextField("Имя пользователя", text: $username)
                }
                
                // Секция 2: Настройки приложения
                Section(header: Text("Уведомления и тема")) {
                    Toggle("Включить уведомления", isOn: $isNotificationsEnabled)
                    
                    Picker("Тема оформления", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                }
                
                // Секция 3: Действия
                Section {
                    Button("Сохранить изменения") {
                        // Действие при нажатии
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}
#Preview {
    SettingsView()
}
