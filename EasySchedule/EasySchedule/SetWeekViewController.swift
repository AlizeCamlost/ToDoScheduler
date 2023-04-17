//
//  SetWeekViewController.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit

protocol SetWeekViewControllerDelegate {
    func didSetWeek(week:[Int])
}

class SetWeekViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var weekCV: UICollectionView!
    var selectedWeek: [Int] = Array(repeating: 0, count: 25)
    let selectedColor = UIColor(red: 128/255, green: 169/255, blue: 1/255, alpha: 1)
    let unselectedColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var layView: UIView?
    var delegate: SetWeekViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.clear
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-240))
        layView?.backgroundColor = UIColor.black
        layView?.alpha = 0.2
        self.view.addSubview(layView!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetWeekViewController.cancle))
        layView?.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath as IndexPath) as! SetWeekCell
        cell.weekNumLabel.text = "\(indexPath.row + 1)"
        return cell
        
    }
    
    //MARK: - UICollectionViewDelegate
    private func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath as IndexPath) as! SetWeekCell
        if !currentCell.choosen {
            currentCell.contentView.backgroundColor = .red
            self.selectedWeek[indexPath.row] = 1
        }else{
            currentCell.contentView.backgroundColor = .clear
            self.selectedWeek[indexPath.row] = 0
        }
        currentCell.choosen = !currentCell.choosen
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height:CGFloat = collectionView.frame.size.height/5
        let width = collectionView.frame.size.width/5
        return CGSizeMake(width, height)
    }
    //MARK - Custom Function
    @IBAction func doneBtnClicked(sender: AnyObject) {
        self.delegate?.didSetWeek(week: self.selectedWeek)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancle(){
        self.layView?.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }

}
