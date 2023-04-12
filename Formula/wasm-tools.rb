class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.28.tar.gz"
  sha256 "ff3b351b05b790d89e703865c201aa202aa720aeb3f9ce7d4d0ce23943130e30"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1982b57ec1c1e6fa804ce647972eb6807cb9c426b84a25e601bded3cb4def38d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ebc11b0584b64a483cf28f23eef159172856eb870612ae25ac1fa8eebcdbd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4c99887f2e513671aeab577919c8d05c049d809a47876ee9eb9d6c0d43a2bcf"
    sha256 cellar: :any_skip_relocation, ventura:        "4079fe4c333faa64f7cd9746053d36e7941cc0fb32eeef1e8404339191fb2358"
    sha256 cellar: :any_skip_relocation, monterey:       "15e9d8b3335f2a72ef0d140d37707424785030f3d7e5902ba8dfccb34652c7a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8577ee5282f6cd711508a75583a25bb2f869a8b9de4dbc736502ab25fd7d5445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d364a48b861740a070e5aaf2885956aa1eff77ef55bee86e421911dfeb598e4e"
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