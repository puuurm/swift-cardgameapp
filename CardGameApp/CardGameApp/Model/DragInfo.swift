//
//  DragInfo.swift
//  CardGameApp
//
//  Created by yangpc on 2018. 1. 24..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct DragInfo {
    weak var baseView: UIView!
    var changes = [UIView]()
    var originalBaseIndex: Int?
    var originals = [CGPoint]()
    var startView: MovableStartView?
    var startPos: Position?
    var targetPos: Position?

    init(view: UIView) {
        baseView = view
    }

    mutating private func setInfo(
        originalBaseIndex: Int,
        startView: MovableStartView,
        startPos: Position,
        chages: [UIView]) {
        self.originalBaseIndex = originalBaseIndex
        self.startView = startView
        self.startPos = startPos
        self.changes = chages
    }

    mutating func setDragInfo(_ gesture: UIPanGestureRecognizer) {
        let tappedLocation = gesture.location(in: self.baseView)
        guard let tappedView = gesture.view as? MovableStartView,
            let originalBaseIndex = baseView.subviews.index(of: gesture.view!),
            let startPos = tappedView.position(tappedLocation) else { return }
        // 0 1 2 3 [1] -> 0 2 3 1
        baseView.bringSubview(toFront: baseView.subviews[originalBaseIndex])
        let belowViews = tappedView.belowViews(startPos)
        setInfo(originalBaseIndex: originalBaseIndex, startView: tappedView, startPos: startPos, chages: belowViews)
        self.changes.forEach {
            self.originals.append($0.center)
        }
    }

    func dragViews(_ gesture: UIPanGestureRecognizer) {
        self.changes.forEach {
            let translation = gesture.translation(in: self.baseView)
            $0.center = CGPoint(
                x: $0.center.x + translation.x,
                y: $0.center.y + translation.y)
        }
        gesture.setTranslation(CGPoint.zero, in: self.baseView)
    }

    func backToViewPriority() {
        guard let lastView = baseView.subviews.last,
            let idx = originalBaseIndex,
            let startView = startView,
            let startPos = startPos else { return }
        baseView.insertSubview(lastView, at: idx)
        if let startview = startView as? TableauPilesView {
            startview.insertLastSubview(at: startPos.stackIndex)
        }
    }
    func backToStartState() {
        var i = 0
        self.changes.forEach {
            $0.center.x = self.originals[i].x
            $0.center.y = self.originals[i].y
            i += 1
        }
    }

}
