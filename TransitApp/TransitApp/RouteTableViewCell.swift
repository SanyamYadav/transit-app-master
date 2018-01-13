//
//  RouteTableViewCell.swift
//  TransitApp
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var routeProviderLabel: UILabel!
    @IBOutlet weak var routeSummaryLabel: UILabel!
    @IBOutlet weak var routeDurationLabel: UILabel!
    @IBOutlet weak var routeSegmentsView: RouteSegmentsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //It is necessary to prepare the custom view to reuse too.
        routeSegmentsView.prepareForReuse()
    }

}
