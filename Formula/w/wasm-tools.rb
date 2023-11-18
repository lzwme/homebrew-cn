class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.52.tar.gz"
  sha256 "188931937255b0f8301af21eeef241553f71c7a178ab46af9af27f17a21bd71f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abeecfccf44cf67c11f2bb7065785f90214d4af09bee0763b6a2adbcc4bc22db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72145fbaa4d8fc08a4f6aa8a02f3f555c684e26c04ff37832a962d4f1e2ed563"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ee62f9c5c642eeb3bc4ffc3eab53b75d03785daa97446f17e19dedf7816919"
    sha256 cellar: :any_skip_relocation, sonoma:         "e06a96b8ea49d3187590c344cc07092b26220d7e983d41de0894c0ef9ae4b33c"
    sha256 cellar: :any_skip_relocation, ventura:        "d43d619500e3e7fc69bada17e4e5bb0435310248923fa004843a48e40bdc6850"
    sha256 cellar: :any_skip_relocation, monterey:       "2a48b7a259273398f1a7382f4756195344a1d5e660b6579103a72db2c9e57d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4d687cc8a312cc6324e0fb0438bc1fbed2b87ebb307a59dcce485f66e502da"
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