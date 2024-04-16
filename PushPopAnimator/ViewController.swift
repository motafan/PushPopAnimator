//
//  ViewController.swift
//  push
//
//  Created by 风起兮 on 2024/4/16.
//

import UIKit

class ViewController: UIViewController {
    
    let pushAnimator = CustomTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func push(_ sender: Any) {
        
        let vc  = PushViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = pushAnimator
        present(vc, animated:  true)
    }
    
    
}


class PushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}

class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPopAnimator()
    }
}

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5// 动画持续时间
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 定义呈现动画的逻辑
        guard let fromView =  transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
  
        
        // 获取容器视图
        let containerView = transitionContext.containerView
        
        // 添加 toView 到容器视图
        containerView.addSubview(toView)
        
        // 设置初始状态：toView 位于视图的右边
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        toView.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
        
        // 动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = CGAffineTransform(translationX: -containerView.frame.width / 2, y: 0)
            toView.transform = .identity
        }) { finished in
            // 清理
            fromView.transform = .identity
            transitionContext.completeTransition(finished)
        }
    }
}



class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // 返回动画的持续时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // 动画持续时间
    }
    
    // 自定义 `pop` 动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取 fromView 和 toView
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.viewController(forKey: .to)?.view else {
            transitionContext.completeTransition(false)
            return
        }

        // 获取容器视图
        let containerView = transitionContext.containerView
        
        
        // 设置初始状态：toView 位于左边
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        toView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        
        // 动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // 将 fromView 移动到右边并缩小
            fromView.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
            fromView.alpha = 0.5
            
            // 将 toView 移动到最终位置
            toView.transform = .identity
        }) { finished in
            // 重置 fromView 和 toView 的状态
            fromView.transform = .identity
            fromView.alpha = 1.0
            
            // 完成转场
            transitionContext.completeTransition(finished)
        }
    }
}




