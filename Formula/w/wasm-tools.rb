class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.217.0.tar.gz"
  sha256 "69fde3c83e307c18d7bad46e1ceccdd1d8dcf9fd51392a313ea20cc4c69826b7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b10de3476acdd27d69ce385e44b8204dd28db2e9adb4bced0d91bee68298f45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5c65551401cfbba371f719decefddb5b7014e8efa6fd3be0779f21796f26640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5202fb3fab073c4fc2330cf3a6cd49e5a495c245f65ec43e4dff995b7946fcbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cd7ee8037e38c96baf5ebaa93995347a40ea6ee561cb575b173fefe901029e9"
    sha256 cellar: :any_skip_relocation, ventura:        "e22bc75189637c5990260ec0b54d4e4748cc58595c115765fc99f057c03281d2"
    sha256 cellar: :any_skip_relocation, monterey:       "3178fcf44fb960045de747c25bd3c97cbb3879fa8b658948a905e74daa8c1250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6af74edd29141cfc2658f9b71110c7cadbfd8b10a378d8eb2e5f6ba48fc3138"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

    expected = <<~EOS
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
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end