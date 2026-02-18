# MCP Playbook (SwiftUI 6 + Concurrency)

## Goal
Fast, production-grade decisions for animations and modern concurrency with minimum noise.

## Optimal Flow (Use in this order)
1. `apple-docs` MCP:
   - Verify API behavior and availability (`iOS`, `visionOS`, etc.).
   - Prefer official guidance first.
2. `context7` MCP:
   - Pull real production patterns and snippets.
   - Primary library for architecture/effects: `/pointfreeco/swift-composable-architecture`.
3. External references (only for edge cases and advanced patterns):
   - Swift with Majid
   - Donny Wals
   - objc.io / Swift Talk
   - SwiftLee

## Query Templates (Copy/Paste)

### Apple Docs MCP
- `SwiftUI sensoryFeedback trigger best practices`
- `SwiftUI animation(_:value:) transaction`
- `SwiftUI phaseAnimator trigger`
- `SwiftUI keyframeAnimator`
- `SwiftUI symbolEffect value`

### Context7 MCP (TCA)
Library: `/pointfreeco/swift-composable-architecture`

- `async effects with cancellation id and cancelInFlight`
- `debounce search with continuousClock and cancellable effects`
- `task cancellation patterns in reducer run effects`
- `testing async effects with TestClock`
- `SwiftUI integration with @ObservableState and Store`

## What to Apply in This Project
1. Use value-driven animations only: `.animation(_, value:)`.
2. Prefer structured concurrency: `Task`, `.task(id:)`, cancellation-aware logic.
3. Add cancellation IDs for all long-running async effects.
4. Keep UI interaction centralized (already started with `ButtonInteractionManager`).
5. For complex transitions, use `phaseAnimator`/`keyframeAnimator` instead of ad-hoc chained springs.

## Quick Review Checklist
1. Any async operation without cancellation path?
2. Any animation without explicit `value` trigger?
3. Any non-main UI mutation from async context?
4. Any duplicate interaction logic that should be in manager/scaffold?
5. Any iOS-version-specific API used without `#available` fallback?

## High-Value References
- Swift with Majid:
  - https://swiftwithmajid.com/2025/02/11/task-cancellation-in-swift-concurrency/
  - https://swiftwithmajid.com/2025/07/08/introducing-animatable-macro-in-swiftui/
  - https://swiftwithmajid.com/2024/03/26/building-async-button-in-swiftui/
- Donny Wals:
  - https://www.donnywals.com/setting-default-actor-isolation-in-xcode-26/
  - https://www.donnywals.com/understanding-unstructured-and-detached-tasks-in-swift/
- objc.io / Swift Talk:
  - https://talk.objc.io/collections/swiftui
  - https://talk.objc.io/episodes/S01E368-building-keyframe-animations-part-3
- SwiftLee:
  - https://www.avanderlee.com/concurrency/tasks/

