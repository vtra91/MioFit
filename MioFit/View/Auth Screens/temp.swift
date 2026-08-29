import SwiftUI
import Foundation


struct Temp: View {
    @FocusState var isKeyboardFocused: Bool
    @State var text: String = ""
    @State var path = NavigationPath()
    var digitalText: [String] {
        let characters = Array(text)
        return (0..<6).map {ind in
            ind < characters.count ? String(characters[ind]) : ""
        }
    }
    var body: some View {
        NavigationStack(path: $path) {
            let binding = Binding (
                get: {
                    self.text
                }, set: { newValue in
                    let filtered = newValue.filter {$0.isNumber}
                    let sixDigit = filtered.prefix(6)
                    let prevCount = self.text.count
                    self.text = String(sixDigit)
                    if prevCount < 6 && sixDigit.count == 6 {
                        path.append("Сменить пароль")
                    }
                }
            )
            VStack(spacing: 4) {
                Text("Введите код подтверждения")
                    .font(.title2).bold()
                Text("Отправили на ")
                    .font(.callout) + Text("me•••••@mail.ru")
                    .font(.callout.weight(.semibold))
            }.padding(.bottom)
            
            TextField("", text: binding)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .accentColor(.clear)
                .foregroundStyle(.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay() {
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { i in
                            Digit(text: digitalText[i])
                        }
                    }
                    .allowsHitTesting(false)
                }
                .contentShape(Rectangle())
                .onAppear {
                    isKeyboardFocused = true
                }
                .navigationDestination(for: String.self) { _ in
                    PasswordReset()
                }
        Button(action: {}, label: {Text("Отправить ещё раз")})
                .padding(.top)
        }
        
    }
}
struct Digit: View {
    var text: String
    var isTextNotEmpty: Bool {
        text.count > 0
    }
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 45, height: 50)
            .overlay {
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isTextNotEmpty ? .blue : .gray.opacity(0.5))
                        .frame(height: 2)
                }
            } .animation(.easeInOut(duration: 0.2), value: isTextNotEmpty)
    }
}
#Preview {
    Temp()
}
