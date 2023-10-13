class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.46.tar.gz"
  sha256 "a7dbdaa0414d433cb84b7b4cad0f3033049de0e95880e8cf31c530a71a8f8537"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baa33fcb62ccae43a767e266a0c5e6d8e865bbd6f26852ff6ff803e115ec2169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af6cfe1cea94572976a004c641876c8bd1a844a4478009da8922c56fb01109a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6364e698c5ff29a49832103bf71f103fffb6481fbfe9f54e3a2f9464f3a0aecc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d05cf3e3971e9a5ce6dc479e701d7673ef7344f436df2a997965373935ba723"
    sha256 cellar: :any_skip_relocation, ventura:        "112681401c69b67e9f9261fbe1900f54d592ad24fca2bd6b39c46cf0a7e9717e"
    sha256 cellar: :any_skip_relocation, monterey:       "256e36cf04f8207995ae864603e637c2cbe90bf72f7b19fe6c141dbee31bc2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82bd42d5ec4a6c185f5111ea4af61f6899ea4b1c162bd07ab4834368dbd722be"
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