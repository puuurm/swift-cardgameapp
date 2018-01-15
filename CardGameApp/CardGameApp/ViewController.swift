//
//  ViewController.swift
//  CardGameApp
//
//  Created by yangpc on 2017. 12. 21..
//  Copyright © 2017년 yang hee jung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties

    @IBOutlet var cardDummyView: CardDummyView!
    @IBOutlet var showCardView: UIView!
    @IBOutlet var backCardView: UIImageView!
    @IBOutlet var cardStackDummyView: CardStackDummyView!

    var cardStackVM = CardStackViewModel()
    var cardDummyVM = CardDummyViewModel()
    var remainBackCards = [Card]() {
        willSet {
            changeRemainBackCardView(cards: newValue)
        }
    }
    var remainShowCards = [Card]() {
        willSet {
            changeRemainShowCardView(cards: newValue)
        }
    }

    struct Size {
        static let constant: CGFloat = 3
        static let cardStackCount: Int = 7
        static var cardWidth: CGFloat = 0
        static var cardHeight: CGFloat = 0
        static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    }

    struct Image {
        static let refreshImage = UIImage(named: "cardgameapp-refresh-app")!
        static let backImage = UIImage(named: "card-back")!
        static let bgImage = UIImage(named: "bg_pattern")!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cardStackDummyView.delegate = self
        initProperties()
        initViews()
        initBackGroundImage()
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            cardStackVM.reset()
            cardDummyVM.reset()
            remainBackCards = cardStackVM.remainCards
            remainShowCards.removeAll()
            cardDummyView.removeAllCardDummy()
            cardStackDummyView.removeCardStackDummyView()
            cardStackDummyView.setCardStackDummyView(cardStackVM.cardStacks)
        }
    }
}

extension ViewController {
    private func initProperties() {
        Size.cardWidth = (self.view.frame.width - Size.constant * 8) / CGFloat(Size.cardStackCount)
        Size.cardHeight = Size.cardWidth * 1.27
        remainBackCards = cardStackVM.remainCards
    }

    private func initViews() {
        cardStackDummyView.setCardStackDummyView(cardStackVM.cardStacks)
        initBackCardView()
    }

    // Initialize Views

    private func initBackGroundImage() {
        view.backgroundColor = UIColor.init(patternImage: Image.bgImage)
    }

    fileprivate func initBackCardView() {
        backCardView.image = Image.backImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.remainCardsViewDidTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        backCardView.addGestureRecognizer(tapRecognizer)
    }

    // Change Views
    private func changeRemainBackCardView(cards: [Card]) {
        if cards.isEmpty {
            backCardView.image = Image.refreshImage
        } else {
            backCardView.image = Image.backImage
        }
    }

    private func changeRemainShowCardView(cards: [Card]) {
        if cards.isEmpty {
            showCardView.subviews.forEach { $0.removeFromSuperview() }
        } else {
            guard let lastCard = cards.last else {
                return
            }
            showCardView.addSubview(UIImageView(image: lastCard.makeImage()))
            guard let subview = showCardView.subviews.last else { return }

            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.topAnchor.constraint(equalTo: showCardView.topAnchor).isActive = true
            subview.leadingAnchor.constraint(equalTo: showCardView.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: showCardView.trailingAnchor).isActive = true
            subview.widthAnchor.constraint(equalTo: showCardView.widthAnchor).isActive = true
            subview.heightAnchor.constraint(equalTo: subview.widthAnchor, multiplier: 1.27).isActive = true

        }
    }

}

// MARK: Events

extension ViewController: CardStackDummyViewDelegate {
    func moveToCardStackDummyView(_ cardStackDummyView: CardStackDummyView, tappedView: UIView, cardStackIdx: Int) {
        guard let selectedCard = cardStackVM.top(cardStackIndex: cardStackIdx) else { return }
        if cardDummyVM.selectTargetTopViewIndex(card: selectedCard) != nil { return }
        if let indexCardStack = cardStackVM.selectTargetCardStackViewIndex(card: selectedCard) {
            let moveOrigin = cardStackDummyView.distance(from: cardStackIdx, to: indexCardStack)
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    tappedView.frame.origin.x += moveOrigin.x
                    tappedView.frame.origin.y += moveOrigin.y
            },
                completion: { _ in
                    self.cardStackVM.pop(cardStackIndex: cardStackIdx)
                    self.cardStackVM.push(cardStackIndex: indexCardStack, card: selectedCard)
                    let topCard = self.cardStackVM.top(cardStackIndex: cardStackIdx)
                    tappedView.removeFromSuperview()
                    cardStackDummyView.pop(index: cardStackIdx, previousCard: topCard)
                    cardStackDummyView.push(index: indexCardStack, cardView: tappedView)
            })
        }
    }

    func moveToCardDummyView(_ cardStackDummyView: CardStackDummyView, tappedView: UIView, cardStackIdx: Int) {
        let constant: CGFloat = 7.5
        guard let selectedCard = cardStackVM.top(cardStackIndex: cardStackIdx) else { return }
        if let indexTopView = cardDummyVM.selectTargetTopViewIndex(card: selectedCard) {
            let topViewPos = cardDummyView.position(index: indexTopView)
            let moveXPos = cardStackDummyView.moveX(from: 0, to: cardStackIdx)
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    tappedView.frame.origin.x = -moveXPos
                    tappedView.frame.origin.x += topViewPos.x
                    tappedView.frame.origin.y = -(constant + Size.cardHeight) },
                completion: { _ in
                    let popCard = self.cardStackVM.pop(cardStackIndex: cardStackIdx)!
                    self.cardDummyVM.push(index: indexTopView, card: popCard)
                    let topCard = self.cardStackVM.top(cardStackIndex: cardStackIdx)
                    tappedView.removeFromSuperview()
                    cardStackDummyView.pop(index: cardStackIdx, previousCard: topCard)
                    self.cardDummyView.push(index: indexTopView, cardView: tappedView)
            })
        }
    }

    @objc func remainCardsViewDidTap(_ recognizer: UITapGestureRecognizer) {
        guard let imageView = recognizer.view as? UIImageView,
            let cardImage = imageView.image else {
                return
        }
        switch cardImage {
        case Image.refreshImage:
            remainBackCards.append(contentsOf: remainShowCards)
            remainShowCards.removeAll(keepingCapacity: false)
        case Image.backImage:
            // 카드를 꺼낸다.
            let card = remainBackCards.removeLast()
            remainShowCards.append(card)
        default: break
        }
    }
}
