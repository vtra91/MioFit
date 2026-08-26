import SwiftUI

struct PasswordReset: View {
    @State var passwordInput: String = ""
    @State var confirmPasswordInput: String = ""
    
    @State private var showTip = false
    
    var isNotEmpty: Bool { !confirmPasswordInput.isEmpty && !passwordInput.isEmpty }
    
    var passwordValidLevel: String {
        if passwordInput.count > 7 && passwordInput.contains(where: {"*!#@".contains($0)}) && passwordInput.contains(where: {$0.isUppercase}) {
            return "Strong"
        } else if passwordInput.count > 5 && passwordInput.contains(where: {"*!".contains($0)}) && passwordInput.contains(where: {$0.isUppercase}) {
            return "Medium"
        } else {
            return "Weak"
        }
    }
    var isPasswordIdentical: Bool {
        passwordInput == confirmPasswordInput && !passwordInput.isEmpty
    }
    var isBothPasswordVaild: Bool {
        isPasswordIdentical && isNotEmpty && confirmPasswordInput.count > 4
    }
    
    @State var isEyeOpened: Bool = false

    let levels = ["Легкий", "Средний", "Сильный"]
    var body: some View {
        ZStack(alignment: .top) {
            Color.mainColorBG.ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: 44)
                        
                        Spacer()
                        
                        Text("Смена пароля")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showTip.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                        .frame(width: 44, height: 44)
                                                
                        .popover(isPresented: $showTip, attachmentAnchor: .point(.bottom), arrowEdge: .top) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Пароль должен содержать:")
                                    .font(.headline)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Label("Минимум 5 символов", systemImage: "minus")
                                    Label("Заглавную букву", systemImage: "minus")
                                    Label("Спецсимвол (!@#$)", systemImage: "minus")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .environment(\.font, .system(size: 6))
                            }
                            .padding()
                            .presentationCompactAdaptation(.popover)
                        }
                    }
                    .padding(.horizontal)

                    VStack {
                        HStack {
                            PasswordField(input: $passwordInput, placeholder: "Введите новый пароль")
                        }
                        .background() {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray)
                        }
                        .padding(.horizontal)

                        HStack {
                            let strength = PasswordStrength(rawValue: passwordValidLevel) ?? .weak
                                                    
                            ForEach(0..<3, id: \.self) {i in
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(i < strength.lines ? strength.color : .gray.opacity(0.5))
                                    .frame(width: 70, height: 4)
                            }
                            Text(strength.title)
                                .foregroundStyle(strength.color)
                                .frame(width: 90)
                        }
                        .padding(.vertical, 4)
                    }
//TODO: анимация уведомления о схожести паролей наезжает на поле ввода, надо починить
                    VStack {
                        PasswordField(input: $confirmPasswordInput, placeholder: "Повторите новый пароль")
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, isNotEmpty ? 0 : nil)
                    }
                    if isNotEmpty {
                            HStack {
                                Image(systemName: isPasswordIdentical ? "checkmark" : "xmark")
                                Text(isPasswordIdentical ? "Пароли совпадают" : "Пароли не совпадают")
                                Spacer()
                            }
                            .foregroundStyle(isPasswordIdentical ? .green : .red)
                            .padding(.leading)
                            .padding(.bottom)
                            .transition(.opacity.combined(with: .move(edge: .top)))

                    }
                    

                }
                .background() {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                }
                .padding()
                .animation(.bouncy(duration: 0.35, extraBounce: 0.1), value: isNotEmpty)
                .animation(.bouncy(duration: 0.35, extraBounce: 0.1), value: isPasswordIdentical)
                Button (
                    action: {
                        
                    }, label: {
                        Text("Сохранить")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(isBothPasswordVaild ? Color.blue : Color.blue.opacity(0.5))

                            }

                    }
                )
                .disabled(!isNotEmpty)
                .padding(.horizontal)
                .animation(.bouncy(duration: 0.35, extraBounce: 0.1), value: isNotEmpty)
                .animation(.bouncy(duration: 0.35, extraBounce: 0.1), value: isBothPasswordVaild)
            }
            .padding(.top)
           
        }
        
    }
}

struct PasswordField: View {
    @Binding var input: String
    @State var isPasswordVisible: Bool = false
    @FocusState var isFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .trailing) {
            if !isPasswordVisible {
                SecureField(placeholder, text: $input)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $input)
                    .focused($isFocused)
            }
                Button (
                    action: {
                        isPasswordVisible.toggle()
                        DispatchQueue.main.async {
                                                    isFocused = true
                                                }
                    }, label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                    }
                )
        }
         .passwordFieldStyle()
    }
}

enum PasswordStrength: String {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"
    
    var title: String {
        switch self {
            case .weak: return "Слабый"
            case .medium: return "Средний"
            case .strong: return "Сильный"
        }
    }
    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .yellow
        case .strong: return .green
        }
    }
    var lines: Int {
        switch self {
            case .weak: return 1
            case .medium: return 2
            case .strong: return 3
        }
    }
}

extension View {
    func securePasswordField() -> some View {
        Image(systemName: "trash")
    }
}

#Preview {
    PasswordReset()
}
