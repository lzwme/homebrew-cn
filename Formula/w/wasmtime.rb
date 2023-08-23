class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v12.0.0",
      revision: "54cbe5f4509a67c9791bcd89dd6c14ffb5b67799"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdac492554e5d0874b6e17331db2e788be4649c7c2df9f8f04a76ac21102d06e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c989704bd5917d9ebc8884404394936e470254c3e27cb2b72a32893c0d44ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6344afbf25e9249bd04f80d588452c97c783985d67fbd64453f9951304d6f66"
    sha256 cellar: :any_skip_relocation, ventura:        "54e1867a2a6ced86d131d146411e711d1ddd26f8549a7b39d4027dd6c230134d"
    sha256 cellar: :any_skip_relocation, monterey:       "bafb523320f429a21c81b1cf0d6dce75bce165d6092e64c045b67fca63c78e5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d508b33d6c5b7691bc45ad8a2d233857901b1ac9915a30b88c735a4a5fab32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ebe2e570c708b915de93d9eff0e068da3c82acdfc620a6446da10c2c66ca46"
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