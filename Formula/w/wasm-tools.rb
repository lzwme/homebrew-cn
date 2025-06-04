class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.233.0.tar.gz"
  sha256 "4bc9ebd2f915193e40556d087670cf3555ee13fa98afc78d731428e1ed664707"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ceb184bdee27c9f37f2359f6d203efda403a15c6a16ea89bd2110f2cb64d817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74807cf663e9cecfbcfaa1c4817854058ffc387f7e571c604088ac5d377ced68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a46ab1f93b0c8f616c59a82d2327dbc9c4336560c9450a7616b88a51cc8cae08"
    sha256 cellar: :any_skip_relocation, sonoma:        "009f383cf282cf1d555ffe5213dabb178bfef9423a3356525a1a3e570c65ba44"
    sha256 cellar: :any_skip_relocation, ventura:       "11ff463be22d6b4dcffe9e01318bd3fa37ccc39436965eb519c77e8d995deb8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3e2edaf026e8909c5a5f18f91c1ebf516103e5b93ca3375411911358570dc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924a3aa756b39513cdfee1955f7e0b4643f3c843401e31258ee22c6d0a399b9e"
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