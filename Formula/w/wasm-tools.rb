class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagswasm-tools-1.0.54.tar.gz"
  sha256 "3d6d53800409aac71ba6c425525fd4135b6661254af50f15da3cbb667ee12162"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^wasm-tools[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "132afdb00725367c587e0263bda36a844418209c085bb65bb2980806470ca0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a0403872743b15176448222cb3c066bd0b3ed34e8eda1f743e3d241ba8b028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbc46fa641c3ab9395649cb2005f3ed63b9f8a8ff5f18de8a070bc3f237314c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a85f99bb623c3d21202c587c9fb849c25c0593b23d8790d32b9035f31ff10f2"
    sha256 cellar: :any_skip_relocation, ventura:        "23f613f6ff2e06a4c651f7b04940aef26ebf9222de46b5793c7e732b9c38b182"
    sha256 cellar: :any_skip_relocation, monterey:       "61bf4c600101b57b0cb6f3c8d8cf136d0beba7f0b7618f99ecc6588893b14175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d6bbda605c797b71589e4f396b2c8020aacc1646abb1284260ca4dd9ed3a98"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

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
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end