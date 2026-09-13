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
                Button (
                    action: {
                        isDarkMode.toggle()
                    },
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 80, height: 40)
                                .foregroundStyle(isDarkMode ? .black.opacity(0.8) : .blue)
                            Circle()
                                .fill(isDarkMode ? .white.opacity(0.7) : .yellow)
                                .frame(width: 30)
                                .padding(isDarkMode ? .leading : .trailing, 38)
                            VStack {
                                HStack(spacing: 16) {
                                    ForEach(0..<2) { _ in
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 4)
                                    }
                                }
                                Circle()
                                    .fill(.white)
                                    .frame(width: 5)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 2)
                                    .padding(.trailing, 8)
                            }
                            .offset(x: -14, y: isDarkMode ? 0 : -40)
                            
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                                .offset(x:isDarkMode ? -20 : 18, y: isDarkMode ? 35 : 15)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                      
                    }
                )
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
                    OneTimePassword()
                }
 

            }
            .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
        }
        .ignoresSafeArea()
    }
}
struct LoginInputField: View {
    var label: String
    var placeholder: String
    var isPassword: Bool // true == password / false == login
    @Binding var input: String
    @State var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundStyle(Color.lightGrayText)
                    .padding(.leading, 16)
                Spacer()
            }
            
            ZStack(alignment: .trailing) {
                if isPassword && !isPasswordVisible {
                    SecureField(placeholder, text: $input)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $input)
                        .focused($isFocused)
                }
                if isPassword {
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
            }
             .passwordFieldStyle()
        }
        .padding(.horizontal)
    }
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
}
#Preview {
    Auth()
}
