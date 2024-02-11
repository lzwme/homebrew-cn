class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagswasm-tools-1.0.58.tar.gz"
  sha256 "3e1ae42087b60f84d40d68aa74bc6472289b265a16c6ed55627d815cec82d337"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^wasm-tools[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb4a33b54f973b5e59b4f11062dd43aef0b514d3f9f71e6d69c3f6a1ab6fc21f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "012501ec5c8e0e77685ab97cb019c694397d2e50beae6401ace2f88c8b596a26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1b1ad0287fb69b38b1979a4b1166af45d636ffcdc96ec9b2d52562043e9368"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ca38e148742b8822d88381d08c3c6acea7267159b74b65b220a70f62a4cca5d"
    sha256 cellar: :any_skip_relocation, ventura:        "6ad2a9cf0c135a4537a1e6cc95592d7337e1078b6303e8760bd4e0491ecee81b"
    sha256 cellar: :any_skip_relocation, monterey:       "c317a10d404a9c5347188df53585763d3de68b026098f1d6c3459d3d4be4da36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa62c47d16b97327a7acd1e1c221d46802d1a8dcf3afd1b67c5bac88ad33b4b"
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