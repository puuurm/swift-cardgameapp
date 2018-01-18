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

    func topConstantOfLastCard() -> CGFloat {
        return subviews.last?.frame.origin.y ?? 0
    }

    func belowViews(with view: CardView) -> [UIView] {
        return subviews.filter { $0.tag != emptyTag && $0.frame.origin.y >= view.frame.origin.y }
    }

    func removeAllCardViews() {
        subviews.forEach {
            if $0.tag == emptyTag { return }
            $0.removeFromSuperview()
        }
    }

    func popCardStackView(previousCard: Card?) {
        subviews.last?.isUserInteractionEnabled = true
        guard let card = previousCard else { return }
        ( self.subviews.last as? UIImageView)?.image = card.makeImage()
    }

    func pushCardStackView(cardView: CardView) {
        self.addSubview(cardView)
        let topConstant = (subviews.count-2).cgfloat*constant
        cardView.fitLayout(with: self, topConstant: topConstant)
        subviews.last?.isUserInteractionEnabled = true
    }

    func addDoubleTapGestureAllSubViews(action: Action) {
        subviews.forEach {
            guard let cardView = $0 as? CardView else { return }
            cardView.addTapGesture(action: action, numberOfTapsRequired: 2)
        }
    }

    func addPanGesture(action: Action) {
        subviews.forEach {
            guard let cardView = $0 as? CardView else {return}
            cardView.addPanGesture(action: action)
        }
    }

    func validUserInterationOnlyLastCard() {
        subviews.forEach { $0.isUserInteractionEnabled = false }
        subviews.last?.isUserInteractionEnabled = true
    }

    // 카드 이미지 뷰를 만드는 함수 (마지막 카드만 카드 앞면.)
    private func makeCardImageViews(_ cardStack: CardStack) -> [CardView] {
        var imageViews = [CardView]()
        var stack = cardStack
        let count = stack.count
        while true {
            guard let card = stack.pop() else { break }
            let imageView = CardView()
            if stack.count == count - 1 {
                imageView.image = card.makeImage()
            } else { imageView.image = card.makeBackImage() }
            imageViews.insert(imageView, at: 0)
        }
        return imageViews
    }
}

// MARK: Layout
extension CardStackView {

    // 빈 카드 카드 스택 뷰 배치
    private func setEmptyView() {
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
