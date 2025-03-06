class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.227.0.tar.gz"
  sha256 "d9d406ed03c3fa156907759a48ade8e73bf7c98c68a2f491bf1d49f809eca9c7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4072d2e3cf26c8813791d4d717759237bf400c71de66541554b92005c5533b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97821906cc2f756d174a4cb9a871f23057eaa03fab2a4739bbb5ec63ef31c03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bbc5c303d82fda47de94e7da40c17b456d38c071942af3a71570cf947201ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d374f2d07618cd74700c65007fd43307b147b24170eb1dd9152ce79da755d936"
    sha256 cellar: :any_skip_relocation, ventura:       "049e00eb7b438ddc39a78cb122f93a7c293602916547e2981c8d19dc17d26481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ee04610373df63dd16eb28a4b0c590d99f188aa14063b755868736a5180744"
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