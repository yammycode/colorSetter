//
//  ViewController.swift
//  colorSetter
//
//  Created by Anton Saltykov on 05.08.2022.
//

import UIKit

final class SettingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var colorRectangle: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!

    // MARK: - Public Properties
    var color: UIColor!
    var delegate: SettingViewControllerDelegate!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        colorRectangle.layer.cornerRadius = 30
        setupSliders()
        setColor()
    }
    
    // MARK: - IBAction
    @IBAction func changeSliderValue(_ sender: UISlider) {
        setColor()
        sender.label?.text = getFormatLabel(for: sender)
    }
    @IBAction func doneButtonPressed() {
        delegate.setBackground(color: color)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupSliders() {
        setSliderData(for: redSlider, trackColor: .red, withLabel: redValueLabel, andValue: color.rgba.red)
        setSliderData(for: greenSlider, trackColor: .green, withLabel: greenValueLabel, andValue: color.rgba.green)
        setSliderData(for: blueSlider, trackColor: .blue, withLabel: blueValueLabel, andValue: color.rgba.blue)
    }

    private func setSliderData(
        for slider: UISlider,
        trackColor: UIColor,
        withLabel label: UILabel,
        andValue value: Double
    ) {
        slider.minimumTrackTintColor = trackColor
        slider.setValue(Float(value), animated: false)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.label = label
        slider.label?.text = getFormatLabel(for: slider)
    }
    
    private func setColor() {
        color = UIColor(red: CGFloat(redSlider.value),
                        green: CGFloat(greenSlider.value),
                        blue: CGFloat(blueSlider.value),
                        alpha: 1)

        colorRectangle.backgroundColor = color
    }

    private func getFormatLabel(for slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }

    private func getHexFromRGB(red: Float, green: Float, blue: Float) -> String {
        let rgb: Int = (Int)(red * 255)<<16 | (Int)(green * 255)<<8 | (Int)(blue * 255)<<0
        return String(format:"#%06x", rgb)
    }
}

// MARK: - Extensions
extension SettingViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Спасибо!", style: .default)

        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}

