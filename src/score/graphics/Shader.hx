package score.graphics;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexShader;

class Shader {
	public var pipeline:PipelineState;
	public var structure:VertexStructure;
	public var structSize(get, never):Int;

	inline function get_structSize():Int {
		return structure.byteSize() >> 2;
	}

	public inline function new() {
		initStructure();
	}

	function initStructure() {
		structure = new VertexStructure();
		structure.add("vertCoord", VertexData.Float32_2X);
	}

	public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();
		getUniforms();
	}

	function getUniforms() {}

	function setUniforms(target:Canvas, ?uniforms:Dynamic) {}

	public inline function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, ?uniforms:Dynamic):Void {
		target.g4.setPipeline(pipeline);
		target.g4.setVertexBuffer(vertices);
		target.g4.setIndexBuffer(indices);
		setUniforms(target, uniforms);
		target.g4.drawIndexedVertices();
	}
}
