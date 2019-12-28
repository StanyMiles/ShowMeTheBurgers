//
//  LayoutManager.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct LayoutManager {
  
  // MARK: - Properties
  
  static let spacingBetweenCells: CGFloat = 12
  static let mapHorizontalOffset: CGFloat = 32
  static let mapVerticalOffset: CGFloat   = 16
 
  static var collectionViewSectionSpacing: CGFloat = {
    isPad ? 40 : 32
  }()
  
  static var collectionViewSectionInsets: UIEdgeInsets {
    UIEdgeInsets(
      top: 8,
      left: collectionViewSectionSpacing,
      bottom: 32,
      right: collectionViewSectionSpacing)
  }
 
  static var mapPadding: UIEdgeInsets {
    UIEdgeInsets(
      top: mapVerticalOffset,
      left: mapHorizontalOffset,
      bottom: mapVerticalOffset,
      right: mapHorizontalOffset)
  }
  
  private static var isPad: Bool = {
    UIDevice.current.userInterfaceIdiom == .pad
  }()

  // MARK: - Initializer
  
  private init() {}
  
  // MARK: - Funcs
  
  static func sizeForItem(in collectionView: UICollectionView) -> CGSize {
    
    let cellsCount: CGFloat = isPad ? 4 : 2
    let spacingsCount = cellsCount - 1
    let totalSpacings = spacingBetweenCells * spacingsCount
    let totalSectionOffset = collectionViewSectionSpacing * 2
    let totalSpaceForCells = collectionView.frame.size.width - totalSpacings - totalSectionOffset
    let width = totalSpaceForCells / cellsCount
    
    return .init(width: width, height: width)
  }
  
  static func sizeForHeader(in collectionView: UICollectionView) -> CGSize {
    
    let width = collectionView.frame.size.width
    let height: CGFloat = isPad ? 520 : 420
    return .init(width: width, height: height)
  }
  
}
