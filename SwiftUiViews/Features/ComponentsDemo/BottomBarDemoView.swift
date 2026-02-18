//
//  BottomBarDemoView.swift
//  SwiftUiViews
//
//  Demo: footer with buttons, form with fixed bottom CTA.
//  Validation from Core/Validation; focus flow on Continue.
//

import SwiftUI

// MARK: - Form state (single source of truth)

struct BottomBarFormState {
    var name = ""
    var email = ""
    var step = 1
    var hasAttemptedValidation = false
}

extension BottomBarFormState {
    var nameError: String? {
        guard hasAttemptedValidation else { return nil }
        return FormValidators.validateRequired(name, fieldName: "Full name")
    }

    var emailError: String? {
        guard hasAttemptedValidation else { return nil }
        return FormValidators.validateEmail(email)
    }

    var isStep1Valid: Bool {
        nameError == nil && emailError == nil
    }
}

// MARK: - View

struct BottomBarDemoView: View {
    @State private var formState = BottomBarFormState()
    @FocusState private var focusedField: Field?
    @State private var scrollToFieldId: Field?

    enum Field: Hashable {
        case name
        case email
    }

    private static let focusOrder: [Field] = [.name, .email]

    /// Error for the given field; single source of truth for field→error mapping.
    private func error(for field: Field) -> String? {
        switch field {
        case .name: return formState.nameError
        case .email: return formState.emailError
        }
    }

    private var firstInvalidField: Field? {
        Self.focusOrder.first { error(for: $0) != nil }
    }

    var body: some View {
        formContent
            .navigationTitle("Bottom Bar")
            .platformInlineTitleMode()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                bottomBar
            }
    }

    private var formContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    stepHeader
                    if formState.step == 1 {
                        step1Fields(proxy: proxy)
                    } else {
                        step2Summary
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
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

    private var stepHeader: some View {
        Text("Step \(formState.step) of 2")
            .font(.headline)
            .foregroundStyle(.secondary)
    }

    private func step1Fields(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            OutlinedTextField(
                title: "Full name",
                text: $formState.name,
                placeholder: "Enter your name",
                errorMessage: formState.nameError,
                isFocused: focusedField == .name,
                submitLabel: .next
            ) {
                handleSubmit(from: .name, proxy: proxy)
            }
            .focused($focusedField, equals: .name)
            .id(Field.name)

            OutlinedTextField(
                title: "Email",
                text: $formState.email,
                placeholder: "you@example.com",
                icon: "envelope",
                errorMessage: formState.emailError,
                emailValidity: EmailValidity.evaluate(formState.email),
                isFocused: focusedField == .email,
                submitLabel: .done
            ) {
                handleSubmit(from: .email, proxy: proxy)
            }
            .focused($focusedField, equals: .email)
            .id(Field.email)
        }
    }

    private var step2Summary: some View {
        VStack(alignment: .leading, spacing: 8) {
            step2Title
            step2Message
        }
    }

    private var step2Title: some View {
        Text("Thank you, \(formState.name.trimmingCharacters(in: .whitespaces).isEmpty ? "there" : formState.name).")
            .font(.title2)
    }

    private var step2Message: some View {
        Text("We'll contact you at \(formState.email.isEmpty ? "your email" : formState.email).")
            .font(.body)
            .foregroundStyle(.secondary)
    }

    private var bottomBar: some View {
        BottomBarView {
            bottomBarButtons
        }
    }

    @ViewBuilder
    private var bottomBarButtons: some View {
        VStack(spacing: 12) {
            if formState.step == 1 {
                continueButton
            } else {
                doneButton
            }
        }
    }

    private var continueButton: some View {
        Button("Continue") { runValidationAndContinue(proxy: nil) }
            .buttonStyle(.primary)
    }

    private var doneButton: some View {
        Button("Done") {
            withAnimation(.snappy(duration: 0.28)) {
                formState.step = 1
                formState.name = ""
                formState.email = ""
                formState.hasAttemptedValidation = false
            }
        }
        .buttonStyle(.primary)
    }

    // MARK: - Submit and validation

    private func handleSubmit(from field: Field, proxy: ScrollViewProxy) {
        if field == .email {
            runValidationAndContinue(proxy: proxy)
        } else {
            let next = Field.email
            withAnimation(.snappy(duration: 0.28)) {
                focusedField = next
            }
            scrollToField(next, proxy: proxy)
        }
    }

    private func runValidationAndContinue(proxy: ScrollViewProxy?) {
        withAnimation(.snappy(duration: 0.28)) {
            formState.hasAttemptedValidation = true
        }
        if formState.isStep1Valid {
            withAnimation(.snappy(duration: 0.28)) {
                formState.step = 2
                focusedField = nil
            }
        } else if let first = firstInvalidField {
            withAnimation(.snappy(duration: 0.28)) {
                focusedField = first
            }
            if let p = proxy {
                scrollToField(first, proxy: p)
            } else {
                scrollToFieldId = first
            }
        }
    }

    private func scrollToField(_ field: Field, proxy: ScrollViewProxy) {
        Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(0.1))
            } catch {
                return
            }
            withAnimation(.snappy(duration: 0.25)) {
                proxy.scrollTo(field, anchor: .center)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BottomBarDemoView()
    }
}
