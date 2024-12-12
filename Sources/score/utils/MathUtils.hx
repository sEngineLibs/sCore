package score.utils;

class MathUtils {
	public static inline function arrMax(arr:Array<Dynamic>) {
		var max:Dynamic = arr[0];
		for (i in 1...arr.length)
			if (arr[i] > max)
				max = arr[i];
		return max;
	}

	public static inline function arrMin(arr:Array<Dynamic>) {
		var min:Dynamic = arr[0];
		for (i in 1...arr.length)
			if (arr[i] < min)
				min = arr[i];
		return min;
	}

	public static inline function clamp(x:Dynamic, xmin:Dynamic, xmax:Dynamic) {
		return Math.max(Math.min(x, xmax), xmin);
	}
}
