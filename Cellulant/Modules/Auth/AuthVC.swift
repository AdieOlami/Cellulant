//
//  AuthVC.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Material
import RxSwift

class AuthVC: ViewController {
    
    var keyboardheight: CGFloat = 0.0
    let disposeBag = DisposeBag()
    
    lazy var helloLabel: LabelX = {
       let label  = LabelX()
        label.text = "Hi,"
        label.font = MainFont.bold.with(size: 28)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var descLabel: LabelX = {
        let view  = LabelX()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.36
        view.attributedText = NSMutableAttributedString(string: "Kindly login to view amazing users on Cellulant", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        view.font = MainFont.light.with(size: 16)
        view.textColor = UIColor.black
        return view
    }()
    
    lazy var email: DefaultTextField = {
       let field = DefaultTextField()
        field.placeholder = "Email"
        field.layer.borderColor = UIColor.green.cgColor
        field.tag = 2
        field.keyboardType = .emailAddress
        return field
    }()
    
    lazy var password: DefaultTextField = {
        let field = DefaultTextField()
        field.layer.borderColor = UIColor.green.cgColor
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        return field
    }()
    
    lazy var stackViewX: DefaultStackView = {
        let stack = DefaultStackView(arrangedSubviews: [email, password])
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    lazy var signUpBtn: ButtonX = {
        let btn = ButtonX()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor.black
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    lazy var iconImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "nextfast.png")
        return img
    }()
    
    
    lazy var btnStack: DefaultStackView = {
        let stack = DefaultStackView(arrangedSubviews: [signUpBtn])
        stack.axis = .vertical
        return stack
    }()
    
    let scrollView: UIScrollView = {
        let srv = UIScrollView()
        srv.translatesAutoresizingMaskIntoConstraints = false
        srv.showsVerticalScrollIndicator = false
        return srv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        layout()
        logic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func makeUI() {
        super.makeUI()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? AuthViewModel else { return }
        let input = AuthViewModel.Input(nextTrigger: signUpBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.parsedError.asObservable().bind(to: error).disposed(by: rx.disposeBag)

        isLoading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.buttonEnabled.drive(signUpBtn.rx.isEnabled).disposed(by: rx.disposeBag)

        _ = email.rx.textInput <-> viewModel.email
        _ = password.rx.textInput <-> viewModel.password

        output.nextTriggered.drive(onNext: { [weak self] (viewModel) in
//            if viewModel is UserListViewModel {
                if let window = UIApplication.shared.keyWindow {
                    self?.navigator.show(segue: .userList(viewModel: viewModel), sender: self, transition: .root(in: window))
//                }
            }
//            if let window = UIApplication.shared.keyWindow {
//                self?.navigator.show(segue: .userList(viewModel: viewModel), sender: self, transition: .root(in: window))
//            }
//            self?.navigator.show(segue: .userList(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)
    }
}

extension AuthVC {
    private func logic() {
        hideKeyboardWhenTappedAround()
        setupTransition()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    func setupTransition() {
        isMotionEnabled = true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            keyboardheight += keyboardHeight
        }
    }
    
    private func layout() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + keyboardheight )
        scrollView.addSubview(contentView)
        
        contentView.addSubview(helloLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(stackViewX)
        contentView.addSubview(btnStack)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        
        helloLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 26, paddingBottom: 0, paddingRight: 26, width: 0, height: 0, enableInsets: false)
        descLabel.anchor(top: helloLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 26, paddingBottom: 40, paddingRight: 26, width: 0, height: 0, enableInsets: false)
        stackViewX.anchor(top: descLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 40, paddingLeft: 26, paddingBottom: 0, paddingRight: 26, width: 0, height: 0, enableInsets: false)

        btnStack.anchor(top: stackViewX.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 36, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 190, height: 0, enableInsets: false)
        btnStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        
    }
}

