class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v10.0.0",
      revision: "205f8311aba6848184c1c76cf90c93d4ea61433e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d609771e2db88429368a44a6a45eb884abbc2555a6866e8b8416d5a7fc166c8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f29d8f723ea40e66b853e069fd3ba007d350c9f033f6eb65e9a3f56a99a06a14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27b67664a2aeec4bbaba856135d4c67cc2bc4cee912c134a4c6548a05946b65e"
    sha256 cellar: :any_skip_relocation, ventura:        "7c1a874697726e6afc18feb690cb05a7d762c8537d0ac2917a610cbb431c2eda"
    sha256 cellar: :any_skip_relocation, monterey:       "622c114c74123da86fa24b6bb3a49acbc138123f82add7e95315c70e70d385a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c2a26a5bc9d5c898438db7f388a4ee8b338590970e62cb8e9aa871ccb2a0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c50c64c0aa30368894dea58ca27d8e54935055885710a7e928f32340251d9bd"
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