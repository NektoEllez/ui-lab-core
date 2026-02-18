import SwiftUI

// MARK: - Form state (single source of truth)

struct LoginFormState {
    var email = ""
    var password = ""
    var name = ""
    var hasAttemptedValidation = false
}

extension LoginFormState {
    var emailError: String? {
        guard hasAttemptedValidation else { return nil }
        return FormValidators.validateEmail(email)
    }

    var passwordError: String? {
        guard hasAttemptedValidation else { return nil }
        return FormValidators.validatePassword(password)
    }

    var isValid: Bool {
        emailError == nil && passwordError == nil
    }
}

// MARK: - View

struct TextFieldsDemoView: View {
    @State private var formState = LoginFormState()
    @FocusState private var focusedField: Field?
    @State private var scrollToFieldId: Field?

    enum Field: Hashable {
        case email
        case password
        case name
    }

    private static let focusOrder: [Field] = [.email, .password, .name]

    /// Error for the given field; single source of truth for field→error mapping.
    private func error(for field: Field) -> String? {
        switch field {
        case .email: return formState.emailError
        case .password: return formState.passwordError
        case .name: return nil
        }
    }

    private var firstInvalidField: Field? {
        Self.focusOrder.first { error(for: $0) != nil }
    }

    var body: some View {
        formContent
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Text Fields")
            .platformInlineTitleMode()
            .toolbar { toolbarContent }
            .onTapGesture { focusedField = nil }
    }

    private var formContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                formCard(proxy: proxy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: scrollToFieldId) { _, target in
                if let target {
                    scrollToField(target, proxy: proxy)
                    scrollToFieldId = nil
                }
            }
        }
    }

    /// Вся форма в одной карточке; при появлении ошибок валидации карточка увеличивается по вертикали.
    private func formCard(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Login")
                .font(.title2.weight(.semibold))
            emailField(proxy: proxy)
            passwordField(proxy: proxy)
            Text("Optional")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            displayNameField(proxy: proxy)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassStyleBackground(cornerRadius: 16)
        .animation(.snappy(duration: 0.28), value: formState.hasAttemptedValidation)
    }

    private func emailField(proxy: ScrollViewProxy) -> some View {
        OutlinedTextField(
            title: "Email",
            text: $formState.email,
            placeholder: "you@example.com",
            icon: "envelope",
            errorMessage: formState.emailError,
            emailValidity: EmailValidity.evaluate(formState.email),
            isFocused: focusedField == .email,
            submitLabel: .next
        ) { handleSubmit(from: .email, scrollProxy: proxy) }
        .focused($focusedField, equals: .email)
        .id(Field.email)
    }

    private func passwordField(proxy: ScrollViewProxy) -> some View {
        OutlinedTextField(
            title: "Password",
            text: $formState.password,
            placeholder: "••••••••",
            icon: "lock",
            errorMessage: formState.passwordError,
            passwordStrength: PasswordStrength.evaluate(formState.password),
            isSecure: true,
            isFocused: focusedField == .password,
            submitLabel: .next
        ) { handleSubmit(from: .password, scrollProxy: proxy) }
        .focused($focusedField, equals: .password)
        .id(Field.password)
    }

    private func displayNameField(proxy: ScrollViewProxy) -> some View {
        OutlinedTextField(
            title: "Display name",
            text: $formState.name,
            placeholder: "Optional",
            isFocused: focusedField == .name,
            submitLabel: .done
        ) { handleSubmit(from: .name, scrollProxy: proxy) }
        .focused($focusedField, equals: .name)
        .id(Field.name)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        #if os(macOS)
        ToolbarItem(placement: .automatic) {
            Button("Validate") { runValidationAndFocusFirstInvalid() }
        }
        #else
        ToolbarItem(placement: .topBarTrailing) {
            Button("Validate") { runValidationAndFocusFirstInvalid() }
        }
        #endif
        #if !os(macOS)
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") {
                withAnimation(.snappy(duration: 0.28)) { focusedField = nil }
            }
        }
        #endif
    }

    // MARK: - Submit flow (keyboard Next / Return)

    private func handleSubmit(from field: Field, scrollProxy: ScrollViewProxy) {
        guard let index = Self.focusOrder.firstIndex(of: field) else { return }
        let nextIndex = index + 1

        if nextIndex < Self.focusOrder.count {
            let next = Self.focusOrder[nextIndex]
            withAnimation(.snappy(duration: 0.28)) {
                focusedField = next
            }
            scrollToField(next, proxy: scrollProxy)
        } else {
            runValidationAndFocusFirstInvalid(scrollProxy: scrollProxy)
        }
    }

    private func runValidationAndFocusFirstInvalid(scrollProxy: ScrollViewProxy? = nil) {
        withAnimation(.snappy(duration: 0.28)) {
            formState.hasAttemptedValidation = true
        }
        let firstInvalid = firstInvalidField
        if let firstInvalid {
            withAnimation(.snappy(duration: 0.28)) {
                focusedField = firstInvalid
            }
            scrollToFieldId = firstInvalid
        } else {
            focusedField = nil
        }
    }

    private func scrollToField(_ field: Field, proxy: ScrollViewProxy) {
        Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(0.1)) // focus settles
            } catch {
                return // task cancelled
            }
            withAnimation(.snappy(duration: 0.25)) {
                proxy.scrollTo(field, anchor: .center)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TextFieldsDemoView()
    }
}
