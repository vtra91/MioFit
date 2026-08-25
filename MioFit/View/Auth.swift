import SwiftUI

struct Auth: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    //TODO: Вынести поля в VM
    @State var loginInput: String = ""
    @State var passwordInput: String = ""
    
    @State var isSheetShowing: Bool = false

    var isNotEmpty: Bool { !loginInput.isEmpty && !passwordInput.isEmpty }
    var body: some View {
        ZStack {
            Color.mainColorBG
            VStack {
                Text("МиоТренинг")
                    .font(.largeTitle).bold()
                    .foregroundStyle(Color.mainColorBlack)
                LoginInputField(label: "Логин",placeholder: "Введите логин", isPassword: false, input: $loginInput)
                    .padding(.bottom,4)
                LoginInputField(label: "Пароль",placeholder: "Введите пароль", isPassword: true ,input: $passwordInput)
                Button (
                    action: {
                        
                    }, label: {
                        Text("Войти")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(isNotEmpty ? Color.blue : Color.blue.opacity(0.5))

                            }

                    }
                )
                .disabled(!isNotEmpty)
                .padding()
                
                Button (
                    action: {
                        isSheetShowing.toggle()
                    }, label: {
                        Text("Забыли пароль?")
                    }
                )
                .sheet(isPresented: $isSheetShowing) {
                    PasswordReset()
                }
 

            }
            .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
        }
        .onTapGesture(count: 2) {
            isDarkMode.toggle()
        }
        .ignoresSafeArea()
    }
}
struct LoginInputField: View {
    var label: String
    var placeholder: String
    var isPassword: Bool
    @Binding var input: String
    @State var isHidden: Bool = false
    

    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundStyle(Color.lightGrayText)
                    .padding(.leading, 16)
                Spacer()
            }
            
            //TODO: пофиксить скрывающуюся клавиатуру при смене приватности пароля
            if isHidden {
                SecureField(placeholder, text: $input)
                    .passwordFieldStyle()
                    .eye(isPassword, $isHidden, isEyeOpened: isHidden)
            } else {
                TextField(placeholder, text: $input)
                    .passwordFieldStyle()
                    .eye(isPassword, $isHidden, isEyeOpened: isHidden)
            }

        }
        .padding(.horizontal)
    }
}


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

    let levels = ["Легкий", "Средний", "Сильный"]
    var body: some View {
        ZStack(alignment: .top) {
//TODO: исправить кривое отображение цвета внизу экрана

            Color.mainColorBG
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
                                    Label("Минимум 5 символов", systemImage: "bolt.horizontal.fill")
                                    Label("Заглавную букву", systemImage: "bolt.horizontal.fill")
                                    Label("Спецсимвол (!@#$)", systemImage: "bolt.horizontal.fill")
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
                        TextField("Введите новый пароль", text: $passwordInput)
                            .passwordFieldStyle()
                        HStack {
                            let strength = PasswordStrength(rawValue: passwordValidLevel) ?? .weak
                        
//TODO: сделать размер .title сложности фиксированным по ширине
                            
                            ForEach(0..<3, id: \.self) {i in
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(i < strength.lines ? strength.color : .gray.opacity(0.5))
                                    .frame(width: 70, height: 4)
                            }
                            Text(strength.title)
                                .foregroundStyle(strength.color)
                        }
                    }
                    Divider()
                    VStack {
                        TextField("Повторите новый пароль", text: $confirmPasswordInput)
                            .passwordFieldStyle()
                    }
                    HStack {
//TODO: добавить функционал, чтобы нельзя было войти если не совпадают
                        Image(systemName: isPasswordIdentical ? "checkmark" : "xmark")
                        Text(isPasswordIdentical ? "Пароли совпадают" : "Пароли не совпадают")
                        Spacer()
                    }
                    .foregroundStyle(isPasswordIdentical ? .green : .red)
                    .padding(.leading)
                    .padding(.bottom)
                }
                .background() {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                }
                .padding()
                Button (
                    action: {
                        
                    }, label: {
                        Text("Войти")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(isNotEmpty ? Color.blue : Color.blue.opacity(0.5))

                            }

                    }
                )
                .disabled(!isNotEmpty)
                .padding()
            }
            .padding(.top)
           
        }
        
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

extension Color {
    static var lightGrayBackground: Color { Color.gray.opacity(0.2)}
    static var lightGrayText: Color { .black.opacity(0.6)}
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension View {
    func passwordFieldStyle() -> some View {
        self
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background() {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        }
    }
    func eye(_ isPassword: Bool, _ isPrivate:  Binding<Bool>, isEyeOpened: Bool)  -> some View {
        self
            .overlay {
            if isPassword
                {
                HStack {
                    Spacer()
                        Button(
                            action: {
                                withAnimation(.easeInOut(duration:0.2)) {
                                    isPrivate.wrappedValue.toggle()
                                }
                            },
                            label: {
                                Image(systemName: isEyeOpened ? "eye.slash" : "eye")
                                    .foregroundStyle(Color.lightGrayText)
                            }
                        )
                        .padding(.trailing)
                    }
                }
        }
    }
}
#Preview {
    PasswordReset()
}
