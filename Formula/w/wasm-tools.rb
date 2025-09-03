class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.238.1.tar.gz"
  sha256 "5035a6c4ffe63fe8267a6cdd23d884a322a7a9400ef8ff4ef2387c6d2d690433"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140b7486b7af83a774b40e109249ffa4515c58a969420feb120538aab56fd20e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd443731d337953daea9e9edb42f8cfec9738f52412294e4622330d243cf3fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3316a0ce61667a4936892b52fed8ab6d745c48a988a682943e9b314c848ae883"
    sha256 cellar: :any_skip_relocation, sonoma:        "75ac0c8b84aa0472ee50500feba835f5c650e2eabeb36367f2ab5f5904eb0bd7"
    sha256 cellar: :any_skip_relocation, ventura:       "c9878638a223887211a5100d00e7357735f31139c4c081992523a0ffc11e84d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1d9a2d6a89e1bf5b298da96eccdb72ac6aa8a2c41018db101d2d12f18fdfef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422d50e4295805bdef96fc783380f8ecb4a860886ed0e550a5e1ed09567fb10a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end