class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v11.0.0",
      revision: "92ccdcb8d68b586715957c2335031bc057e4876d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc26a30be0dc768913d748fdd67d1a6f3ab718f8446da2c1d60944c7825e29a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc9372f4d9870bcb8d832b4f2e191f43ea76b1239e4c9317de07bbf14d305c3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edf82c0139529efd25cc5792adcc0879e33cb858d8e952d4213344233889fce"
    sha256 cellar: :any_skip_relocation, ventura:        "6138566712fd62626d1df25734c2c9e79901c66d95054020297b05c427e09900"
    sha256 cellar: :any_skip_relocation, monterey:       "fec45a8c409d02902c2f4250b086d15e7f51e8188503ea92a2f9f2cfd1d2a0e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d5e414db340d4010f608075fb53b926bbf659f19f0d5167316b44d3d00d6c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8273d67e534d49e9fb5f806111df872dfce5238610f7437724e5e6a90875cc5"
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