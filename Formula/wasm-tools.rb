class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.37.tar.gz"
  sha256 "58efeb6fdc1b2f5c89a3874d055fa6012785bc4d46e1b99d9986649da4553b8f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d3e89ed42badbb5c14c4a84c8a20f4bc955964f6e4ea77abd0102aa3c75b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4c84dec264759e834e1e77011b36a75beb52a701f51ee939515d40a2233a51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b3771a77911bd7ffa357e1016f9927fe316437202f1a997452ac6a94b29e776"
    sha256 cellar: :any_skip_relocation, ventura:        "4dbdc89799684e60b68112c0e5e3224e4b4e4e0cb68350535ffb6c7191ad7ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "02298ebac73129934270aa0e47d8e6595936bdd02bf531a6e6ad1da1b01fc0d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6494d41d2e6e9a35b7369ede9ad85f26f22683ce554ef6da3dade513162eaf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4fb9840b3ce520759bca5e8028997a8274d65e2b036c321808de5b0ded330c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end