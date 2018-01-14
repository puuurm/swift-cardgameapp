//
//  CardDeck.swift
//  CardGameApp
//
//  Created by yangpc on 2017. 12. 24..
//  Copyright © 2017년 yang hee jung. All rights reserved.
//

import Foundation

struct CardDeck {
    private(set) var cards: [Card] = []

    var top: Card? {
        if self.count()-1 < 0 { return nil }
        return cards[self.count()-1]
    }

    init() {
        cards = makeCards()
    }

    // count() 갖고 있는 카드 개수를 반환한다.
    func count() -> Int {
        return cards.count
    }

    // shuffle() 기능은 전체 카드를 랜덤하게 섞는다.
    mutating func shuffle() {
        var count = self.count()
        while count > 1 {
            count -= 1
            let tempIndex = Int(arc4random_uniform(UInt32(count)))
            cards.swapAt(count, tempIndex)
        }
    }

    // removeOne() 기능은 카드 인스턴스 중에 하나를 반환하고 목록에서 삭제한다.
    @discardableResult mutating func removeOne() -> Card? {
        if cards.isEmpty { return nil }
        let deleteCard = cards[self.count()-1]
        cards.removeLast()
        return deleteCard
    }

    // reset() 처음처럼 모든 카드를 다시 채워넣는다.
    mutating func reset() {
        cards.removeAll()
        cards = makeCards()
    }

    // 카드를 꺼낸다
    mutating func pickCards(number: Int) throws -> [Card] {
        var pikedCards = [Card]()
        for _ in 0..<number {
            guard let remove = removeOne() else {
                throw CardGameError.emptyCard
            }
            pikedCards.append(remove)

        }
        return pikedCards
    }

    private func makeCards() -> [Card] {
        var cards = [Card]()
        for suit in Card.Suit.allTypes {
            for rank in Card.Rank.allTypes {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        return cards
    }

}
