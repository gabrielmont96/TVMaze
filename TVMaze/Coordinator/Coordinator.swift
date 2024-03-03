//
//  Coordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: Coordinator? { get set }
    var viewController: UIViewController { get set }
    var navigationController: UINavigationController? { get set }
        
    func stop()
    func route(to coordinator: Coordinator, withPresenter presenter: CoordinatorPresenter, animated: Bool)
    func performRoute(usingPresenter presenter: CoordinatorPresenter, animated: Bool)
}

extension Coordinator {
    func route(to coordinator: Coordinator,
               withPresenter presenter: CoordinatorPresenter,
               animated: Bool = true) {
        childCoordinator = coordinator
        coordinator.performRoute(usingPresenter: presenter, animated: animated)
    }

    func stop() {
        childCoordinator = nil
        navigationController = nil
    }
    
    func performRoute(usingPresenter presenter: CoordinatorPresenter, animated: Bool) {
        navigationController = presenter.present(destiny: viewController, animated: animated)
    }
}

protocol CoordinatorPresenterProtocol {
    var rootViewController: UIViewController { get }
    func present(destiny destinyViewController: UIViewController, animated: Bool) -> UINavigationController
}

enum CoordinatorPresenter: CoordinatorPresenterProtocol {
    case push(UINavigationController)
    case present(UIViewController, UIModalPresentationStyle = .fullScreen)
}

extension CoordinatorPresenter {
    var rootViewController: UIViewController {
        switch self {
        case .push(let navigationController):
            return navigationController
        case .present(let viewController, _):
            return viewController
        }
    }
    
    func present(destiny destinyViewController: UIViewController, animated: Bool) -> UINavigationController {
        switch self {
        case .push(let navigationController):
            return pushStart(navigationController: navigationController, destiny: destinyViewController, animated: animated)
        case .present(let viewController, let style):
            return presentStart(viewController: viewController, style: style, destiny: destinyViewController, animated: animated)
        }
    }
}

private extension CoordinatorPresenter {
    func pushStart(navigationController: UINavigationController,
                   destiny destinyViewController: UIViewController,
                   animated: Bool) -> UINavigationController {
        navigationController.pushViewController(destinyViewController, animated: animated)
        return navigationController
    }
    
    func presentStart(viewController: UIViewController,
                      style: UIModalPresentationStyle,
                      destiny destinyViewController: UIViewController,
                      animated: Bool) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: destinyViewController)
        navigationController.modalPresentationStyle = style
        viewController.present(navigationController, animated: animated, completion: nil)
        return navigationController
    }
}
