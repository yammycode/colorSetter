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
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!

    @IBOutlet var redInputTF: UITextField!
    @IBOutlet var greenInputTF: UITextField!
    @IBOutlet var blueInputTF: UITextField!

    // MARK: - Public Properties
    var color: UIColor!
    var delegate: SettingViewControllerDelegate!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        colorRectangle.layer.cornerRadius = 30
        colorRectangle.backgroundColor = color

        setupSliders()
        setupInputs()
        setupTextFields()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction func changeSliderValue(_ sender: UISlider) {
        setColorFromSliders()
        setLabel(from: sender)
        setTextField(from: sender)
    }

    @IBAction func doneButtonPressed() {
        // Блокируем случай, если юзер ввел вручную некорректные данные и сразу нажал на кнопку
        if checkAndGetCorrectColorNumber(from: redInputTF) == nil ||
            checkAndGetCorrectColorNumber(from: greenInputTF) == nil ||
            checkAndGetCorrectColorNumber(from: blueInputTF) == nil {
            return
        }

        view.endEditing(true)
        delegate.setBackground(color: color)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setColorFromSliders() {
        color = UIColor(red: CGFloat(redSlider.value),
                        green: CGFloat(greenSlider.value),
                        blue: CGFloat(blueSlider.value),
                        alpha: 1)

        colorRectangle.backgroundColor = color
    }

    private func getFormattedValue(for slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }

}

// MARK: - Setup UI elements
extension SettingViewController {
    private func setupSliders() {
        setupSliderData(for: redSlider, trackColor: .red, andValue: color.rgba.red)
        setupSliderData(for: greenSlider, trackColor: .green, andValue: color.rgba.green)
        setupSliderData(for: blueSlider, trackColor: .blue, andValue: color.rgba.blue)
    }

    private func setupSliderData(for slider: UISlider, trackColor: UIColor, andValue value: Double) {
        slider.minimumTrackTintColor = trackColor
        slider.setValue(Float(value), animated: false)
        setLabel(from: slider)
    }

    private func setupInputs() {
        [redSlider, greenSlider, blueSlider].forEach {
            setTextField(from: $0)
        }
    }

    private func setupTextFields() {
        let bar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(inputDone))
        bar.items = [flexibleSpace, reset]
        bar.sizeToFit()

        [redInputTF, greenInputTF, blueInputTF].forEach {
            $0?.inputAccessoryView = bar
            $0?.delegate = self
        }
    }

    @objc private func inputDone() {
        view.endEditing(true)
    }
}

// MARK: - Set linked data
private extension SettingViewController {
     func setLabel(from slider: UISlider) {
        switch slider {
        case redSlider:
            redValueLabel.text = getFormattedValue(for: slider)
        case greenSlider:
            greenValueLabel.text = getFormattedValue(for: slider)
        default:
            blueValueLabel.text = getFormattedValue(for: slider)
        }
    }

    private func setTextField(from slider: UISlider) {
        switch slider {
        case redSlider:
            redInputTF.text = getFormattedValue(for: slider)
        case greenSlider:
            greenInputTF.text = getFormattedValue(for: slider)
        default:
            blueInputTF.text = getFormattedValue(for: slider)
        }
    }

    private func setSliderValue(from textField: UITextField) {
        guard let numberValue = checkAndGetCorrectColorNumber(from: textField) else { return }

        switch textField {
        case redInputTF:
            redSlider.value = numberValue
        case greenInputTF:
            greenSlider.value = numberValue
        default:
            blueSlider.value = numberValue
        }
    }
}

// MARK: - TextField logic
extension SettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        setSliderValue(from: textField)
        setColorFromSliders()
    }

    private func checkAndGetCorrectColorNumber(from textField: UITextField) -> Float? {
        guard let newValue = textField.text else { return nil }

        guard let numberValue = Float(newValue) else {
            showAlert(with: "Некорректный тип данных",
                      and: "Введено значение, которое нельзя привести к числу",
                      on: textField)
            return nil
        }

        guard (0...1).contains(numberValue) else {
            showAlert(with: "Некорректное значение", and: "Введите число от 0 до 1", on: textField)
            return nil
        }

        return numberValue
    }

    private func showAlert(with title: String, and message: String, on textField: UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            textField.text = "0.0"
            textField.becomeFirstResponder()
        }

        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

