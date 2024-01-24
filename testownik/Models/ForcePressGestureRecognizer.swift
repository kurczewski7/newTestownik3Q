//
//  ForcePressGestureRecognizer.swift
//  testownik
//
//  Created by Slawek Kurczewski on 19/10/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

@available(iOS 9.0, *)
final class ForcePressGestureRecognizer: UIGestureRecognizer {
    var forceLevel: CGFloat  = 0.7
    
    override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {      handleTouch(touch)        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {     handleTouch(touch)    }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
        if touch.force / touch.maximumPossibleForce >= forceLevel {   state = UIGestureRecognizer.State.recognized   }
    }
}
