class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.236.1.tar.gz"
  sha256 "444c73c3e94a9879ae831fef95444e3c866f73d53874726d557d6458db175e58"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd66adeb82a58ea03acd7a0b6383f87f9d24a2b7bc0c7fe25114b018d8afd74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d61a6cfe6500006b7a46dbbb362fbae8c88025ad23a6c100e6c322806e4172e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4125f99f8e2696bbe33c6bf3ff41b10c96b0e7f061f68acb196b203534b1b1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0565b2e15b7d26a5ec802c08572b4bfa2f83a13151f8dabfcf4f14c5c3b2ef74"
    sha256 cellar: :any_skip_relocation, ventura:       "9fd34bd8d5b0f6f9a41c23e17e82012e50bae35ecf4000998941818c6701c77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95d923844e60eb2b6a789304dfacf893530f97a242da7b322027fa91b61d24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce4a651190016857a9682d1528193cb0b24331cc311aca7e0a76df76fbf9d0b"
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