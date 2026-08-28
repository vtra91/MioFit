import SwiftUI
import Combine


// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = OTPViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Enter Verification Code")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ZStack {
                // 1. The Visible OTP Boxes
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPBoxView(
                            text: viewModel.otpDigits[index],
                            isFilled: !viewModel.otpDigits[index].isEmpty
                        )
                    }
                }
                
                // 2. The Hidden TextField for Keyboard Input
                TextField("", text: otpBinding)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode) // Enables SMS auto-fill
                    .focused($isKeyboardFocused)
                    .foregroundColor(.clear) // Hide the actual text
                    .accentColor(.clear)     // Hide the cursor
                    .frame(height: 1)        // Shrink it so it doesn't block touches
            }
            // 3. Make the entire ZStack area tappable to trigger the keyboard
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardFocused = true
            }
            .onAppear {
                isKeyboardFocused = true // Auto-focus on screen load
            }
            
            if viewModel.otpDigits.joined().count == 6 {
                Button("Verify") {
                    print("Verifying OTP: \(viewModel.otpText)")
                    // viewModel.successCompletionHandler?()
                }
                .buttonStyle(.borderedProminent)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .padding()
        .animation(.easeInOut, value: viewModel.otpText.count)
    }
    
    // Custom Binding to filter numbers and limit to 6 characters cleanly
    private var otpBinding: Binding<String> {
        Binding(
            get: { viewModel.otpText },
            set: { newValue in
                let filtered = newValue.filter { $0.isNumber }
                viewModel.otpText = String(filtered.prefix(6))
            }
        )
    }
}

// MARK: - Single OTP Box Component
struct OTPBoxView: View {
    let text: String
    let isFilled: Bool
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 45, height: 50) // Fixed, reasonable size instead of UIScreen
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(isFilled ? Color.accentColor : Color.gray.opacity(0.5))
                        .frame(height: 2)
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isFilled)
    }
}

// MARK: - ViewModel
class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published var isTextFieldDisabled: Bool = false
    
    // Automatically splits the string into an array of 6 characters
    var otpDigits: [String] {
        let characters = Array(otpText)
        return (0..<6).map { index in
            index < characters.count ? String(characters[index]) : ""
        }
    }
    
    var isComplete: Bool {
        return otpText.count == 6
    }
}

#Preview {
    ContentView()
}
