//
//  SettingsViewController.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/13/23.
//

import UIKit

class SettingsViewController: UIViewController {
    var delegate: UpdateWeather?
    let defaults = UserDefaults.standard
    let keys = Keys()

    let settingsManager = SettingsManager()
    @IBOutlet weak var UnitsSwitcher: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        UnitsSwitcher.selectedSegmentIndex = GlobalData.shared.selectedUnitIndex
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DoneClicked(_ sender: UIButton) {
        defaults.set(UnitsSwitcher.selectedSegmentIndex, forKey: keys.UNITS_SELECTED)
        settingsManager.checkUnitsSelected()
        delegate?.UpdateWeatherData()
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
