//
//  ViewController.swift
//  CardGameApp
//
//  Created by yangpc on 2017. 12. 21..
//  Copyright © 2017년 yang hee jung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Object Properties...

    var cardDeck = CardDeck()
    var remainShowCards = [Card]()
    lazy var remainBackCards: [Card] = { [unowned self] in
        return cardDeck.cards
    }()

    lazy var cardStacks: [CardStack] = { [unowned self] in
        return makeCardStack()
    }()

    // MARK: View Properties...

    // 상단 비어 있는 뷰
    lazy var emptyViews: [UIView] = { [unowned self] in
        return makeEmptyViews(count: 4)
    }()

    // 스택 뷰 셋팅
    lazy var emptyStackViews: [UIView] = { [unowned self] in
        var views = [UIView]()
        for _ in 1...7 {
            views.append(UIView())
        }
        return views
    }()

    // 상단 맨 오른쪽 남은 카드들
    lazy var remainBackCardsView: UIView = { [unowned self] in
        var view = UIView()
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.remainCardsViewDidTap(_:))
        )
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var remainShowCardsView: UIView = { [unowned self] in
        let emptyView = makeEmptyViews(count: 1)
        return emptyView[0]
    }()

    // 카드 스택이 들어 있는 뷰
    lazy var cardStackViews: [CardStackView] = { [unowned self] in
        var cardStackViews = [CardStackView]()
        let widthOfCard = (self.view.frame.width - 24) / 7
        let heightOfView = self.view.frame.height
        cardStacks.forEach { (cardStack: CardStack) in
            var cardStackView = CardStackView(
                frame: CGRect(x: 0, y: 0, width: widthOfCard, height: heightOfView - 100)
            )
            cardStackView.setCardStack(cardStack)
            cardStackViews.append(cardStackView)
        }
        return cardStackViews
    }()

    // MARK: Override...

    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackGroundImage()
        setUIViewLayout()
    }

    // MARK: Events...

    @objc func remainCardsViewDidTap(_ recognizer: UITapGestureRecognizer) {
        print("remainCardsViewDidTap")
    }

    // MARK: Methods...

    private func makeEmptyViews(count: Int) -> [UIView] {
        var views = [UIView]()
        for _ in 0..<count {
            let emptyView = UIView()
            emptyView.layer.borderWidth = 1
            emptyView.layer.borderColor = UIColor.white.cgColor
            emptyView.clipsToBounds = true
            views.append(emptyView)
        }
        return views
    }

    private func makeBackGroundImage() {
        guard let patternImage = UIImage(named: "bg_pattern") else {
            return
        }
        view.backgroundColor = UIColor.init(patternImage: patternImage)
    }

    // 카드 스택 초기화
    private func makeCardStack() -> [CardStack] {
        // 카드를 섞는다.
        cardDeck.shuffle()
        var newCardStacks = [CardStack]()
        for i in 1...7 {
            // 카드를 i개 뽑는다.
            var cardStack = CardStack()
            guard let cards = try? cardDeck.pickCards(number: i) else {
                continue
            }
            // i 개의 카드를 카드 스택에 푸시한다.
            for j in 1...i {
                cardStack.push(card: cards[j-1])
            }
            newCardStacks.append(cardStack)
        }
        return newCardStacks
    }

    private func setUIViewLayout() {
        setEmptyViewLayout()
        setRemainBackCardsViewLayout()
        setEmptyStackViewsLayout()
        setCardStackViewLayout()
    }

    // 상단 비어있는 네 개의 뷰
    private func setEmptyViewLayout() {
        self.view.setGridLayout(emptyViews)
    }

    // 비어있는 카드 스택 뷰
    private func setEmptyStackViewsLayout() {
        self.view.setGridLayout(emptyStackViews, top: 100)
    }

    private func setCardStackViewLayout() {
        emptyStackViews.forEach { (stackview: UIView) in
            let i = emptyStackViews.index(of: stackview) ?? emptyStackViews.endIndex
            stackview.addSubview(cardStackViews[i])
            cardStackViews[i].setCardStackViewLayout()
        }
    }

    private func setRemainBackCardsViewLayout() {
        let widthOfCard = (self.view.frame.width - 24) / 7
        self.view.addSubview(remainBackCardsView)
        remainBackCardsView.setRatio()
        remainBackCardsView.top(equal: self.view)
        remainBackCardsView.trailing(equal: self.view.trailingAnchor, constant: -3)
        remainBackCardsView.width(constant: widthOfCard)
    }

    private func showAlert(title: String = "잠깐!", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

