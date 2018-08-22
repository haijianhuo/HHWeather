//
//  ViewController.swift
//  HHWeather
//
//  Created by Haijian Huo on 8/21/18.
//  Copyright © 2018 Haijian Huo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var headerViewHeight: CGFloat = 0.0
    private var cityLabelTop: CGFloat = 0.0
    private var temperatureLabelTop: CGFloat = 0.0
    
    private var panStartY: CGFloat = 0.0
    private var tableViewStartOffset: CGFloat = 0.0
    
    private var lastContentOffset: CGFloat = 0.0
    private var moveDown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewHeight = headerViewHeightConstraint.constant
        cityLabelTop = cityLabelTopConstraint.constant
        temperatureLabelTop = temperatureLabelTopConstraint.constant
        
        collectionView.dataSource = self
    }
    
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        if sender.state == .began {
            panStartY = translation.y
            tableViewStartOffset = tableView.contentOffset.y
        }
        
        if sender.state == .changed {
            let offset = panStartY - translation.y
            var delta = tableViewStartOffset + offset
            
            if delta < 0 {
                delta = 0
            }
            //print(delta)
            tableView.setContentOffset(CGPoint(x: 0, y: delta), animated: false)
            
        }
        
        if sender.state == .ended {
            
        }
        
        
    }
    
    private func animateTopHeader(offset: CGFloat, start: CGFloat, end: CGFloat) {
        var percent: CGFloat = 1.0
        if offset >= start && offset <= end {
            let duration = end - start
            percent = (end - offset) / duration
        }
        else if offset > end {
            percent = 0.0
        }
        
        let upOffset = temperatureLabelTop * (percent - 1.0)
        
        cityLabelTopConstraint.constant = cityLabelTop + upOffset
        temperatureLabelTopConstraint.constant = temperatureLabelTop + upOffset
        
    }
    
    private func animateLabel(label: UILabel, offset: CGFloat, start: CGFloat, end: CGFloat) {
        var alpha: CGFloat = 1.0
        if offset >= start && offset <= end {
            let duration = end - start
            alpha = (end - offset) / duration
        }
        else if offset > end {
            alpha = 0.0
        }
        label.alpha = alpha
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        
        if (self.lastContentOffset > offset) {
            moveDown = true
        }
        else if (self.lastContentOffset < offset) {
            moveDown = false
        }
        self.lastContentOffset = offset
        
        if offset > tableHeaderView.frame.height {
            offset = tableHeaderView.frame.height
        }
        headerViewHeightConstraint.constant = headerViewHeight - offset
        
        animateTopHeader(offset: offset, start: 0, end: 100)
        
        animateLabel(label: todayLabel, offset: offset, start: 0, end: 50)
        animateLabel(label: temperatureLabel, offset: offset, start: 20, end: 100)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        
        if offset > 60 && offset < tableHeaderView.frame.height - 60 {
            if moveDown {
                tableView.setContentOffset(.zero, animated: true)
            }
            else {
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
}

