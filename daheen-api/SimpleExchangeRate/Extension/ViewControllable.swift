//
//  ViewControllable.swift
//  SimpleExchangeRate
//
//  Created by dana.allwhite on 2020/01/06.
//  Copyright © 2020 allwhite. All rights reserved.
//

import RIBs

extension ViewControllable {
    func present(viewController: ViewControllable, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        viewController.uiviewController.modalPresentationStyle = presentationStyle
        self.uiviewController.present(viewController.uiviewController, animated: true, completion: nil)
    }

    func dismiss(viewController: ViewControllable) {
        if self.uiviewController.presentedViewController === viewController.uiviewController {
            self.uiviewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func push(_ targetViewController: ViewControllable) {
        guard let navigationController = self.uiviewController.navigationController else { return }
        navigationController.pushViewController(targetViewController.uiviewController, animated: true)
    }
    
    func pop(_ targetViewController: ViewControllable) {
        guard let navigationController = self.uiviewController.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    func replace(viewController: ViewControllable?, animated: Bool = true, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        self.uiviewController.replaceModal(viewController: viewController?.uiviewController, animated: animated, presentationStyle: presentationStyle)
    }
}

extension UINavigationController: ViewControllable {}


extension UIViewController {
    internal var animationInProgress: Bool {
      get {
        if let isInProgress  = objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.animationInProgress) as? Bool {
          return isInProgress
        }
        self.animationInProgress = false
        return false
      }
      set { objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.animationInProgress, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    internal var targetViewController: UIViewController? {
        get {
          if let target  = objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.targetViewController) as? UIViewController {
            return target
          }
          self.targetViewController = nil
          return nil
        }
        set { objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.targetViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    internal func replaceModal(viewController: UIViewController?, animated: Bool, presentationStyle: UIModalPresentationStyle) {
        targetViewController = viewController

        guard !animationInProgress else {
            return
        }

        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: animated) { [weak self] in
                if self?.targetViewController != nil {
                    self?.presentTargetViewController(animated: animated, presentationStyle: presentationStyle)
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController(animated: animated, presentationStyle: presentationStyle)
        }
    }
    
    fileprivate func presentTargetViewController(animated: Bool, presentationStyle: UIModalPresentationStyle) {
        if let targetViewController = targetViewController {
            animationInProgress = true
            targetViewController.modalPresentationStyle = presentationStyle
            present(targetViewController, animated: animated) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }
}

public extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var animationInProgress = "animationInProgress"
        static var targetViewController = "targetViewController"
    }
}
