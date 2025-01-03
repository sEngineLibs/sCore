package score.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

class MacroExt {
	static public inline function sanitize(pos:Position)
		return if (pos == null) Context.currentPos(); else pos;

	static public inline function field(e:Expr, field, ?pos)
		return at(EField(e, field), pos);

	static public inline function at(e:ExprDef, ?pos:Position)
		return {
			expr: e,
			pos: sanitize(pos)
		};

	static public function drill(parts:Array<String>, ?pos:Position, ?target:Expr) {
		if (target == null)
			target = at(EConst(CIdent(parts.shift())), pos);
		for (part in parts)
			target = field(target, part, pos);
		return target;
	}

	static public inline function resolve(s:String, ?pos)
		return drill(s.split('.'), pos);
}
