//
//  CardStackView.swift
//  CardGameApp
//
//  Created by yangpc on 2017. 12. 28..
//  Copyright © 2017년 yang hee jung. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    var cardStack: CardStack? {
        willSet(newStack) {
            makeCardStackImageView(newStack)
        }
    }
    var cardStackImageViews: [UIImageView] = [UIImageView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CardStackView {
    func setCardStack(_ cardStack: CardStack) {
        self.cardStack = cardStack
    }

    func makeCardStackImageView(_ cardStack: CardStack?) {
        var imageViews = [UIImageView]()
        guard var stack = cardStack else {
            return
        }
        while stack.count > 1 {
            guard let card = stack.pop() else {
                break
            }
            imageViews.append(UIImageView(image: card.makeBackImage()))
        }
        guard let card = stack.pop() else {
            return
        }
        imageViews.append(UIImageView(image: card.makeImage()))
        cardStackImageViews = imageViews
    }

    func setCardStackViewLayout() {
        let emptyView = UIView()
        emptyView.layer.borderWidth = 1
        emptyView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(emptyView)
        emptyView.setRatio()
        emptyView.top(equal: self)
        emptyView.leading(equal: self.leadingAnchor)
        emptyView.trailing(equal: self.trailingAnchor)
        emptyView.width(equal: self.widthAnchor)
        cardStackImageViews.forEach { (imageview: UIImageView) in
            let i = cardStackImageViews.index(of: imageview) ?? cardStackImageViews.endIndex
            self.addSubview(imageview)
            imageview.setRatio()
            imageview.top(equal: self, constant: CGFloat(i) * 30)
            imageview.leading(equal: self.leadingAnchor)
            imageview.trailing(equal: self.trailingAnchor)
            imageview.width(equal: self.widthAnchor)
        }
    }

}
