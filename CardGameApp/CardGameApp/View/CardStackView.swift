//
//  CardStackView.swift
//  CardGameApp
//
//  Created by yangpc on 2018. 1. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    let constant = CGFloat(30)
    let emptyTag = 999
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setEmptyView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: Make ImageView
extension CardStackView {
    // 카드 스택 이미지 뷰를 처음 생성한다.
    func setCardStackImageView(_ cardStack: CardStack) {
        let cardImageViews = makeCardImageViews(cardStack)
        cardImageViews.forEach {
            let cardIndex = CGFloat(subviews.count-1)
            self.addSubview($0)
            $0.fitLayout(with: self, topConstant: cardIndex*constant)
        }
    }

    func cardIndex(pos: CGPoint) -> Int? {
        let topConstant = Size.statusBarHeight + Size.cardHeight + 7.5
        let topPos =  pos.y - topConstant
        for i in 0..<subviews.count-1 where isBelongTo(index: i, length: 30, pointY: topPos) {
            return i
        }
        let last = subviews.count - 1
        if isBelongTo(index: last, length: Size.cardHeight, pointY: topPos) { return last }
        return nil
    }

    func selectedCardView(index: Int) -> CardView? {
        return subviews[index] as? CardView
    }

    func isBelongTo(index: Int, length: CGFloat, pointY: CGFloat) -> Bool {
        guard let cardView = subviews[index] as? CardView,
            cardView.tag != emptyTag else { return false }
        let minY = subviews[index].frame.origin.y
        let maxY = subviews[index].frame.origin.y + length
        if pointY >= minY && pointY <= maxY && cardView.isFlipped {return true}
        return false
    }

    func lastCard() -> CardView? {
        return subviews.last as? CardView
    }

    func isLastCard(index: Int) -> Bool {
        let lastIndex = subviews.count - 1
        return lastIndex == index
    }

    func topConstantOfLastCard() -> CGFloat {
        return subviews.last?.frame.origin.y ?? 0
    }

    func index(of view: CardView) -> Int {
        return subviews.index(of: view) ?? subviews.endIndex
    }

    func targetY(translateY: CGFloat, targetIndex: Int) -> Bool {
        guard let lastCard = subviews.last as? CardView else { return false }
        let positionY = lastCard.frame.origin.y
        if translateY >= positionY && translateY <= positionY + Size.cardHeight {
            return true
        }
        return false
    }

    func belowViews(index: Int) -> [UIView] {
        guard let cardView = subviews[index] as? CardView else { return []}
        return subviews.filter {
            $0.tag != emptyTag && $0.frame.origin.y >= cardView.frame.origin.y }
    }

    func removeAllCardViews() {
        subviews.forEach {
            if $0.tag == emptyTag { return }
            $0.removeFromSuperview()
        }
    }

    func popCardStackView(previousCard: Card?) {
        guard let card = previousCard else { return }
        ( self.subviews.last as? UIImageView)?.image = card.makeImage()
    }

    func pushCardStackView(cardView: CardView) {
        self.addSubview(cardView)
        let topConstant = (subviews.count-2).cgfloat * constant
        cardView.fitLayout(with: self, topConstant: topConstant)
    }

    // 카드 이미지 뷰를 만드는 함수 (마지막 카드만 카드 앞면.)
    private func makeCardImageViews(_ cardStack: CardStack) -> [CardView] {
        var imageViews = [CardView]()
        var stack = cardStack
        let count = stack.count
        while true {
            guard let card = stack.pop() else { break }
            let cardView = CardView()
            if stack.count == count - 1 {
                cardView.image = card.makeImage()
            } else { cardView.image = card.makeBackImage() }
            imageViews.insert(cardView, at: 0)
        }
        return imageViews
    }
}

// MARK: Layout
extension CardStackView {

    func removeEmptyView() { subviews.last?.removeFromSuperview() }

    func setEmptyView() {
        let emptyView = UIView().makeEmptyView()
        self.addSubview(emptyView)
        emptyView.tag = emptyTag
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        emptyView.heightAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 1.27).isActive = true
    }
}
