//
//  CollectionViewDelegate.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class CollectionViewDelegate: NSObject {
  
  // MARK: - Properties
  
  private weak var viewController: UIViewController?
  private let didSelectIndexPath: (IndexPath) -> Void
  
  // MARK: - Initializer
  
  init(
    viewController: UIViewController,
    didSelectIndexPath: @escaping (IndexPath) -> Void
  ) {
    self.viewController = viewController
    self.didSelectIndexPath = didSelectIndexPath
  }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewDelegate: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    
    didSelectIndexPath(indexPath)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
    LayoutManager.sizeForItem(in: collectionView)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    
    LayoutManager.sizeForHeader(in: collectionView)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    
    LayoutManager.spacingBetweenCells
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    
    LayoutManager.spacingBetweenCells
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    
    LayoutManager.collectionViewSectionInsets
  }
}
