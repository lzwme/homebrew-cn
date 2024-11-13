class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.220.0.tar.gz"
  sha256 "eba930e6bccf3c14e1e7c8da9e112bbe58439a0746d4e83208294b2993638fc7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9178d4689d4c5981fcba3a28a33acade049d3750b8150ce63d5a61126ad2f96a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e12b3f695db828a14b4e74ab135ff0d8910749c93725b4a5c846969035563b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dd238b99da2acaf94ac564bd73f479283a042d67211ea0c4c4303b297934dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ba7c1122c75e40c1b0e59e7d32ca2ccc7978c05046bedc0d8b90f356b6ef4f"
    sha256 cellar: :any_skip_relocation, ventura:       "dadf528eb7842c57b7e55a8c747ac862ed30bf85055aa524c7eb6909c5262c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c08616959f8882e8d12b8c015d9cf0595da37504de6c07884c3c43fa821a68"
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