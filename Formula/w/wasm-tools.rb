class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.226.0.tar.gz"
  sha256 "309be504ff75f3810208342036569aa73cd87a44be99157e0529364822b7c3f0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fca461b870ad0daa3b9071e6753d32aebbb8f0d7ee775810a09a7a69b765bc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531cea549f459d2835afdab804046d606aecffff7e4cd809553dd91413529e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fc5507326ff9ef0eb4a3eaf05f6c521f1fc6b9e8777186c2afe646fd84cdb5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b67d9bc51e55e57a17442237109544e947aae8c609db47ccf525a4f471956a"
    sha256 cellar: :any_skip_relocation, ventura:       "cc908c025138e2593d698fe10bdb341e1cbd5557d0ee40d5525cf9a0fd18c9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc3355befe5083a3685a77810f84f79d8b42aaaa6524dcd02e0023fcdb2e534"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

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
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end