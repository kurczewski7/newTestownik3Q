//
//  Gestures.swift
//  testownik
//
//  Created by Slawek Kurczewski on 26/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

protocol GesturesDelegate {
     func eadgePanRefreshUI()
     func pinchRefreshUI(sender: UIPinchGestureRecognizer)
     func tapRefreshUI(sender: UITapGestureRecognizer)
     func longPressRefreshUI(sender: UILongPressGestureRecognizer)
     func forcePressRefreshUI(sender: ForcePressGestureRecognizer)
     func swipeRefreshUI(direction: UISwipeGestureRecognizer.Direction)
    
     func swipeRefreshLabel(sender: UISwipeGestureRecognizer, directions: [UISwipeGestureRecognizer.Direction])
     func addAllRequiredGestures(sender: Gestures)
}
class Gestures {
    enum GesteresList: Int {
        case tap        = 0
        case swipe      = 1
        case pan        = 2
        case pinch      = 3
        case longPress  = 4
        case forcePress = 5
        case screenEde  = 6
        case rotation   = 7
        case hover      = 8
    }
    var delegate: GesturesDelegate?
    var minimumPressDuration = 0.9      // default 0.9
    var numberOfTouchesRequired = 1     // default 1
    var cuurentGestureType : GesteresList = .tap
    var direction :  UISwipeGestureRecognizer.Direction = .left
    var edge: UIRectEdge = .left
    var disabledOtherGestures = false
    
    var view: UIView?  = nil
    let xx = UITouch()
//    func yy() {
//        xx.force
//        let zz = xx.maximumPossibleForce
//        let cc = xx.gestureRecognizers?[0]
//        print("maximumPossibleForce:\(zz),\(cc)")
//    }
    
     func setView(forView view: UIView) {
            self.view = view
     }
    func addTapGestureToView(forView aView: UIView? = nil, touchNumber: Int = 1) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        gesture.numberOfTouchesRequired = touchNumber
        addOneGesture(gesture, forView: aView)
        print("EEEE:  UITapGestureRecognizer:\(aView?.tag ?? 0)")
    }
     func addSwipeGestureToView(direction: UISwipeGestureRecognizer.Direction, forView aView: UIView? = nil) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
         gesture.direction = direction
        addOneGesture(gesture, forView: aView)
        //view.addGestureRecognizer(swipe)
        //}
     }
     func addPinchGestureToView(forView aView: UIView? = nil) {
         let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pichAction))
         addOneGesture(gesture, forView: aView)
     }
    func addScreenEdgeGesture(edge: UIRectEdge = .left, forView aView: UIView? = nil) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(eadgeAction))
        gesture.edges = edge
        addOneGesture(gesture, forView: aView)
     }
    func addLongPressGesture(forView aView: UIView? = nil) {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        gesture.minimumPressDuration = self.minimumPressDuration
        gesture.numberOfTouchesRequired = self.numberOfTouchesRequired
        addOneGesture(gesture, forView: aView)
    }
     func addForcePressGesture(forView aView: UIView? = nil) {
         let gesture = ForcePressGestureRecognizer(target: self, action: #selector(forcePressAction))
         addOneGesture(gesture, forView: aView)
     }
    private func addOneGesture(_ gesture: UIGestureRecognizer, forView aView: UIView?)   {
        guard let v = (aView == nil ? self.view : aView) else {     return        }
        v.addGestureRecognizer(gesture)
        print("CCCC:  Gesture:\(v.tag)")
    }
    
    func addCustomGesture(_ gestureType: GesteresList, forView aView: UIView?, numberOfTouchesRequired touchNumber: Int = 1)   {
        switch (gestureType) {
            case .tap:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(userGestureAction))
                gesture.numberOfTouchesRequired = touchNumber
                addOneGesture(gesture, forView: aView)
            case .swipe:
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(userGestureAction))
                gesture.direction = self.direction
                addOneGesture(gesture, forView: aView)
            case .pinch:
                let gesture = UIPinchGestureRecognizer(target: self, action: #selector(userGestureAction))
                addOneGesture(gesture, forView: aView)
            case .longPress:
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(userGestureAction))
                gesture.minimumPressDuration = self.minimumPressDuration
                gesture.numberOfTouchesRequired = self.numberOfTouchesRequired
                addOneGesture(gesture, forView: aView)
            case .forcePress:
                let gesture = ForcePressGestureRecognizer(target: self, action: #selector(userGestureAction))
                addOneGesture(gesture, forView: aView)
            case .screenEde:
                let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(userGestureAction))
                gesture.edges = edge
                addOneGesture(gesture, forView: aView)
            case .rotation:
                let gesture = UIRotationGestureRecognizer(target: self, action: #selector(userGestureAction))
                addOneGesture(gesture, forView: aView)
            case .hover:
                let gesture = UIHoverGestureRecognizer(target: self, action: #selector(userGestureAction))
                addOneGesture(gesture, forView: aView)
            case .pan:
                let gesture = UIPanGestureRecognizer(target: self, action: #selector(userGestureAction))
                addOneGesture(gesture, forView: aView)
        }
        self.cuurentGestureType = gestureType
    }
    //--------------------------------------------------
    @objc func userGestureAction(sender: UIGestureRecognizer) {
        print("Wykonano gest:\(self.cuurentGestureType.rawValue)")
    }
    @objc func tapAction(sender: UITapGestureRecognizer) {
//        print("TAP PRESSET")
//        sender.view?.alpha = 0.2
        if sender.state == .ended  {
            delegate?.tapRefreshUI(sender: sender)
        }
    }
    @objc func swipeAction(sender: UISwipeGestureRecognizer) {
         print("swipeAction:\(sender.view?.tag))")
         delegate?.swipeRefreshLabel(sender: sender, directions: [.down, .up])
         if  !self.disabledOtherGestures {
             delegate?.swipeRefreshUI(direction: sender.direction)
         }
        
         //swipeRefreshUI(direction: sender.direction)
     }
     @objc func eadgeAction() {
         if  !self.disabledOtherGestures {
             delegate?.eadgePanRefreshUI()
         }
             
         
         //eadgePanRefreshUI()
     }
     @objc func pichAction(sender: UIPinchGestureRecognizer) {
         if  !self.disabledOtherGestures {
             delegate?.pinchRefreshUI(sender: sender)
         }
         
         //pinchRefreshUI(sender: sender)
     }
     @objc func longPressAction(sender: UILongPressGestureRecognizer) {
         if sender.state == .ended  && !self.disabledOtherGestures {
             delegate?.longPressRefreshUI(sender: sender)
         }
     }
     @objc func  forcePressAction(sender: ForcePressGestureRecognizer) {
         if let _ = sender.view?.tag ,  !self.disabledOtherGestures {
             delegate?.forcePressRefreshUI(sender: sender)
         }
     }
}
