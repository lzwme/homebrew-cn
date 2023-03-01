class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.25.tar.gz"
  sha256 "60e3dc26d5e28a58d0244de8edaa63555c4dc9c78c0d20957a94385fa3fd2480"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b052bffabedbe2418fe41f706562e88cc2350a1ba85a315f9abe6e1cc9a3bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "186c16d1395b54cfc7ad94bdbd69e8590a15a3333657179825c8776156c18f80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "988b47d0b3308a8349e8f974056c92db9cdfa01995752b16cd36de0876fd1686"
    sha256 cellar: :any_skip_relocation, ventura:        "8ca8fb1c1170e47ff720d89374b4a3487a231f11d223e2db9ed2ec72d60455d4"
    sha256 cellar: :any_skip_relocation, monterey:       "89b2acbad3a9463a7bc4ae89b70f4e11a7046c34e68794b478a7285d12233046"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18c96a6e5ebf2c97e3a235ca7d3f0835749748290758828e67e31636a0427a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0af903e9362cdcc7f134c015f0cf0483cd35aefb2235cc24ec7327b84315c3"
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