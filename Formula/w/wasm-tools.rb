class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.50.tar.gz"
  sha256 "4b840e3860c7e1bb80e9fe838ce752bb1d25dc9a5468b8e9125b2b042fc4b36d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc4b8109a9661636f42aa92f61a17495c502cde204bffa5238c39606dc645a1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8528ef37330b2e27a51d78a9804ac3631c8f894bd2f52852fafa0f45205dbc89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a013ff52d8d30886084f62b7cb04b992fe2d565b72c7804e32ee356523bf1570"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f99180fde73c40c84223fc1d4b8079e5c6ab34c7167c7795aded73443025ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "e3ceb8e6be368263eec7d57a5fdb2cf658a4dcfecc4e1c0534ae576333b905da"
    sha256 cellar: :any_skip_relocation, monterey:       "f37989fe24c0c74acbffd166fde4f244cb23114866419ec83acd38059eceab0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11727e7fbe61716c6b035c117f7f77b6e926c193b32e3ead3c6ae5c78697b9a"
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