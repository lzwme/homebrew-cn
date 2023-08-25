class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v12.0.1",
      revision: "6116aae3d4cdcc2ec9f385a0146a93240f009cca"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8277c83802794cd5fa15c04a854666db3d58e275fece2da261c190e26e9efb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ccf3c08014e704932eab04731374494dbc722682bfb6e6705acdba1b29d8c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3698dd0bedcfd4e3684d6a3b961961f7716e1518937e53d237c27b01df9c88e2"
    sha256 cellar: :any_skip_relocation, ventura:        "bdd22d670e2e686ca28874f4c1bd82d814a41c1e69d1f45719fa174f1160f8a4"
    sha256 cellar: :any_skip_relocation, monterey:       "1a34c29b3ecd2982611a3e76dde852032ed5d9adae7f878c860c802b96b83f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6166197527167a7b9f63be61caef79518185d070cdb5fce8231e89197bfa5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9e13d6742f7bc9a44da193f5cc96d1b65af339ad6463e2f684141d8557d38f"
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