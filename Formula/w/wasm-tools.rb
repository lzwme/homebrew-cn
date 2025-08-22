class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.237.0.tar.gz"
  sha256 "2535c04aea290b0d6f7d508895e6cd2d1e27439fae1d513d1e3778d3c841c700"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55c0e5652ab774246e240aa993c7786a3692860da85a575551fabb84dc351ecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238f08ac0b5957fe8079ed3629d389ff338cd672ec70f80c1240fe0961a533f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f55796d7a4abc33920f0becf32dfcd35b23d4440c5129568a020e0e9be6768"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dab44e562e33f4773aa0cc41512e22cad3c81ac0067c023a137f0cd974a0a91"
    sha256 cellar: :any_skip_relocation, ventura:       "4e0a82878ea3384d33c45f04a1b0367fcde2a6ebe0a0bd28d9a45a613b407e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1212c16ab53e7d2563674a0ca88928295bc1e94ff2a56e009719c5db02b7a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4675e2b1ebca0b3a1a7f218998e27ddd1695d387714af5a3abf26fea021dcb51"
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