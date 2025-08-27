class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.238.0.tar.gz"
  sha256 "eaab6b59c75e875b8bf82b89dd74878d0b78abb06696dc08bce91163d2a1d274"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee657e592101b9f1edae2679df875179e5a473b317c31d7eea508fcef1f39cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e4f1e2d7f0e8ffa3c6430d0face1ae596781c47c6ffc5225215400c83ba106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e071dc7f96c47e7af5774394c9b2ddc8bd927f2f1925f65717ffcf78163393c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e6a1d3dd8454ae4a7f28c6bce8b6db0a6b0103e9edd923206dd9c038b480bd"
    sha256 cellar: :any_skip_relocation, ventura:       "7db06963c8998941bfa5a7a04ad9eadd4b21e17be6dde94529093bc9777c49a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbdbc1ef6385ed687f71b463572da14d51cc9f68759c5ae44f1276b05cd9311d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e13905034700d9a2574fae1b784934347c1866531e87c750ecff150bf7e9491"
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