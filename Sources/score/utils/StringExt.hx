package score.utils;

class StringExt {
	public static inline function capitalize(word:String):String {
		return word.charAt(0).toUpperCase() + word.substr(1).toLowerCase();
	}

	public static inline function capitalizeWords(str:String, delimiter:String = ' '):String {
		return str.split(delimiter).map(capitalize).join(delimiter);
	}
}
