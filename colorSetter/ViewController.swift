//
//  ViewController.swift
//  colorSetter
//
//  Created by Anton Saltykov on 05.08.2022.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var colorRectangle: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
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
        sender.label?.text = getFormatLabel(for: sender.value)
    }

    @IBAction func getHex() {
        let hex = getHexFromRGB(red: redSlider.value, green: greenSlider.value, blue: blueSlider.value)
        showAlert(with: "Цвет в формате HEX", and: "\(hex)")
    }


    // MARK: - Private Methods
    private func setupSliders() {
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue

        redSlider.label = redValueLabel
        greenSlider.label = greenValueLabel
        blueSlider.label = blueValueLabel

        for slider in sliders {
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.setValue(0.2, animated: false)
            slider.label?.text = getFormatLabel(for: slider.value)
        }
    }
    
    private func setColor() {
        colorRectangle.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                                green: CGFloat(greenSlider.value),
                                                blue: CGFloat(blueSlider.value),
                                                alpha: 1)
    }

    private func getFormatLabel(for value: Float) -> String {
        String(format: "%.2f", value)
    }

    private func getHexFromRGB(red: Float, green: Float, blue: Float) -> String {
        // Подсмотрено на стэковерфлоу :)
        let rgb: Int = (Int)(red * 255)<<16 | (Int)(green * 255)<<8 | (Int)(blue * 255)<<0
        return String(format:"#%06x", rgb)
    }
}

// MARK: - Extensions
/*
Основная идея - упростить взаимодействие с лэйблом при переключении слайдера, "прикрепив" конкретный лейбл к слайдеру.
Теперь имея в экшен слайдер sender можно будет получить связанный с ним label и работать с ним.
Изначально я сделал механику, которая в changeSliderValue меняет все значения лэйблов.
Но решил, что это не очень эффективно - каждый раз переписывать все значения, когда меняется только одно.
А связывать каждый слайдер со своим экшеном тоже не хочется, не универсально это как-то.
Подсмотрел реализацию в интернете, вероятно как-то можно покрасивее сделать... Выглядит как костыль, но работает))
*/
extension UISlider {
    private static var _labels: [String: UILabel] = [:]

    var label: UILabel? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UISlider._labels[tmpAddress] ?? nil
        }
        set(label) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UISlider._labels[tmpAddress] = label
        }
    }
}

extension ViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Спасибо!", style: .default)

        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}
