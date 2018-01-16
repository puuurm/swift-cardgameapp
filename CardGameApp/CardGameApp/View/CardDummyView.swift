//
//  CardDummyView.swift
//  CardGameApp
//
//  Created by yangpc on 2018. 1. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CardDummyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func position(index: Int) -> CGPoint {
        return subviews[index].frame.origin
    }

    func removeAllCardDummy() {
        self.subviews.forEach { (view: UIView) in
            view.subviews.forEach {
                $0.removeFromSuperview()
            }
        }
    }
}

extension CardDummyView: CardStackMovableView {
    func pop(index: Int, previousCard: Card?) {
        // Not yet
    }

    func push(index: Int, cardView: UIView) {
        subviews[index].addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: subviews[index].topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: subviews[index].leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: subviews[index].trailingAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: subviews[index].bottomAnchor).isActive = true
        cardView.isUserInteractionEnabled = false
    }
}
