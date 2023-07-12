class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.36.tar.gz"
  sha256 "ccda1b1aa13a61275ed92227b20119655e666241f4eeca14329e446fab8d5599"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa68602fadab15d53456a1429a476612600f8379e404381e23543456344abc1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc5ee618bd5442d56680b61fc76a4966bce34d718da4eef482bf31c2c096529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79cb6ffb0aefa592875564305c4d5d951e48661be1591d6be5d167493277636b"
    sha256 cellar: :any_skip_relocation, ventura:        "01362d429c352cd9c7cce543a7f7faa94c566f38ada153e4cbc38e95addb22ec"
    sha256 cellar: :any_skip_relocation, monterey:       "c25f4ffe9f6c4c02091067129612f7a5d4738834898ee636b7f9bf55ac3cd108"
    sha256 cellar: :any_skip_relocation, big_sur:        "60faa8a117c3eb53c69c2a3b7156ed157d4d3cf53c4df0be1d810e91019824af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3fc0b2e5bb6bec6cb7be74ada5675dbe83b92e3d44afe83b4f03e28d545b70c"
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