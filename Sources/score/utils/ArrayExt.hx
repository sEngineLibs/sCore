package score.utils;

class ArrayExt {
	public static inline function last<T>(a:Array<T>):T {
		return a[a.length - 1];
	}

	public static inline function min(a:Array<Float>) {
		var m = a[0];
		for (x in a)
			m = Math.min(x, m);
		return m;
	}

	public static inline function max(a:Array<Float>) {
		var m = a[0];
		for (x in a)
			m = Math.max(x, m);
		return m;
	}
}
