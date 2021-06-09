var exports = exports || {};

function getBezierValue(controls, t) {
    let xc1 = controls[0];
    let yc1 = controls[1];
    let xc2 = controls[2];
    let yc2 = controls[3];
    return [3 * xc1 * (1 - t) * (1 - t) * t + 3 * xc2 * (1 - t) * t * t + t * t * t, 3 * yc1 * (1 - t) * (1 - t) * t + 3 * yc2 * (1 - t) * t * t + t * t * t];
}

function getBezierDerivative(controls, t) {
    let xc1 = controls[0];
    let yc1 = controls[1];
    let xc2 = controls[2];
    let yc2 = controls[3];
    return [3 * xc1 * (1 - t) * (1 - 3 * t) + 3 * xc2 * (2 - 3 * t) * t + 3 * t * t, 3 * yc1 * (1 - t) * (1 - 3 * t) + 3 * yc2 * (2 - 3 * t) * t + 3 * t * t];
}

function getBezierTfromX(controls, x) {
    let ts = 0.0;
    let te = 1.0;
    do {
        let tm = (ts + te) / 2.0;
        let value = getBezierValue(controls, tm)
        if (value[0] > x)
            te = tm;
        else
            ts = tm;
    } while ((te - ts) >= 0.0001);
    return (te + ts) / 2.0;
}

function tweenCallback4(t, b, c, d) {
    t = t / d;
    let controls = [0.25, 0.46, 0.45, 0.94];
    let tvalue = getBezierTfromX(controls, t);
    let value = getBezierValue(controls, tvalue);
    return b + c * value[1];
}

function tweenCallback3(t, b, c, d) {
    t = t / d;
    let controls = [.73, .01, .94, .14];
    let tvalue = getBezierTfromX(controls, t);
    let value = getBezierValue(controls, tvalue);
    return b + c * value[1];
}

function tweenCallback2(t, b, c, d) {
    t = t / d;
    let controls = [.17, .87, .41, .96];
    let tvalue = getBezierTfromX(controls, t);
    let value = getBezierValue(controls, tvalue);
    return b + c * value[1];
}

function tweenCallback1(t, b, c, d) {
    t = t / d;
    if (t != 0.0 && t != 1.0) {
        t = Math.pow(2, -10 * (t / 2.0)) * Math.sin((t / 2.0 - 0.4 / 4) * (2 * Math.PI) / 0.4) + 1
    }
    return linear(t, b, c, 1)
}
                     
 function linear(t, b, c, d) {
     let t1 = t / d;
     return b + c * t1;
 }
                     

function tweenBlurCallback1(t, b, c, d) {
    t = t / d;
    let controls = [.06, .81, .09, 1.02];
    let tvalue = getBezierTfromX(controls, t);
    let deriva = getBezierDerivative(controls, tvalue);
    return Math.abs(deriva[1] / deriva[0]) * c + b;
}

function tweenBlurCallback2(t, b, c, d) {
    t = t / d;
    let controls = [1, .01, .89, .15];
    let tvalue = getBezierTfromX(controls, t);
    let deriva = getBezierDerivative(controls, tvalue);
    return Math.abs(deriva[1] / deriva[0]) * c + b;
}

//function Transform() {
//    this.tweenDirty = true;
//    this.filter = null;
//    this.transform = null;
//    this.duration = 0;
//    this.actions = [{
//            startScale: [1.0, 1.0, 1.0],
//            endScale: [1.5, 1.5, 1.0],
//            actionCB: tweenCallback2,
//            start: 0.0,
//            end: 1.0
//        },
//        {
//            startAlpha: 1.0,
//            endAlpha: 0,
//            actionCB: tweenCallback2,
//            start: 0.0,
//            end: 1.0
//        },
//        {
//            blurIntensity: 0.0,
//            blurType: 0,
//            blurDirection: [1, 0],
//            actionCB: tweenCallback2,
//            start: 0.0,
//            end: 1
//        }
//    ];
//}
//Transform.prototype.onStart = function(context) {
////    this.filter = context.getFilter("default");
////    this.filter.enableMacro("BLUR_TYPE", 0);
////    this.transform = this.filter.getComponent("Transform");
//    this.tweenDirty = true;
//    checkDirty(this);
//}
//
//function checkDirty(t) {
//    if (t.tweenDirty) {
//        for (var index = 0; index < t.actions.length; index++) {
//            var action = t.actions[index];
//            var target = null;
//            var from = {};
//            var to = {};
//            if (!!action.startPosition) {
//                target = t.transform;
//                from["srcPosition"] = action.startPosition;
//            }
//            if (!!action.startScale) {
//                target = t.transform;
//                from["srcScale"] = action.startScale;
//            }
//            if (!!action.startRotate) {
//                target = t.transform;
//                from["srcRotate"] = action.startRotate;
//                if (!!action.anchorPoint) {
//                    target.srcAnchorPoint = action.anchorPoint;
//                }
//            }
//            if (!!action.endPosition) {
//                target = t.transform;
//                to["srcPosition"] = action.endPosition;
//            }
//            if (!!action.endScale) {
//                target = t.transform;
//                to["srcScale"] = action.endScale;
//            }
//            if (!!action.endRotate) {
//                target = t.transform;
//                to["srcRotate"] = action.endRotate;
//                if (!!action.anchorPoint) {
//                    target.srcAnchorPoint = action.anchorPoint;
//                }
//            }
//            if (action.blurType != null) {
//                target = t.filter;
////                t.filter.enableMacro("BLUR_TYPE", action.blurType);
////                t.filter["blurDirection"] = action.blurDirection;
////                from["blurStep"] = action.blurIntensity / (t.duration * (action.end - action.start));
//                to["blurStep"] = 0.0;
//            }
//            if (action.startAlpha != null) {
//                target = t.filter;
//                from["alpha"] = action.startAlpha;
//            }
//            if (action.endAlpha != null) {
//                target = t.filter;
//                to["alpha"] = action.endAlpha;
//            }
////            action.tween = VECore.createTween(target, from, to, t.duration * (action.end - action.start), action.actionCB);
//        }
//        t.tweenDirty = false;
//    }
//}
//Transform.prototype.onSeek = function(time) {
//    checkDirty(this);
////    this.transform.reset();
////    for (var index = 0; index < this.actions.length; index++) {
////        var action = this.actions[index];
////        var progress = time / this.duration;
////        if (progress >= action.start && progress <= action.end) {
////            if (action.blurType != null) {
////                this.filter.enableMacro("BLUR_TYPE", action.blurType);
////            }
////            action.tween.seek(time - action.start * this.duration);
////        }
////    }
//}
//Transform.prototype.setDuration = function(duration) {
//    this.duration = duration;
//    this.tweenDirty = true;
//}
////Transform.prototype.onClear = function() {
////    for (var index = 0; index < this.actions.length; index++) {
////        let action = this.actions[index];
////        action.tween.seek(0);
////        action.tween.clear();
////    }
////    this.tweenDirty = true;
////}
////exports.Transform = Transform;
////export {
////    exports
////}
//
