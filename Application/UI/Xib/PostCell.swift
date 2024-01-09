//
//  PostCell.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favouriteImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.favouriteImageView.isHidden = true
    }
    
    func setup(post: IPost) {
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
    }
    
}
