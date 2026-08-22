import SwiftUI

struct SettingsView: View {
    @State private var username = ""
    @State private var isNotificationsEnabled = false
    @State private var selectedTheme = "Светлая"
    
    let themes = ["Светлая", "Темная", "Системная"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Профиль")) {
                    TextField("Имя пользователя", text: $username)
                }
                
                Section(header: Text("Уведомления и тема")) {
                    Toggle("Включить уведомления", isOn: $isNotificationsEnabled)
                    
                    Picker("Тема оформления", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                }
                
                Section {
                    Button("Сохранить изменения") {
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
