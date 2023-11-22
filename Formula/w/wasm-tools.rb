class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.53.tar.gz"
  sha256 "38f906d490038d14a9f14a51231d62c7eb018254634e9bca04507aaeecc29cbf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2e3e48fc6b43e96747890377ad3df8fdde7d7e794a9a19143bb804ac8c5e2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b122f03ef6eb128916c376d9ca32f71b6be8771b48290cf148ea72d8f25516c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295244aab1d109602ccffd3d2831a410ed0eee3c948f331f7fb173541aaeaa67"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ad68b7962b6915378a1f4343d0e563b9e52685bbeb3aa2897fe39a05502c7d"
    sha256 cellar: :any_skip_relocation, ventura:        "c06772077bb1fb643a27b4103a2970601704bf320c93cbb38281edfe281e9a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "4a120091f78c9e7ba39d478325740a5e9e7b94d419c18049267fb8c663bcbc06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa2b7ab21c5041c5e3c5ff11041ae0ec87904a56f6ba946799c4c8c9ceb7e50"
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