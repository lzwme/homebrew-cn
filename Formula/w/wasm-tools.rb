class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.51.tar.gz"
  sha256 "3d3d1b9ce8b22f64f929040304cf4e0c5ff0f164f32816f0f60f020c2004b0b3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a10b26026dec0f4cea2150327419c8598a1147370eeec1aef925b346decdbd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc2d826383df5cbc48ced3576d2a4ac5706cc68e78c293728b9aa20d30161855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75cf8e65a47743982ed4381876552defea80682b58e5a63f89fad06ba5a49a01"
    sha256 cellar: :any_skip_relocation, sonoma:         "57b7b60eab6561d8631734265603744b5e22b2615239249501006127f07fd0c4"
    sha256 cellar: :any_skip_relocation, ventura:        "61d4dbe59bc188c8f7a085b1796c90a777431288351c92b66cb1c1d5503de6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "a7a9a7c45e22235638079772e37d49c3b621960e629db500f99b0dcf543a8deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a9578ae7ec4fe6f9f2d7179288056ba717989f16e368207b7d637ae4a21e384"
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