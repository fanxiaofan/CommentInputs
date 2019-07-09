//
//  FFYEmojiScrollView.swift
//  FFF
//
//  Created by fanfengyan on 2019/6/5.
//  Copyright © 2019 com.advance. All rights reserved.
//

import UIKit

class FFYEmojiScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    var delegate: EmojiKeyBoardViewDelegate?
    var scrollBoundaryDelegate: ScrollCardBoundaryDelegate?
    var horizoneNumberOfElements: Int = 1
    var verticalNumberOfElements: Int = 1
    
    var emojiPageControl: UIPageControl!
    var emojiArray:[String]! {
        didSet {
            collectionView.reloadData()
            emojiPageControl.numberOfPages = self.collectionView(collectionView, numberOfItemsInSection: 0)
        }
    }
    
    init(frame: CGRect, horizoneNumbers: Int = 6, verticalNumbers: Int = 6) {
        horizoneNumberOfElements = horizoneNumbers < 1 ? 1 : horizoneNumbers
        verticalNumberOfElements = verticalNumbers < 1 ? 1 : verticalNumbers
        super.init(frame: frame)
        self.backgroundColor = .white
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("collection: " + collectionView.bounds.debugDescription)
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    func setupSubViews() {
        let collectionTop: CGFloat  = 10
        let collectionBottom : CGFloat = 30
        let minimumLineSpace:CGFloat = 60
        let minimumItemSpace:CGFloat = 0
        let insets: UIEdgeInsets = .init(top: 0, left: minimumLineSpace/2, bottom: 0, right: minimumLineSpace/2)
        let itemSize:CGSize = .init(width: self.frame.width - minimumLineSpace, height: self.frame.height - collectionTop - collectionBottom)
        
        let pageControl = UIPageControl(frame: .zero)
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(collectionBottom)
        }
        emojiPageControl = pageControl
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(named: "delete_icon"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(pageControl)
            make.right.equalTo(-20)
        }
        
        
        let flowLayout = FFYHorizonCardFlowLayout(insets: insets, miniLineSpace: minimumLineSpace, miniItemSpace: minimumItemSpace, itemSize: itemSize)
        flowLayout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.contentInset = insets
        collectionView.register(FFYEmojiCollectionViewCell.self, forCellWithReuseIdentifier: FFYEmojiCollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.bottom.equalTo(-collectionBottom)
        }
    }
    
    @objc func deleteAction() {
        if let keyboardDelegate = delegate {
            keyboardDelegate.emojiKeyBoardDidClickBackSpace(keyboardDelegate)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.width > 0 else { return }
        let scrollOffset = scrollView.contentOffset.x + self.bounds.width - self.collectionView.contentSize.width
        if scrollView.contentOffset.x < 0 {
            scrollBoundaryDelegate?.scrollToBoundary(offset: scrollView.contentOffset.x)
        }else if scrollOffset > 0 {
            print(scrollView.contentOffset)
            print(scrollView.contentSize)
            scrollBoundaryDelegate?.scrollToBoundary(offset: scrollOffset)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.width > 0 else { return }
        let scrollOffset = scrollView.contentOffset.x + self.bounds.width - self.collectionView.contentSize.width
        let minSpaceForSwitch = self.bounds.width / 6
        if scrollView.contentOffset.x < 0 && scrollView.contentOffset.x < -minSpaceForSwitch {
            scrollBoundaryDelegate?.switchToPrevCategory(prev: true)
        }else if scrollOffset > 0 && scrollOffset > minSpaceForSwitch {
            print(scrollView.contentOffset)
            print(scrollView.contentSize)
            scrollBoundaryDelegate?.switchToPrevCategory(prev: false)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let remainder = emojiArray.count % (horizoneNumberOfElements * verticalNumberOfElements)
        let numberOfCell   = emojiArray.count / (horizoneNumberOfElements * verticalNumberOfElements)
        return remainder > 0 ? numberOfCell + 1 : numberOfCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: FFYEmojiCollectionViewCell.reuseIdentifier, for: indexPath) as? FFYEmojiCollectionViewCell
        if emojiCell == nil {
            emojiCell = FFYEmojiCollectionViewCell(horizoneNumbers: horizoneNumberOfElements, verticalNumbers: verticalNumberOfElements)
        }else {
            emojiCell?.horizoneNumberOfElements = horizoneNumberOfElements
            emojiCell?.verticalNumberOfElements = verticalNumberOfElements
        }
        setupCell(emojiCell: emojiCell, indexPath: indexPath)
        
        return emojiCell!
    }
    
    
    private func setupCell(emojiCell: FFYEmojiCollectionViewCell?, indexPath: IndexPath) {
        
        emojiCell?.setupSubViews()
        var emojisForCell = [String]()
        let emojisCount = emojiArray.count
        let emojisstart  = indexPath.row * horizoneNumberOfElements * verticalNumberOfElements
        let emojisEnd  = (indexPath.row + 1) * horizoneNumberOfElements * verticalNumberOfElements
        if emojisEnd >= emojisCount {
            emojisForCell.append(contentsOf: emojiArray[emojisstart..<emojisCount])
        }else {
            emojisForCell.append(contentsOf: emojiArray[emojisstart..<emojisEnd])
        }
        
        emojiCell?.setupCell(with: delegate, emojis: emojisForCell)
    }
}


extension FFYEmojiScrollView: HorizonScrollCardDelegate {
    func willShowCard(at index: Int, with offset: CGFloat) {
        emojiPageControl.currentPage = index
    }
}
