//
//  FFYHorizonCardFlowLayout.swift
//  FFF
//
//  Created by Just Do It on 2019/6/14.
//  Copyright © 2019 com.advance. All rights reserved.
//

import UIKit
import Foundation

protocol HorizonScrollCardDelegate:class {
    func willShowCard(at index: Int, with offset: CGFloat) -> Void
}

class FFYHorizonCardFlowLayout: UICollectionViewFlowLayout {
    var sectionInsets: UIEdgeInsets = .zero
    var miniLineSpace: CGFloat = 10
    var minimumInteritemSpace: CGFloat = 10
    var eachItemSize: CGSize = .zero
    var scrollAnimation: Bool = false
    var lastOffset: CGPoint = .zero
    
    weak var delegate:HorizonScrollCardDelegate?
    
    init(insets: UIEdgeInsets, miniLineSpace: CGFloat, miniItemSpace: CGFloat, itemSize: CGSize) {
        super.init()
        self.miniLineSpace = miniLineSpace
        self.minimumInteritemSpace = miniItemSpace
        self.sectionInsets = insets
        self.eachItemSize = itemSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func getCopyOfAttributes(attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        var result = [UICollectionViewLayoutAttributes]()
        for attribute in attributes{
            result.append(attribute)
        }
        return result
    }
    
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.sectionInset = sectionInsets
        self.minimumLineSpacing = miniLineSpace
        self.minimumInteritemSpacing = minimumInteritemSpace
        self.itemSize = eachItemSize
        self.collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pageSpace = stepSpace()
        guard let aCollectionView = collectionView else {
            return .zero
        }
        
        let offsetMax:CGFloat = aCollectionView.contentSize.width - pageSpace
        let offsetMin:CGFloat = 0
        
        if lastOffset.x < offsetMin {
            lastOffset.x = offsetMin
        }else if lastOffset.x > offsetMax {
            lastOffset.x =  offsetMax
        }
        
        var offset:CGPoint = .zero
        let velocityX = velocity.x
        let distance = proposedContentOffset.x - lastOffset.x
        let offsetForCurrentPointX: CGFloat = abs(distance)
        //finger swipe to left is yes, to right is false
        let direction = distance > 0
        
        if offsetForCurrentPointX > pageSpace / 8.0 && lastOffset.x >= offsetMin && lastOffset.x <= offsetMax{
            var pageFactor:CGFloat = 1
            if velocityX != 0 {
                pageFactor = abs(velocityX)
            }else{
                pageFactor = abs(offsetForCurrentPointX/pageSpace)
            }
            pageFactor = pageFactor < 1 ? 1 : (pageFactor < 3 ? 1 : 1)//now need set to 1, to avoid invalid offset
            let pageOffsetX = pageSpace * pageFactor
            offset = CGPoint(x:lastOffset.x + (direction ? pageOffsetX : -pageOffsetX ), y: proposedContentOffset.y)
            if let handler = delegate {
                let index = offset.x / pageSpace
                let cardOffset = Int(offset.x) % Int(pageSpace)
                handler.willShowCard(at: Int(index), with: CGFloat(cardOffset))
            }
        }else{
            offset = CGPoint(x: lastOffset.x, y: lastOffset.y)
        }
        lastOffset.x = offset.x
        return offset
    }
    
    func stepSpace() -> CGFloat {
        return eachItemSize.width + miniLineSpace
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let copiedAttributes = getCopyOfAttributes(attributes: attributes)
        guard let collView = collectionView else {
            return nil
        }
        if self.scrollAnimation {
            let centerX = collView.contentOffset.x + collView.bounds.size.width/2.0
            for attribute in copiedAttributes {
                let distance = abs(attribute.center.x - centerX)
                let apartScale = distance / collView.bounds.size.width
                let scale = abs(cos(apartScale * CGFloat.pi / 4))
                var plan3D = CATransform3DIdentity
                plan3D = CATransform3DScale(plan3D, 1, scale, 1)
                attribute.transform3D = plan3D
            }
        }
        return copiedAttributes
    }
    
    var selectedIndex: Int {
        return Int(lastOffset.x / stepSpace())
    }
}
