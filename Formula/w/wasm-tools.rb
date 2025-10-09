class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.240.0.tar.gz"
  sha256 "be7c6eab474a40684a997b85fc608ce7a3ce172848a7fcbcecf3b68534a44cf5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0da05ed9b6bb5ab308fc3f5c35ecefc7419830dbe266c78919b4f38f34e7401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b4968383d3b4a9b21e8d519d72f13f55f2d47f1ae6f3f02e7d1d695f9f5806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad3b29ece01cb3596378c533cadc50d86ec575db68117b414c4b21ea07e5285b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd08a822f26480e64624e500af7a74d0a9accf70201e432bb3e5c6bde39626bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3183d512d8728c445307cacf428410d50a1c7d043ea33c2547b6b75f9e67393f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6768f3a6f860a956d871bb495ea667f668acd0323790d1b9c78d39bcd71a4c7"
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