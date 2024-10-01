class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.218.0.tar.gz"
  sha256 "01949eb91f5f99bb7c7bc0ed8c326d8c2a471371a7a5ef0176226350bcbe7dc2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cec6da5a6533ff52724c846ba6b8b7e94747c616db9ee103f16bb97eda41f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b9e9a1c941e19555fc8f17bbdb502469bbdcadb4b580b02478f8362810951a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ec579ad006a5b76870a973cec4a9eb9209d292d1e5c9c75f11b4d5a524b42ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6200fbc6743336c9550e5eb2a7eb5367c2744c88e2b6e107f7deece02f19702a"
    sha256 cellar: :any_skip_relocation, ventura:       "0336306b8486766b2e3fccb80886612388c2a96f9eefefb381ea3007c57c2403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2039252879b78550bcac2ef4161c6d06a8b38c1a496ae16074f1fb37026e9e1b"
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