class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagswasm-tools-1.0.55.tar.gz"
  sha256 "bada1fc4b4f10532d6ba7bc453f535385204fa384e27f229368e3936d5da4a7e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^wasm-tools[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df247347cb05a17e30ee6e785ce2249cf58a3ac85356825699ec1816f97b5c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12b228ea950b297b81b462c6fd1495410b92b002e4b9b38a5676443ef81d4f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4a258c50de5f538622bae0d97894e2ca8f7f7d2f72e5ba4ed376dc17dfd9ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e65a8fac768baa0195edfa59befbc0cba98ed0d79fe8e221111d37c6ce796fb"
    sha256 cellar: :any_skip_relocation, ventura:        "0e7797ef5cf51bfae0726e3531111e9945d46a6dae1aa7e84064fcc9befc76af"
    sha256 cellar: :any_skip_relocation, monterey:       "21c53c19dd9509bd545e6742a2b90eb70c3152303117ade6186e360a4fe54bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02947da009ad9133e822002234febdae2d8b13ff0d8122b2a146ccf5327ba0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

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
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end