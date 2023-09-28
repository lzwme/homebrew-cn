class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.43.tar.gz"
  sha256 "7ad98290312c72b149554ca4a143a416de59f1c00a7e94da1bb2c75a4e171312"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dae86ce488bd8a4b2656c1bd12d960ba40462a5e4c935b8037e9c266cfbb654"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac1464a19e3568cac46b3171ca9dd97f19b1ae13e00db56491652c8156cf1cca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9f47bd066e77c4538e0a9a893918defa6e1bc5c04405a9ffbe28912cf2519e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2b4cc33a1eddc0e6e0a46571f39e4fef727ba70ca4f3e241ad952b5edb8e4f8"
    sha256 cellar: :any_skip_relocation, ventura:        "35f0160583b54c8658d5c7aae7b637da7a2198c2def4b7a2128ada9163b51f29"
    sha256 cellar: :any_skip_relocation, monterey:       "47c9a520ab2e15843b8d2936961e8db82c33f6b4465943b58558bf67e6e3f62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fdaf2c56c59ade96b6c1eec66b1eba2ef3e501d8f35665763afbf16f5776ffb"
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