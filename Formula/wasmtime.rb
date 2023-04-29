class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v8.0.1",
      revision: "207cd1ce15ecc504dafaec490c5eae801cac4691"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac62ebbe5c38a18dfc11167d74b94d5fafcbd27ca26dbc942200870c5e95c06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44db6fa8145f777de1a3090e23792bd0bc65b07cf84656796415de6aa65d6376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "730efb54783195c980c0fbf6cc80e24d63d4a0c4f4ec616dd2b052b0d48f8952"
    sha256 cellar: :any_skip_relocation, ventura:        "4940170b5dfc850d9a8d10b05faa1ed987f069c3dcac61d92f3c3c3dc6f07004"
    sha256 cellar: :any_skip_relocation, monterey:       "7b39d83eb9f74fde4bdf01208d243132d92971cf3f190b4d2488bf3ebaffc6ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e59e89ee3205c0b47708b55d4a22746d2c31da2379926c89b3214d523956096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf4d0de520fd432ac61c9f3b3cb9f2b54573fd371b55f5a37ecaefcd1010bce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end