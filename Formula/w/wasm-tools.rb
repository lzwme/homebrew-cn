class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.44.tar.gz"
  sha256 "dcc16cd1d44963533c38d2de94e75776b7c84497f7a9f9d9a202e076991f57d6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccd9e4c0480c8b3f9287e5309f7b22e5ad9f76a521f1562aa0e4af149c028468"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "298c0dc53b47c4453c58991a16a20c9d57e0ab7b78de00c6a4fd9b9bf9acf027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72525ef2e78c24ea97ec7380f5de664d044ba171cf1ab32518e45d09343486f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "352b0c656bcb6adb916d444c8e0b44b01aff5ab98b5b74f9c66c3de4b162f8af"
    sha256 cellar: :any_skip_relocation, ventura:        "fb40237aff25447bf83628bba13a63eff1fb680495b80be4948f67f4decc8bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "1b2fea89151a85d96bcb97507c5980a3aab981420f479d4a6b1d13af1bc5cfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a13c6ba16048602f74568224a17f23b295c1bdc9522a47d5b627ed53a5b59a"
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