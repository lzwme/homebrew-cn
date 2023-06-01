class NagaCli < Formula
  desc "Shader translation command-line tool"
  homepage "https://github.com/gfx-rs/naga"
  url "https://ghproxy.com/https://github.com/gfx-rs/naga/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "4e1373e92b8e4dd3ff70ace98c2f06e9b312dc21f416ddec0f91956ef978ff71"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/gfx-rs/naga.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cc0aedbb5a1c86af69bfcfc7084008984e0c3d51f6b5d855bf0171854d341e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac95194f3254a798e68bd198432343d84015b8e793040bebba2e10d8e081a35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6fc81c5bef995d4cbf386920afe608ae493faa4fe9055187a1116704203a892"
    sha256 cellar: :any_skip_relocation, ventura:        "a8140304b90d1fab0a5039712da129f30a6716c2a3c814eb77c9d3aac63e08bd"
    sha256 cellar: :any_skip_relocation, monterey:       "61326122cda9eabffb395916f5661d7244ae9292228f842e8cf512d1de192fc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c7ffb69500087c4fbf5654c15582925bae1cffaef7a30ff99ce866b2b295cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8315f195935b14b1d6cfd49e19910731e9ddc5f6d4269a8e475105f477e0fc0a"
  end

  depends_on "rust" => :build

  conflicts_with "naga", because: "both install `naga` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # sample taken from the Naga test suite
    test_wgsl = testpath/"test.wgsl"
    test_wgsl.write <<~EOF
      @fragment
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return (x + y) * z;
      }
    EOF
    assert_equal "Validation successful", shell_output("#{bin/"naga"} #{test_wgsl}").strip
    test_out_wgsl = testpath/"test_out.wgsl"
    test_out_frag = testpath/"test_out.frag"
    test_out_metal = testpath/"test_out.metal"
    test_out_hlsl = testpath/"test_out.hlsl"
    test_out_dot = testpath/"test_out.dot"
    system bin/"naga", test_wgsl, test_out_wgsl, test_out_frag, test_out_metal, test_out_hlsl, test_out_dot,
           "--profile", "es310", "--entry-point", "derivatives"
    assert_equal test_out_wgsl.read, <<~EOF
      @fragment#{" "}
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return ((x + y) * z);
      }
    EOF
    assert_equal test_out_frag.read, <<~EOF
      #version 310 es

      precision highp float;
      precision highp int;

      layout(location = 0) out vec4 _fs2p_location0;

      void main() {
          vec4 foo = gl_FragCoord;
          vec4 x = dFdx(foo);
          vec4 y = dFdy(foo);
          vec4 z = fwidth(foo);
          _fs2p_location0 = ((x + y) * z);
          return;
      }

    EOF
    assert_equal test_out_metal.read, <<~EOF
      // language: metal2.0
      #include <metal_stdlib>
      #include <simd/simd.h>

      using metal::uint;


      struct derivativesInput {
      };
      struct derivativesOutput {
          metal::float4 member [[color(0)]];
      };
      fragment derivativesOutput derivatives(
        metal::float4 foo [[position]]
      ) {
          metal::float4 x = metal::dfdx(foo);
          metal::float4 y = metal::dfdy(foo);
          metal::float4 z = metal::fwidth(foo);
          return derivativesOutput { (x + y) * z };
      }
    EOF
    assert_equal test_out_hlsl.read, <<~EOF

      struct FragmentInput_derivatives {
          float4 foo_1 : SV_Position;
      };

      float4 derivatives(FragmentInput_derivatives fragmentinput_derivatives) : SV_Target0
      {
          float4 foo = fragmentinput_derivatives.foo_1;
          float4 x = ddx(foo);
          float4 y = ddy(foo);
          float4 z = fwidth(foo);
          return ((x + y) * z);
      }
    EOF
    assert_equal test_out_dot.read, <<~EOF
      digraph Module {
      	subgraph cluster_globals {
      		label="Globals"
      	}
      	subgraph cluster_ep0 {
      		label="Fragment/'derivatives'"
      		node [ style=filled ]
      		ep0_e0 [ color="#8dd3c7" label="[1] Argument[0]" ]
      		ep0_e1 [ color="#fccde5" label="[2] dXNone" ]
      		ep0_e0 -> ep0_e1 [ label="" ]
      		ep0_e2 [ color="#fccde5" label="[3] dYNone" ]
      		ep0_e0 -> ep0_e2 [ label="" ]
      		ep0_e3 [ color="#fccde5" label="[4] dWidthNone" ]
      		ep0_e0 -> ep0_e3 [ label="" ]
      		ep0_e4 [ color="#fdb462" label="[5] Add" ]
      		ep0_e2 -> ep0_e4 [ label="right" ]
      		ep0_e1 -> ep0_e4 [ label="left" ]
      		ep0_e5 [ color="#fdb462" label="[6] Multiply" ]
      		ep0_e3 -> ep0_e5 [ label="right" ]
      		ep0_e4 -> ep0_e5 [ label="left" ]
      		ep0_s0 [ shape=square label="Root" ]
      		ep0_s1 [ shape=square label="Emit" ]
      		ep0_s2 [ shape=square label="Emit" ]
      		ep0_s3 [ shape=square label="Emit" ]
      		ep0_s4 [ shape=square label="Emit" ]
      		ep0_s5 [ shape=square label="Return" ]
      		ep0_s0 -> ep0_s1 [ arrowhead=tee label="" ]
      		ep0_s1 -> ep0_s2 [ arrowhead=tee label="" ]
      		ep0_s2 -> ep0_s3 [ arrowhead=tee label="" ]
      		ep0_s3 -> ep0_s4 [ arrowhead=tee label="" ]
      		ep0_s4 -> ep0_s5 [ arrowhead=tee label="" ]
      		ep0_e5 -> ep0_s5 [ label="value" ]
      		ep0_s1 -> ep0_e1 [ style=dotted ]
      		ep0_s2 -> ep0_e2 [ style=dotted ]
      		ep0_s3 -> ep0_e3 [ style=dotted ]
      		ep0_s4 -> ep0_e4 [ style=dotted ]
      		ep0_s4 -> ep0_e5 [ style=dotted ]
      	}
      }
    EOF
  end
end