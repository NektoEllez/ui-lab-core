import SwiftUI

struct OutlinedTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var icon: String? = nil
    var errorMessage: String? = nil
    /// When isSecure: real-time strength (border color + hint). Nil = no strength UI.
    var passwordStrength: PasswordStrength? = nil
    /// Real-time email validity (border color + hint). Nil = no validity UI.
    var emailValidity: EmailValidity? = nil
    var isSecure: Bool = false
    var isFocused: Bool = false
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)?

    /// When isSecure: true = password visible (show eye.slash), false = hidden (show eye).
    @State private var isPasswordRevealed = false

    private var isFloated: Bool {
        !text.isEmpty || isFocused
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.titleFieldSpacing) {
            titleLabel
            inputFieldWithBorder
            errorLabel
            strengthHintLabel
        }
        .animation(Constants.animation, value: showIcon)
        .animation(Constants.animation, value: errorMessage)
        .animation(Constants.animation, value: passwordStrength)
        .animation(Constants.animation, value: emailValidity)
        .animation(Constants.animation, value: isPasswordRevealed)
        .animation(Constants.animation, value: isFocused)
        .animation(Constants.animation, value: isFloated)
    }

    // MARK: - Private subviews

    /// Единый размер заголовка при ошибке (HIG/SwiftUI 2026): при error — всегда один шрифт, иначе float-анимация.
    private var titleLabel: some View {
        Text(title)
            .font(titleFont)
            .fontWeight(titleFontWeight)
            .foregroundStyle(titleColor)
    }

    private var titleFont: Font {
        if errorMessage != nil { return Constants.labelFont }
        return isFloated ? Constants.floatedTitleFont : Constants.restTitleFont
    }

    private var titleFontWeight: Font.Weight? {
        if errorMessage != nil { return .semibold }
        return nil
    }

    private var titleColor: Color {
        if errorMessage != nil { return .red }
        if isFloated { return .primary }
        return .secondary
    }

    private var inputFieldWithBorder: some View {
        fieldRow
            .padding(fieldPaddingSymmetric)
            .background(fieldBackground)
            .clipShape(.rect(cornerRadius: Constants.cornerRadius))
            .submitLabel(submitLabel)
            .onSubmit { onSubmit?() }
            .accessibilityLabel(title)
            .accessibilityValue(text)
            .accessibilityHint(placeholder)
    }

    /// HStack: optional leading icon + field + optional trailing eye (password).
    private var fieldRow: some View {
        HStack(spacing: Constants.iconTextSpacing) {
            leadingIconView
            styledInputField
            trailingPasswordToggle
        }
    }

    @ViewBuilder
    private var leadingIconView: some View {
        if showIcon, let icon {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.secondary)
                .transition(Constants.iconTransition)
        }
    }

    @ViewBuilder
    private var trailingPasswordToggle: some View {
        if isSecure {
            Button(action: togglePasswordVisibility) {
                Image(systemName: isPasswordRevealed ? "eye.slash" : "eye")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPasswordRevealed ? "Hide password" : "Show password")
        }
    }

    private func togglePasswordVisibility() {
        withAnimation(Constants.animation) {
            isPasswordRevealed.toggle()
        }
    }

    @ViewBuilder
    private var styledInputField: some View {
        if isSecure {
            if isPasswordRevealed {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            } else {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
            }
        } else {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
        }
    }

    private var showIcon: Bool {
        icon != nil && text.isEmpty
    }

    private var fieldPaddingSymmetric: EdgeInsets {
        EdgeInsets(
            top: Constants.verticalPadding,
            leading: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            trailing: Constants.horizontalPadding
        )
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
            .strokeBorder(borderColor, lineWidth: borderWidth)
    }

    private var borderColor: Color {
        if errorMessage != nil { return .red }
        if isSecure, let strength = passwordStrength, !text.isEmpty, let color = strength.borderColor {
            return color
        }
        if let validity = emailValidity, !text.isEmpty, let color = validity.borderColor {
            return color
        }
        if isFocused { return .accentColor }
        return Color.secondary.opacity(Constants.unfocusedBorderOpacity)
    }

    private var borderWidth: CGFloat {
        if errorMessage != nil { return Constants.errorBorderWidth }
        if isFocused { return Constants.focusedBorderWidth }
        return Constants.borderWidth
    }

    @ViewBuilder
    private var errorLabel: some View {
        if let errorMessage {
            Text(errorMessage)
                .font(.caption)
                .foregroundStyle(.red)
                .transition(Constants.errorTransition)
        }
    }

    /// Short hint below field when password strength or email validity is shown (no error).
    @ViewBuilder
    private var strengthHintLabel: some View {
        if errorMessage == nil, !text.isEmpty, let hint = fieldHint {
            Text(hint)
                .font(.caption)
                .foregroundStyle(.secondary)
                .transition(Constants.iconTransition)
        }
    }

    private var fieldHint: String? {
        if isSecure, let strength = passwordStrength { return strength.hint }
        if let validity = emailValidity { return validity.hint }
        return nil
    }
}

// MARK: - Constants

private enum Constants {
    static let cornerRadius: CGFloat = 12
    static let horizontalPadding: CGFloat = 14
    static let verticalPadding: CGFloat = 12
    static let titleFieldSpacing: CGFloat = 6
    /// Space between icon and text; icon size comes from Image + .font(.body).
    static let iconTextSpacing: CGFloat = 10
    static let borderWidth: CGFloat = 1
    static let focusedBorderWidth: CGFloat = 2
    static let errorBorderWidth: CGFloat = 1.5
    static let unfocusedBorderOpacity: Double = 0.3

    /// Snappy spring: brief, precise, under 400ms (HIG).
    static let animation: Animation = .snappy(duration: 0.28)
    /// Единый шрифт заголовка при ошибке — все поля выглядят одинаково.
    static let labelFont: Font = .subheadline.weight(.medium)
    static let restTitleFont: Font = .subheadline.weight(.medium)
    static let floatedTitleFont: Font = .caption.weight(.medium)
    static let iconTransition: AnyTransition = .opacity
    static let errorTransition: AnyTransition = .opacity.combined(with: .move(edge: .top))
}

#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var password = ""
        @State private var error: String? = "Invalid email"

        var body: some View {
            previewContent
        }

        private var previewContent: some View {
            VStack(spacing: 20) {
                OutlinedTextField(
                    title: "Email",
                    text: $email,
                    placeholder: "you@example.com",
                    icon: "envelope",
                    errorMessage: error
                )
                OutlinedTextField(
                    title: "Password",
                    text: $password,
                    placeholder: "••••••••",
                    icon: "lock",
                    isSecure: true
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
