//
//  ViewController+CollectionViewDelegate.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 11..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rentalCount = self.centerList?.count else { return 0 }
        return rentalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rentalCell", for: indexPath) as? RentalCollectionViewCell {
            cell.setInfo(center: centerList![indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prevOffset = scrollView.contentOffset
        
        if let overlay = overlayItems {
            overlay.deselctFocusedPOIitem()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentOffset = targetContentOffset.pointee
        let visibleItemIndexPath = rentalCollectionView.indexPathsForVisibleItems
        var indexPath: IndexPath?
        
        if let prev = prevOffset {
            if prev.x < currentOffset.x {
                // 앞으로, 큰 쪽 선택
                if var max = visibleItemIndexPath.first {
                    for item in visibleItemIndexPath where item.row > max.row {
                        max = item
                    }
                    indexPath = max
                }
            } else {
                // 뒤로. 작은 쪽 선택
                if var min = visibleItemIndexPath.first {
                    for item in visibleItemIndexPath where item.row < min.row {
                        min = item
                    }
                    indexPath = min
                }
            }
        }
        
        if let idxPath = indexPath {
            if let overlay = overlayItems {
                overlay.selectPOIitem(at: Int32(idxPath.row), moveToCenter: true)
            }
        }
    }
}

class RentalCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth + 5
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if let candAttrs = candidateAttributes {
                        
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes
                        }
                        
                    } else { // == First time in the loop == //
                        
                        candidateAttributes = attributes
                        continue
                    }
                    
                }
                
                return CGPoint(x : candidateAttributes!.center.x - halfWidth, y : proposedContentOffset.y)
            }
        }
        // Fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
