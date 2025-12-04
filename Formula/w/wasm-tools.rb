class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.243.0.tar.gz"
  sha256 "72b575475215082cb1ebe5fe1882c439dfe5b6e22b222914f08a0b214e6a2187"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c08525376c7fe45d332ca5c7527f839b77e7ae0a38b8f4be6107e14781c10b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ba5c25988c6c34f7d25b7ff5f4be9c29185ce91512648bc458370e36ca1e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea5c62ccd1fecac91f2b305314bfe962d7fee438dbfa7c3eaf099daf9e4ba5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "502c0dced8a088db52c30e6c0bba1d257eeaf71b11c632e849e19abbe0efe4fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9426c038fd2875cd334219b0dc48380062b24789f0f2319e5889a5fb2dfc24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd8ee2c7d8b64eae9cdec55cd3c62bec875236f7c16bbd68f43a2b44dbe87c8"
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