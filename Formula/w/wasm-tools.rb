class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagswasm-tools-1.0.57.tar.gz"
  sha256 "434ebdc29025bd9b821c4390d6c3438679cca062e941993853fdc7cbce1ba797"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^wasm-tools[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8a61881f5eb69ac20317a224738ca653962c899b5d5d043c0c9952998817e8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5252fbe003528895b8fdf9fad6ff876a2a5b590c9912ecc2028e1e35f70c7d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b9804643a6fa28881adb0f89b4a76698b45452e29f6fb84928d0940960fa7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "edd3d1341f967bddc47c2e8781c752c9e0497716be6ad63af1f77202766099fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa411ca0ee52d5fea549f0d330ac901d3c8887d7242490f24421c79dffd7ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "a6a6b99754fe7cac33de3e0827fff5773d2e03182018f2dbdb2db9f2ec2c1df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a538bbcfb13752fd7fd47897446ace98d466d2c1ac9cb3fbd1506a6e763a4708"
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