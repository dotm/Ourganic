//
//  MyProductCollectionViewCell.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 01/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class MyProductCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var productImage: UIImage = UIImage(named: "defaultimage")! {
        didSet {
            productImageView.image = productImage
        }
    }
    var productName: String = "Name" {
        didSet {
            productNameLabel.text = productName
        }
    }
    
    //MARK: Outlets
    private weak var productImageView: UIImageView!
    private weak var productNameLabel: UILabel!
    
    //MARK: Lifecycle Hook
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: Setup Layout
    private func setupLayout(){
        setupProductImageView()
        setupProductNameLabel()
    }
    private func setupProductImageView(){
        let imageView = UIImageView()
        imageView.image = productImage
        
        let parent = self
        parent.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        
        self.productImageView = imageView
    }
    private func setupProductNameLabel(){
        let label = UILabel()
        label.text = productName
        label.textColor = .white
        label.textAlignment = .center
        
        let parent = self
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
        self.productNameLabel = label
    }
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
