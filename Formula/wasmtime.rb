class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v9.0.1",
      revision: "1bfe4b551baaec3ed778fe9e63327ca35a36ae88"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "995d70fd67ef24e093032469cae73374d9fd1d31300d27117da50d8c516e0020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f15d0af0c3c85baef33992081defa7788fe655af2d5d65f8fd97580e306cfbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e26e54c3c8e4802e8d51fc7cf62b696cd5f186e86fae8c867ac2c20c309fb26f"
    sha256 cellar: :any_skip_relocation, ventura:        "116f986dac93e588c846a4ba455b986a59d2397a6e504e36e339c745e143d23e"
    sha256 cellar: :any_skip_relocation, monterey:       "c5dd797648e1928a17b40e9ea40f505e2b65be1662c4be4fe45df1566bffb6b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c960b5d43c3e1064bfe730b96cb498bed992629b0c465a4894932431a6fd223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e215a157ec5823bb80eeb8dff5de56a0c8603062d47f34c80bfb1d95d667c8d4"
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