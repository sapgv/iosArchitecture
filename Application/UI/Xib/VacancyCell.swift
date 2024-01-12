//
//  VacancyCell.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import UIKit

class VacancyCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    @IBOutlet weak var solaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favouriteImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.favouriteImageView.isHidden = true
    }
    
    func setup(vacancy: IVacancy) {
        self.titleLabel.text = vacancy.title
        self.bodyLabel.text = vacancy.body
        self.solaryLabel.text = vacancy.solary
    }
    
    func setup(isFavourite: Bool) {
        self.favouriteImageView?.isHidden = isFavourite == false
    }
    
}
