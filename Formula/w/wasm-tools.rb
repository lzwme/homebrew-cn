class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.234.0.tar.gz"
  sha256 "9d9d92952985c3b25163aec24e998e9423bd0c207597163c03728f7de3de6b12"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1a8be8880f11d7b68c8819c7cbed5dc3b6896df9c2d0dfc929a3eb21a2cc5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c87bfda1dfe50ee356516b1a84c648f5eb3ca883dd2c2f691cd2a495d49147c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f16783593eb7f2ef141aae8a136dc56c42d26b789f72951c711cfa786a743a1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6f9da1ce51d51c165b3bdd866f1e0a059d5e3ba59741c33db441dd4fa56975"
    sha256 cellar: :any_skip_relocation, ventura:       "7f1947399753f9c8a47749b58f4111819377f4ed8129416db876064b615b9baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3454feb97c1291cdb212431b197e9319d78a7218885e8ce625067c3cec3a38da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ce92eff045e3525c965b9df184e364801c9341b8426f70f27e4c1128d32ec7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

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
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end