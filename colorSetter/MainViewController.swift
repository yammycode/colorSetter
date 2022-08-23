//
//  MainViewController.swift
//  colorSetter
//
//  Created by Anton Saltykov on 23.08.2022.
//

import UIKit

protocol SettingViewControllerDelegate {
    func setBackground(color: UIColor)
}

final class MainViewController: UIViewController {

    // MARK: - Private Properties
    private var color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(color: color)
    }

    // MARK: - Override Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? SettingViewController else { return }
        settingVC.color = color
        settingVC.delegate = self
    }
}

// MARK: - Extensions
extension MainViewController: SettingViewControllerDelegate {
    func setBackground(color: UIColor) {
        self.color = color
        view.backgroundColor = color
    }
}
