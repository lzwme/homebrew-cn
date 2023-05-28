class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v9.0.2",
      revision: "0aa00479c9fbb39ef19a9f35d2ed0137454c93f5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b13b03d49f144822b091a05e8c25c258ccfe1371f87128ac0c566a7dbebd3c6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef25d52bbceecada536cc258929e83350b17c816b25cca7bbe21765b5dd1a804"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21348e98bd1f9aa4c84fa220161507d8d097d1adbcdb3bef4db0581ee03de6f"
    sha256 cellar: :any_skip_relocation, ventura:        "8c7e7a78c24c95f2064615bb5e4d4cd4d2f99ef86da9fc18eda3d304ba7ba59c"
    sha256 cellar: :any_skip_relocation, monterey:       "d9998bf618691e2dd9d6a5e8775b18e4283787f4345b6dd71dc6c7cfafab40f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff057e8ea26ebab012cec3e0d329cb6a3c2f125b4ef87bda0581de89cbf7b2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680a4f0868499c04a431512dbb8b719f4ef3ed96448227ef263bbc8682f60013"
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