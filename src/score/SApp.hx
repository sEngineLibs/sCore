package score;

import kha.Canvas;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.Framebuffer;

@:build(score.macro.SMacro.build())
class SApp {
	@readonly public static var window:Window;
	@readonly public static var input:Input;

	public static inline function start(?title:String = "SApp", ?width:Int = 800, ?height:Int = 600, ?vsync:Bool = true, ?samplesPerPixel:Int = 1,
			setup:Void->Void) {
		System.start({
			title: title,
			width: width,
			height: height,
			framebuffer: {
				verticalSync: vsync,
				samplesPerPixel: samplesPerPixel
			}
		}, function(window:Window) {
			SApp.window = window;

			Assets.loadEverything(function() {
				setup();
				System.notifyOnFrames(function(frames:Array<Framebuffer>) {
					var frame = frames[0];
					for (f in onRenderListeners)
						f(frame);
					#if SAPP_DEBUG_FPS
					frame.g2.begin(false);
					showFPS(frame.g2);
					frame.g2.end();
					#end
				});
				startUpdates();
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

	static var onUpdateListeners:Array<Void->Void> = [];
	static var onRenderListeners:Array<Canvas->Void> = [];
	static var updateTaskId:Int;

	public static inline function startUpdates() {
		updateTaskId = Scheduler.addTimeTask(function() {
			for (f in onUpdateListeners)
				f();
		}, 0, 1 / 60);
	}

	public static inline function stopUpdates() {
		Scheduler.removeTimeTask(updateTaskId);
	}

	public static inline function notifyOnUpdate(f:Void->Void) {
		onUpdateListeners.push(f);
	}

	public static inline function removeUpdateListener(f:Void->Void) {
		onUpdateListeners.remove(f);
	}

	public static inline function notifyOnRender(f:Canvas->Void) {
		onRenderListeners.push(f);
	}

	public static inline function removeRenderListener(f:Canvas->Void) {
		onRenderListeners.remove(f);
	}
}
