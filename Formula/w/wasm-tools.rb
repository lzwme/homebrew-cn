class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.48.tar.gz"
  sha256 "c842e9ab62866b8de1d9b513cd205854c261b885051650b35f26f9c8b8644599"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06b62853236d4bcb0a5b4ccf3474fb17ebb32842fe7985666aae762037333d34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f373b79ae4d83be5654f7c7e937ce22d1681e5b4c4d517cdd3b0c58ce0f346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23667e27b5eee1d7c0d28cf1743e4ac668d7c057eade1c9d548ae701e1c3f0ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c08ad7ae5953b25299cc37d1270fe98603a458a2ac763f526603cf6937e1cc72"
    sha256 cellar: :any_skip_relocation, ventura:        "d24d9204a52286f012e04844de16b627e6fc8ba23193793faa0ec6e8a74bc387"
    sha256 cellar: :any_skip_relocation, monterey:       "ee04d918d4a4de051d8274457fcd8d29e9faf3b1adb68ea6d02c457e6fcd8ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a121ddb923a91cc7f9d09c155969d6bb166921860606ab22a1cc50396e19e5"
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