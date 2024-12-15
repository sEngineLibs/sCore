package score.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;

using score.macro.MacroExt;
using score.utils.StringExt;

class SMacro {
	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (field in fields)
			if (field.meta != null)
				for (meta in field.meta) {
					if (meta.name == "alias")
						buildAlias(field, fields);
					if (meta.name == "readonly")
						buildReadonly(field, fields);
					if (meta.name == "observable")
						buildObservable(field, fields);
				}

		return fields;
	}

	public static inline function buildAlias(field:Field, fields:Array<Field>) {
		switch (field.kind) {
			case FVar(varType, e):
				field.meta.push({name: ":isVar", pos: Context.currentPos()});
				field.kind = FProp("get", "set", varType, e);
				fields.push({
					pos: Context.currentPos(),
					name: 'get_${field.name}',
					access: [AInline, APrivate],
					meta: [],
					kind: FFun({
						ret: null,
						expr: macro {
							return $e;
						},
						args: []
					})
				});
				fields.push({
					pos: Context.currentPos(),
					name: 'set_${field.name}',
					access: [AInline, APrivate],
					meta: [],
					kind: FFun({
						ret: varType,
						expr: macro {
							$e = v;
							return v;
						},
						args: [
							{
								value: null,
								type: varType,
								opt: false,
								name: "v"
							}
						]
					})
				});
			case _:
				null;
		}
	}

	public static inline function buildReadonly(field:Field, fields:Array<Field>) {
		switch (field.kind) {
			case FVar(varType, e):
				field.meta.push({name: ":isVar", pos: Context.currentPos()});
				field.kind = FProp("default", "null", varType, e);
			case _:
				null;
		}
	}

	public static inline function buildObservable(field:Field, fields:Array<Field>) {
		switch (field.kind) {
			case FVar(varType, e):
				field.meta.push({name: ":isVar", pos: Context.currentPos()});
				field.kind = FProp("default", "set", varType, e);

				var listenersName = '${field.name}Listeners';
				fields.push({
					pos: Context.currentPos(),
					name: listenersName,
					access: [APrivate],
					kind: FVar(macro :Array<$varType->Void>, macro [])
				});

				var listenersRef = listenersName.resolve();
				fields.push({
					pos: Context.currentPos(),
					name: 'add${field.name.capitalize()}Listener',
					kind: FFun({
						ret: macro :Int,
						args: [
							{
								name: 'f',
								type: macro :$varType->Void,
								opt: false
							}
						],
						expr: macro {
							$listenersRef.push($i{'f'});
							return $listenersRef.length - 1;
						}
					}),
					access: [ADynamic, APublic]
				});

				fields.push({
					pos: Context.currentPos(),
					name: 'remove${field.name.capitalize()}Listener',
					kind: FFun({
						args: [
							{
								name: 'listenerID',
								type: macro :Int,
								opt: false
							}
						],
						expr: macro {
							$listenersRef.splice(listenerID, 1);
						}
					}),
					access: [ADynamic, APublic]
				});

				var variableRef = field.name.resolve();
				fields.push({
					pos: Context.currentPos(),
					name: 'set_${field.name}',
					access: [AInline, APrivate],
					meta: [],
					kind: FFun({
						ret: varType,
						expr: macro {
							var from = $variableRef;
							$variableRef = v;
							for (f in $listenersRef)
								f(v);
							return $variableRef;
						},
						args: [
							{
								value: null,
								type: varType,
								opt: false,
								name: "v"
							}
						]
					}),
				});
			case _:
				null;
		}
	}
}
