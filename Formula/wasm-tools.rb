class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.38.tar.gz"
  sha256 "d0009455c4616c81c85e0b97ba171537c1da73f02009fcea611a0b10cc109351"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f22bba7a6b7328d5259e3146242c17113e7a24fc04763a889516c60f3c3cb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77fc4b4ac0761309b6fc8df75fe4df149c85901458e1c88748d62a155c4ec386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1812a5cefeedaae6239e488a73e4cbcfcab387e9124fd0aefe895335c22307f5"
    sha256 cellar: :any_skip_relocation, ventura:        "223d85ecc5d2e4cd6a863981aad5b2bf65787624a66f998faf959c68db7ad696"
    sha256 cellar: :any_skip_relocation, monterey:       "995271b6c159833829f042fda94bcb59a5a98cf99e0387c9abddbda6d2444a24"
    sha256 cellar: :any_skip_relocation, big_sur:        "44325d0715e493daf6488d82a57161e482c48b43c91d0f33e598f1f1fe5c5335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d669845f957dbda08d6b1397f8948801a479a0a73789cde1f2de68821c6549"
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