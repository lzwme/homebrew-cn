class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.31.tar.gz"
  sha256 "e39c2401de7b987be8218676971d1068138498b732648831f6c0b147a9613d78"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92d5aa5dc20f8b2b2dd14fcd8dc58ecabf1a192cb6c7f1e8b4ba332b4f185137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a628e3a92514311904c74e7666f285532f1e299234ca37ba49afd320e2214adb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddb4e895a8efcc516f2a4fdd46c9ff0237347736f6e669cd5201ca5465f098b4"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9b9c5e16ad647e36adb52b7217eb2ba33883265d869fd38ef5347a8509b9b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c42933311831e9c58338a13d1af252c9f6d68489141f69a950788b6bc6e6b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b4d3c0efdccaac36e203f607afe1e28748714cf4210c8ca73026cc4341530e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e001af7a94c95129024e17ff4d8cdc0dfebb64f34e42bd99314638ac2db1ed3b"
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