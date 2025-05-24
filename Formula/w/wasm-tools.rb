class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.231.0.tar.gz"
  sha256 "d5c3961f25d0dfd407e2b7674a8d51ce7ce47b2b4d00f75172d7f079cacfc309"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de3ae992a327a568e0d0dfefa15fb26404a1e09a85ab96209cb832f62c5d3cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130c4136da2576b36d6a4157e442038b01100cb37ab81ed5de6c92f557fe79be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc087117c265648c7efb61c0d946b6aab2a37ed9bcb25965a42052358d3bd2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "081027212365b0d64b6bee45561b1cd0a62d20963ea5a3530c2e3be5e86d56cb"
    sha256 cellar: :any_skip_relocation, ventura:       "733b16427bf872084db4fe40b4ba7d20650069e88059997cb742c3427717cde7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd9435bfcd001c34558367818dc8abb541ba5293c80575c039328d19bc34a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d58414cff20e0fc364fed4105179f4f29c139b091adad64275cdcd8203711b"
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
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end