package sui;

import kha.Color;
import kha.Shaders;
import kha.Assets;
import kha.Window;
import kha.Scheduler;
import kha.System;
import kha.FastFloat;
import kha.Framebuffer;
import kha.input.Mouse;
import kha.input.Keyboard;
import kha.graphics2.Graphics;

@:build(score.macro.SMacro.build())
class SApp {
	#if SAPP_DEBUG_FPS
	static var fst:FastFloat = 0;
	static var fpsCounter:Int = 0;
	static var fps:Int = 0;

	static inline function showFPS(g2:Graphics) {
		++fpsCounter;
		var t = System.time;
		if (t - fst >= 1) {
			fps = fpsCounter;
			fpsCounter = 0;
			fst = t;
		}
		g2.font = Assets.fonts.get("Roboto_Regular");
		g2.fontSize = 14;
		g2.color = Color.Black;
		g2.drawString('FPS: ${fps}', 6, 6);
		g2.color = Color.White;
		g2.drawString('FPS: ${fps}', 5, 5);
	}
	#end

	public static var window:Window;
	public static var keyboard:Keyboard;
	public static var mouse:Mouse;
	public static var cursor(default, set):MouseCursor;

	static inline function set_cursor(value:MouseCursor):MouseCursor {
		cursor = value;
		mouse.setSystemCursor(value);
		return value;
	}

	static var onUpdateListeners:Array<Void->Void> = [];
	static var onRenderListeners:Array<Void->Void> = [];
	static var updateTaskId:Int;

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
			SApp.mouse = Mouse.get();
			SApp.keyboard = Keyboard.get();

			Assets.loadEverything(function() {
				setup();
				System.notifyOnFrames(function(frames:Array<Framebuffer>) {
					var g2 = frames[0].g2;
					for (f in onRenderListeners)
						f(g2);
					#if SAPP_DEBUG_FPS
					g2.begin(false);
					showFPS(g2);
					g2.end();
					#end
				});
				startUpdates();
			});
		});
	}

	public static inline function stop() {
		System.stop();
	}

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

	public static inline function notifyOnRender(f:Void->Void) {
		onRenderListeners.push(f);
	}

	public static inline function removeRenderListener(f:Void->Void) {
		onRenderListeners.remove(f);
	}
}
