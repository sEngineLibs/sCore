package score;

import kha.input.Keyboard;
import kha.input.Mouse;

class Input {
	public static var mouse(get, never):Mouse;
	public static var keyboard(get, never):Keyboard;
	public static var cursor(default, set):MouseCursor;

	static inline function get_mouse():Mouse {
		return Mouse.get();
	}

	static inline function get_keyboard():Keyboard {
		return Keyboard.get();
	}

	static inline function set_cursor(value:MouseCursor):MouseCursor {
		cursor = value;
		mouse.setSystemCursor(value);
		return value;
	}
}
