class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.236.0.tar.gz"
  sha256 "c4692ff747b4f3fac2094f1636c8f4bb86b64e7bbca9d0c402328bc7b736a9fe"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc72b6c78ee2778961555df288c7eb92ea1bfde36e3ebacb1ea94062afa2fa3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b91e6b152d8575bd71db68631c7313a0400060a1f28b2c51604932472b6c09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b0e5736697a637a0673d900149b11e9f2fde065eeadf47f3a4b91bcfade3daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a0e61c0fc02c6e88d0a1208124f539251558239a04a0a07a5fd16e6f8c55f9"
    sha256 cellar: :any_skip_relocation, ventura:       "c4e730f10587030f179387c62f2a316999684bcd9e40e08ce400327f3604aba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d23489f3142a12695a9eb572244f376860c9b50eb2326ccebcc1df492331762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24b451a1c9d0ce5f9fd7f66292734375ea45b0590cf6c5effe4c9427fa9bea49"
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