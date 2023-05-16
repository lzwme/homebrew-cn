class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.32.tar.gz"
  sha256 "8e00c720d50b6533c63a7e9777f60f786e2425c3163b355a364e0e0a6f61ebba"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f84855c95814be969ad8f932f5b6a2df3f6c156f85b81fffae4aa015118f763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08a71c79e9bb502f4e454bbc9869ed4287c1b7678458e8e91c845f6c118f6507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c74c6245e9a2472fa4f3a1bdd4f4af79aae642f73d698e87c4a21f9f8ab9c496"
    sha256 cellar: :any_skip_relocation, ventura:        "849d1ce1d9d84ea9a67c833c4fb4a87d45206bf843e0a2c1897a8800836ddbf6"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d2383625184cf357fed67e913c30c141ecb723ebde43e5da483c7856d92a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a3480e1e1f751a4305fa1f11f3812d460b67fd94a930008360e63bc8c9bff31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f9051dd1201bef77e3981b300a95d472dbf4010e0a9be6da070dbdb3ab1ea5"
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