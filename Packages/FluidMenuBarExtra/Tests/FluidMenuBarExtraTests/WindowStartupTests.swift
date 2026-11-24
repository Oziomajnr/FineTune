import AppKit
import SwiftUI
import XCTest
@testable import FluidMenuBarExtra

final class WindowStartupTests: XCTestCase {
    @MainActor
    func testCreatesPopupContentAfterWindowInitialization() async {
        _ = NSApplication.shared
        var builtContent = false
        let window = FluidMenuBarExtraWindow(title: "Mixer") {
            builtContent = true
            return Text("Volume")
        }
        XCTAssertFalse(builtContent)

        // The window queues its setup during init, before this main-queue block.
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            DispatchQueue.main.async { continuation.resume() }
        }
        XCTAssertTrue(builtContent)
        XCTAssertFalse(window.contentView?.subviews.isEmpty ?? true)
    }
}
