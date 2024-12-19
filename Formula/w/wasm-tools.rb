class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.222.0.tar.gz"
  sha256 "50681e7e6d8822ce31cd741e9369011ef771f81a7151a02777c9558df47712c9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28894934211027410fb330cb74b405400520d273d64d39837df4cc1149125a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4f960d5a534c9385dd1babe60ce760ef357142c1378ec74e01f8814cabd093c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5ac86f9704f527dec37448ec10088d397971f5ab22044e28bb6cf6c92b4d669"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da4489cbfff0c9b28be0fe3669fc1b4653da6a65b33893ffdb55240234420d5"
    sha256 cellar: :any_skip_relocation, ventura:       "36800a0bb08105469f882c2ebb447f19bade4ae2b20b2393bfa1a5701b3aa957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81110f8a9eb7e9dc19bb215daa48c42ec996b55b81db77e74f921f4098d883b9"
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